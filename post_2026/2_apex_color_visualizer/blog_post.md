# APEX HEX Color Visualizer - Oracle APEX Plugin

One of the most powerful and often underutilized features of Oracle APEX is **Template Components**. These allow us to encapsulate complex UI logic into reusable and easy-to-configure components.

In this post, we'll see how to "display colors" using a plugin. The goal is to go from showing a simple hex code (e.g., `#FF4436`) to a rich visual component with multiple customization options—dot, radio, square, badge, pill, etc.—usable in Interactive Reports.

![APEX Color Visualizer Preview](https://github.com/Aftorres02/blog_app_examples/raw/master/post_2026/2_apex_color_visualizer/basic_hex_example.png)
_(This is the final result: a single plugin, multiple visual representations)_

## Anatomy of Our "APEX Color Visualizer" Plugin

For this example, we have designed a plugin that supports a large number of visual variations controlled by custom attributes.

### 1. Multiple Display Styles

The core of the plugin allows you to choose how to render the data using the `STYLE` attribute:

- **Pill**: Ideal for prominent statuses.
- **Badge**: Subtle, light background with colored border.
- **Radio / Dot**: Minimalist indicators alongside the text.
- **Square**: Palette-style color swatches.

### 2. Custom Attributes

What makes this plugin truly useful is its flexibility. We have defined attributes that can be configured directly from the Page Designer:

- **Size**: Full size control (Extra Small, Small, Medium, Large, Extra Large).
- **Show Text**: Option to hide the Hex code and leave only the visual indicator.
- **Shadow & Border**: Boolean attributes to add depth or defined borders.
- **Position**: Flexible alignment of the indicator relative to the text (left, right, top, bottom).

![Plugin Options](https://github.com/Aftorres02/blog_app_examples/raw/master/post_2026/2_apex_color_visualizer/hex_plugin%20options.png)

You can view the full styles here: [apex_color_visualizer.css](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/2_apex_color_visualizer/apex_color_visualizer.css)

## How to Use

Implementing it in your applications is simple, follow these steps:

1.  **Create Your Report**: Create an Interactive Report that contains a column with hex color codes.
2.  **Select the Column**: In Page Designer, select the color column.
3.  **Change the Type**: Change the column type to **APEX Color Visualizer**.
4.  **Configure**: Adjust the attributes (Style, Size, Shadow, etc.) according to your needs.

![Plugin Configuration](https://github.com/Aftorres02/blog_app_examples/raw/master/post_2026/2_apex_color_visualizer/hex%20color%20plugin.png)
_(Plugin configuration panel in Page Designer)_

## Resources

- **Full Repository**: [Access the source code here](https://github.com/Aftorres02/blog_app_examples/tree/master/post_2026/2_apex_color_visualizer)
- **Plugin Installation**: [template_component_plugin_apex_color_visualizer.sql](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/2_apex_color_visualizer/template_component_plugin_apex_color_visualizer.sql)
- **CSS Styles**: [apex_color_visualizer.css](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/2_apex_color_visualizer/apex_color_visualizer.css)
