CREATE OR REPLACE TYPE t_key_value_pair AS OBJECT (
    key_name    VARCHAR2(4000),
    key_value   CLOB
);
/

CREATE OR REPLACE TYPE t_key_value_collection AS TABLE OF t_key_value_pair;
/

create or replace PACKAGE json_utility AS 
     
    /** 
     * Procesa un objeto JSON 
     *  
     * @param p_json_object     - Objeto JSON a procesar 
     * @param p_result_collection - Colección donde se almacenan los resultados 
     * @param p_parent_path     - Ruta padre para claves anidadas 
     * @param p_path_separator  - Separador para la ruta de claves 
     */ 
    PROCEDURE extract_json_pairs( 
        p_json_object       IN  JSON_OBJECT_T, 
        p_result_collection IN OUT t_key_value_collection, 
        p_parent_path       IN  VARCHAR2 DEFAULT NULL, 
        p_path_separator    IN  VARCHAR2 DEFAULT '.' 
    ); 
     
    /** 
     * Función principal que convierte JSON a pares clave-valor 
     * Con soporte completo para arrays y objetos anidados 
     *  
     * @param p_json_input      - JSON de entrada como CLOB 
     * @param p_path_separator  - Separador para rutas de claves 
     * @return Colección de pares clave-valor 
     */ 
    FUNCTION json_to_key_value_pairs( 
        p_json_input       IN CLOB, 
        p_path_separator   IN VARCHAR2 DEFAULT '.' 
    ) RETURN t_key_value_collection PIPELINED; 
     
END json_utility;
/

