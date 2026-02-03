# Visualizing Color Data in Oracle APEX: A Pure CSS Approach

Have you ever built an Oracle APEX report containing hex color codes (e.g., `#FF5733`) and wished you could display them as actual visual elements instead of just plain text? While raw hex strings are functional, they aren't the most user-friendly way to present color data.

In this post, I'll share a generic column template for Oracle APEX that transforms these raw hex strings into beautiful UI components.

## Key Features

1.  **Visual Variety**: The template includes 5 built-in styles: **Radio**, **Pill**, **Square**, **Badge**, and **Dot**. This variety covers most use cases, from status indicators to product color selection.
2.  **Zero Dependencies**: The entire solution runs on pure CSS. No JavaScript libraries or heavy frameworks are required, keeping your app fast and lightweight.

## How It Works

This solution works as an **APEX Template Component** (or a generic Column Template). It essentially accepts a hex string and a few configuration parameters, then renders the appropriate HTML structure.

### Parameters

The component accepts the following parameters:

- **STYLE**: The visual style (`RADIO`, `PILL`, `SQUARE`, `BADGE`, `DOT`).
- **SIZE**: Hability to change the size.
- **SHOW_TEXT**: Toggle (`Y`/`N`) to show or hide the hex code text.
- **SHADOW**: Toggle (`Y`/`N`) for shadow effects.
- **BORDER**: Toggle (`Y`/`N`/`thin`/`thick`) for borders (applies to Radio, Square, Badge).
- **POSITION**: Position of the text relative to the indicator (`left`, `right`, `top`, `bottom`).
- **HEX_COLOR**: The actual data column containing the hex string (e.g., `#FF5733`).

## The Visual Styles

Here is a breakdown of the CSS that powers these components. You can include this in your page's "Inline CSS" or your application's global CSS file.

```css
/* Base size classes */
.color-size-xs {
  font-size: 10px;
}
.color-size-s {
  font-size: 11px;
}
.color-size-m {
  font-size: 12px;
}
.color-size-l {
  font-size: 14px;
}
.color-size-xl {
  font-size: 16px;
}

/* Radio button appearance */
.color-radio {
  display: inline-block;
  border-radius: 50%;
  border-style: solid;
  border-color: #fff;
  vertical-align: middle;
  box-shadow:
    0 0 0 2px #ddd,
    inset 0 0 0 1px rgba(0, 0, 0, 0.1);
}

/* Pill appearance */
.color-pill {
  display: inline-block;
  color: #fff;
  font-weight: 500;
  vertical-align: middle;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
  text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
}

/* ... (See full CSS in source) */
```

## The Template Logic

The logic inside the plugin handles the rendering. Here is a snippet showing how we handle the "Radio" and "Pill" styles using APEX template directives:

```html
{if APEX$IS_LAZY_LOADING/}
<div>#HEX_COLOR#</div>
{else/} {if ?HEX_COLOR/} {case STYLE/} {when RADIO/}
<!-- Radio button style: Large circular with white border and shadow ring -->
<span class="color-container color-position-#POSITION#">
  <span
    class="color-radio color-radio-#SIZE#"
    style="background-color:#HEX_COLOR#;"
    title="#HEX_COLOR#"
  >
  </span>
  {if ?SHOW_TEXT/}
  <!-- Text Logic Here -->
  {endif/}
</span>

{when PILL/}
<!-- Pill style: Rounded badge with color background -->
<span
  class="color-pill color-pill-#SIZE# color-size-#SIZE#"
  style="background-color:#HEX_COLOR#;"
  title="#HEX_COLOR#"
>
  #HEX_COLOR#
</span>

<!-- Other styles (SQUARE, BADGE, DOT) follow similar patterns... -->

{endcase/} {endif/} {endif/}
```

By leveraging `APEX$IS_LAZY_LOADING`, we ensure that if the user scrolls quickly through a massive grid, the browser isn't bogged down trying to render complex styles for rows that aren't even visible yet.

## Installation Steps

1.  **Create Custom Component**: In your APEX application, go to **Shared Components** > **Plug-ins** (or **Templates**) and create a new **Template Component**.
2.  **Define Attributes**: add the custom attributes listed above (Style, Size, etc.) and define their List of Values.
3.  **Add Code**: Paste the CSS and Template HTML into the respective fields.
4.  **Use in Report**: Open your Interactive Grid or Classic Report, select the column containing your hex color, and change the type to use your new plugin. Map the `HEX_COLOR` attribute to your database column.

## Conclusion

Visualizing data is a powerful way to enhance user experience. With this simple, pure-CSS template, you can transform technical color codes into vibrant, intuitive interface elements that make your Oracle APEX applications feel more premium and professional.

---

_Check out the full source code for all styles and options in the `apex_color_styles_template.sql` file._
