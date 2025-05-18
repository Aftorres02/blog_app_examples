CREATE OR REPLACE VIEW v_demo_hierarchical_report AS
SELECT 
    id,
    parent_id,
    nombre,
    CASE
        WHEN LEVEL = 1 THEN nombre
        WHEN CONNECT_BY_ISLEAF = 1 THEN 
            LPAD(' ', (LEVEL-1)*3, ' ') || '└─ ' || nombre
        ELSE 
            LPAD(' ', (LEVEL-1)*3, ' ') || '├─ ' || nombre
    END AS nombre_jerarquico,
    
    -- Versión con HTML para mejor visualización
    CASE 
        WHEN CONNECT_BY_ISLEAF = 1 THEN 
            '<div class="hierarchy-item level-' || LEVEL || ' leaf-node">' ||
            '<span class="fa fa-file-o" style="margin-right:5px;"></span>' || nombre || '</div>'
        ELSE 
            '<div class="hierarchy-item level-' || LEVEL || ' parent-node">' ||
            '<span class="fa fa-folder-o" style="margin-right:5px;"></span>' || nombre || '</div>'
    END AS nombre_html,
    
    -- Ruta completa
    SYS_CONNECT_BY_PATH(nombre, ' > ') AS path_completo,
    
    tipo,
    descripcion,
    fecha_creacion,
    estado,
    orden,
    creado_por,
    LEVEL AS nivel_jerarquia,
    CONNECT_BY_ISLEAF AS es_hoja,
    CONNECT_BY_ROOT id AS id_raiz,
    CONNECT_BY_ROOT nombre AS nombre_raiz
FROM 
    demo_hierarchical_data
START WITH 
    parent_id IS NULL
CONNECT BY PRIOR 
    id = parent_id
ORDER SIBLINGS BY 
    orden, nombre;