# Oracle APEX Hierarchy Visualizer - Template Component - Plugin

Hierarchical data is everywhere in enterprise applications—organization charts, file systems, category trees. While **Oracle APEX** provides native components like the Tree Region, sometimes we need more control over the look and feel within reports or custom layouts.

In this post, we'll explore the **APEX Hierarchy Visualizer**, a Template Component plugin designed to render nested data with elegant indentation and multiple visual styles.

![APEX Hierarchy Visualizer Preview](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/images/plugin_hierarchy.png?raw=true)
_(Transforming raw CONNECT BY data into a clean, visual hierarchy)_

## Anatomy of the "APEX Hierarchy Visualizer" Plugin

The power of this plugin lies in its ability to automatically handle indentation and node types (parent vs. leaf) based on standard SQL hierarchical queries.

### 1. Dynamic Indentation Styles

The plugin isn't limited to just adding spaces. You can choose from several `Indent Style` options to match your UI requirements:

![Plugin Configuration Styles](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/images/p_h_config_styles.png?raw=true)

- **Folder/File Icons**: The classic view using Font Awesome icons (orange folders for parents, gray files for leaves).
- **Chevrons**: A modern, minimalist look with directional arrows indicating depth.
- **Solid & Dotted Lines**: Provides a "stretched" visual connector from the start of the row to the label.
- **L-Steps (└─)**: A clean ASCII-style branching visualization.
- **Spaces Only**: For when you just need the structural alignment without icons.

### 2. Custom Attributes for Full Control

Configurable directly in the Page Designer, these attributes allow you to tailor the visualization:

- **Hierarchy Level Column**: Maps to the `LEVEL` pseudo-column from your query.
- **Is Leaf Column**: Maps to `CONNECT_BY_ISLEAF` to distinguish between folders and items.
- **Indentation (px)**: Precisely control how many pixels each level should shift (default is 20px).
- **Node Colors**: Override default colors for Parent and Leaf nodes using the integrated Color Picker.

![SQL](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/images/plugin_hierarchy_sql.png?raw=true)

## How to Use

Setting up the hierarchy visualizer in your application is a straightforward process:

1.  **Prepare Your Data**: Use a `CONNECT BY` or `Recursive CTE` query to generate the hierarchy, ensuring you include `LEVEL` and `CONNECT_BY_ISLEAF`.
    _Ref: [demo_hierarchical_data_table.sql](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/demo_hierarchical_data_table.sql)_

2.  **Add the Plugin**: Import the plugin SQL file and the corresponding CSS style.
    - [Download CSS](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/plugin/hierarchy_template_component.css)
    - [Download Plugin SQL](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/plugin/template_component_plugin_hierarchy_visualizer.sql)

3.  **Assign the Type**: Change your report column type to **APEX Hierarchy Visualizer**.

4.  **Map Attributes**: In the column attributes, select the corresponding source columns for Level, Is Leaf, and the Label you want to display.

5.  **Fine-tune**: Choose your preferred Indent Style and adjust the Indent Step to fit your design.

![Plugin Configuration Options](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/images/config_plugin_hierarchy.png?raw=true)
_(Example of plugin configuration in Page Designer)_

## Resources

- **Full Repository**: [Access the source code here](https://github.com/Aftorres02/blog_app_examples/tree/master/post_2026/4_plugin_hierarchy)
- **Plugin Source**: [Plugin Folder](https://github.com/Aftorres02/blog_app_examples/tree/master/post_2026/4_plugin_hierarchy/plugin)
- **Manual Config Guide**: [Read the implementation details](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/plugin_manual_config.md)
- **SQL Example**: [Sample hierarchical query](https://github.com/Aftorres02/blog_app_examples/blob/master/post_2026/4_plugin_hierarchy/sql.sql)
