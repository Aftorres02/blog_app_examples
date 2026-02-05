# APEX HEX Color Visualizer - Oracle APEX Plugin

Una de las características más potentes y a menudo subutilizadas de Oracle APEX son los **Template Components**. Estos nos permiten encapsular lógica de UI compleja en componentes reutilizables y fáciles de configurar.

En este post, veremos cómo "mostrar colores", usando un plugin. El objetivo es pasar de mostrar un simple código hexadecimal (ej. `#FF4436`) a un componente visual rico con múltiples opciones de personalización, dot, radio, square, badge, pill, etc., utilizable en Reportes Interactivos.

![APEX Color Visualizer Preview](https://github.com/Aftorres02/blog_app_examples/raw/master/post_2026/2_apex_color_visualizer/basic_hex_example.png)
_(Así se ve el resultado final: un solo plugin, múltiples representaciones visuales)_

## Anatomía de Nuestro Plugin "APEX Color Visualizer"

Para este ejemplo, hemos diseñado un plugin que soporta gran cantidad de variaciones visuales controladas por atributos personalizados.

### 1. Múltiples Estilos de Visualización

El núcleo del plugin permite elegir cómo renderizar el dato mediante el atributo `STYLE`:

- **Pill (Pastilla)**: Ideal para estados prominentes.
- **Badge (Insignia)**: Sutil, fondo claro con borde de color.
- **Radio / Dot**: Indicadores minimalistas junto al texto.
- **Square**: Muestras de color tipo paleta.

### 2. Atributos de Personalización (Custom Attributes)

Lo que hace que este plugin sea realmente útil es su flexibilidad. Hemos definido atributos que se pueden configurar directamente desde el Page Designer:

- **Size**: Control total del tamaño (Extra Small, Small, Medium, Large, Extra Large).
- **Show Text**: Opción para ocultar el código Hex y dejar solo el indicador visual.
- **Shadow & Border**: Atributos booleanos para agregar profundidad o bordes definidos.
- **Position**: Alineación flexible del indicador respecto al texto (izquierda, derecha, arriba, abajo).

![Opciones del Plugin](https://github.com/Aftorres02/blog_app_examples/raw/master/post_2026/2_apex_color_visualizer/hex_plugin%20options.png)

Puede ver los estilos completos aquí: [apex_color_visualizer.css](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/2_apex_color_visualizer/apex_color_visualizer.css)

## Cómo Usar

Implementarlo en tus aplicaciones es sencillo, sigue estos pasos:

1.  **Crea tu Reporte**: Crea un Interactive Report que contenga una columna con códigos de color hexadecimales.
2.  **Selecciona la Columna**: En el Page Designer, selecciona la columna de color.
3.  **Cambia el Tipo**: Cambia el tipo de la columna a **APEX Color Visualizer**.
4.  **Configura**: Ajusta los atributos (Style, Size, Shadow, etc.) según tus necesidades.

![Configuración del Plugin](https://github.com/Aftorres02/blog_app_examples/raw/master/post_2026/2_apex_color_visualizer/hex%20color%20plugin.png)
_(Panel de configuración del plugin en el Page Designer)_

## Recursos

- **Repositorio Completo**: [Accede al código fuente aquí](https://github.com/Aftorres02/blog_app_examples/tree/master/post_2026/2_apex_color_visualizer)
- **Plugin de Instalación**: [template_component_plugin_apex_color_visualizer.sql](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/2_apex_color_visualizer/template_component_plugin_apex_color_visualizer.sql)
- **Estilos CSS**: [apex_color_visualizer.css](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/2_apex_color_visualizer/apex_color_visualizer.css)