create or replace PACKAGE BODY json_utility AS 
 
    /** 
     * Procesa recursivamente un objeto JSON con soporte completo para arrays 
     */ 
    PROCEDURE extract_json_pairs( 
        p_json_object       IN  JSON_OBJECT_T, 
        p_result_collection IN OUT t_key_value_collection, 
        p_parent_path       IN  VARCHAR2 DEFAULT NULL, 
        p_path_separator    IN  VARCHAR2 DEFAULT '.' 
    ) IS 
        l_json_keys      JSON_KEY_LIST; 
        l_current_key    VARCHAR2(1000); 
        l_full_path      VARCHAR2(4000); 
        l_json_value     JSON_ELEMENT_T; 
        l_child_object   JSON_OBJECT_T; 
        l_json_array     JSON_ARRAY_T; 
        l_array_element  JSON_ELEMENT_T; 
        l_array_object   JSON_OBJECT_T; 
        l_final_value    CLOB; 
        l_array_path     VARCHAR2(4000); 
         
    BEGIN 
        -- Obtener todas las claves del objeto JSON 
        l_json_keys := p_json_object.get_keys; 
         
        -- Procesar cada clave del objeto 
        FOR i IN 1 .. l_json_keys.COUNT LOOP 
            l_current_key := l_json_keys(i); 
             
            -- Construir la ruta completa de la clave 
            IF p_parent_path IS NOT NULL THEN 
                l_full_path := p_parent_path || p_path_separator || l_current_key; 
            ELSE 
                l_full_path := l_current_key; 
            END IF; 
             
            -- Obtener el valor asociado a la clave 
            l_json_value := p_json_object.get(l_current_key); 
             
            -- Procesar según el tipo de valor 
            IF l_json_value.is_object THEN 
                -- ===== OBJETO ANIDADO ===== 
                l_child_object := TREAT(l_json_value AS JSON_OBJECT_T); 
                 
                extract_json_pairs( 
                    p_json_object       => l_child_object, 
                    p_result_collection => p_result_collection, 
                    p_parent_path       => l_full_path, 
                    p_path_separator    => p_path_separator 
                ); 
                 
            ELSIF l_json_value.is_array THEN 
                -- ===== ARRAY JSON ===== 
                l_json_array := TREAT(l_json_value AS JSON_ARRAY_T); 
                 
                -- Procesar cada elemento del array 
                FOR j IN 0 .. l_json_array.get_size - 1 LOOP 
                    l_array_element := l_json_array.get(j); 
                    l_array_path := l_full_path || '[' || j || ']'; 
                     
                    IF l_array_element.is_object THEN 
                        -- Elemento del array es un objeto 
                        l_array_object := TREAT(l_array_element AS JSON_OBJECT_T); 
                         
                        extract_json_pairs( 
                            p_json_object       => l_array_object, 
                            p_result_collection => p_result_collection, 
                            p_parent_path       => l_array_path, 
                            p_path_separator    => p_path_separator 
                        ); 
                         
                    ELSE 
                        -- Elemento del array es un valor primitivo 
                        -- Usar stringify para obtener el valor como string 
                        l_final_value := l_array_element.stringify; 
                         
                        -- Remover comillas para strings 
                        IF l_array_element.is_string THEN 
                            l_final_value := TRIM('"' FROM l_final_value); 
                        END IF; 
                         
                        -- Agregar elemento del array a la colección 
                        p_result_collection.EXTEND; 
                        p_result_collection(p_result_collection.LAST) := t_key_value_pair( 
                            key_name  => l_array_path, 
                            key_value => l_final_value 
                        ); 
                    END IF; 
                END LOOP; 
                 
            ELSE 
                -- ===== VALOR PRIMITIVO ===== 
                -- Usar stringify y procesar el resultado 
                l_final_value := l_json_value.stringify; 
                 
                -- Para strings, remover las comillas 
                IF l_json_value.is_string THEN 
                    l_final_value := TRIM('"' FROM l_final_value); 
                END IF; 
                 
                -- Agregar valor primitivo a la colección 
                p_result_collection.EXTEND; 
                p_result_collection(p_result_collection.LAST) := t_key_value_pair( 
                    key_name  => l_full_path, 
                    key_value => l_final_value 
                ); 
            END IF; 
             
        END LOOP; 
         
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error en extract_json_pairs: ' || SQLERRM); 
            RAISE; 
    END extract_json_pairs; 
 
    /** 
     * Función principal mejorada con mejor manejo de errores 
     */ 
    FUNCTION json_to_key_value_pairs( 
        p_json_input       IN CLOB, 
        p_path_separator   IN VARCHAR2 DEFAULT '.' 
    ) RETURN t_key_value_collection PIPELINED IS 
         
        l_json_object       JSON_OBJECT_T; 
        l_key_value_pairs   t_key_value_collection := t_key_value_collection(); 
 
        l_clean_json        CLOB; 
         
    BEGIN 
        -- Validar y limpiar entrada 
        IF p_json_input IS NULL OR LENGTH(TRIM(p_json_input)) = 0 THEN 
            RETURN; 
        END IF; 
         
        l_clean_json := TRIM(p_json_input); 
         
        -- Parsear JSON con manejo robusto de errores 
        BEGIN 
            l_json_object := JSON_OBJECT_T.parse(l_clean_json); 
        EXCEPTION 
            WHEN OTHERS THEN 
                -- Intentar método alternativo 
                BEGIN 
                    l_json_object := JSON_OBJECT_T(l_clean_json); 
                EXCEPTION 
                    WHEN OTHERS THEN 
                        DBMS_OUTPUT.PUT_LINE('JSON inválido: ' || SUBSTR(l_clean_json, 1, 100) || '...'); 
                        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM); 
                        RETURN; 
                END; 
        END; 
         
        -- Extraer todos los pares clave-valor 
        extract_json_pairs( 
            p_json_object       => l_json_object, 
            p_result_collection => l_key_value_pairs, 
            p_parent_path       => NULL, 
            p_path_separator    => p_path_separator 
        ); 
         
         -- Retornar resultados con filtrado de seguridad 
        FOR i IN 1 .. l_key_value_pairs.COUNT LOOP 
 
           PIPE ROW(l_key_value_pairs(i));  
        END LOOP;
       
        RETURN; 
         
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error en json_to_key_value_pairs: ' || SQLERRM); 
            RAISE; 
    END json_to_key_value_pairs; 
 
END json_utility;
/