---
label: Stylesheets
icon: file
order: 90
image: ""

---

#

## :icon-file:&nbsp;&nbsp;Stylesheets

---

Pagy includes a couple of CSS files and the tools to integrate with your app's themes _interactively_.

!!!warning
You don't need any stylesheets if you use the pagy `:bootstrap` or `:bulma` helpers and styles.
!!!

### Setup

>>> Pick a file...

+++ pagy.css

!!!success Good for any app
!!!

==- CSS Source

:::code source="/gem/stylesheets/pagy.css" title="pagy.css":::

===

+++ pagy-tailwind.css

!!!warning Works only with apps using tailwind
!!!

==- CSS Source

:::code source="/gem/stylesheets/pagy-tailwind.css" title="pagy-tailwind.css":::

===

+++

{{ include "snippets/pick-a-conf" resource: ":stylesheet" resource_dir: "stylesheets" remote_dir: "app/stylesheets" }}

>>> Customize the style...

Add this line to any template/layout `<head>` while developing:

```erb
<%== Pagy.dev_tools %>
```

and adjust a few sliders to see the change in real time, right in your app, with the [Pagy Wand](/sandbox/dev_tools). Then copy the `CSS Override` field and paste it in your own CSS.

:::raised
![PagyWand](/assets/images/dev-tools.png){width=300}
:::

>>>

==- :icon-key-asterisk:&nbsp; Selectors

To ensure a minimalistic valid output, complete with all the [ARIA attributes](ARIA), pagy outputs a single line with the minimum number of tags and attributes required to identify all the parts of the nav bars:

- The output of `series_nav` and `series_nav_js` helpers, is a series of `a` tags inside a `nav` tag wrapper.
- The disabled links are so because they are missing the `href` attributes.
- The `pagy nav` and `pagy nav-js` classes are assigned to the `nav` tag.

{{ include "snippets/run-app" app: "demo" }}

<br/>

!!!tip
- You can target the `gap` with `.pagy a:[role="separator"]`
- You can target the previous and next links by using `.pagy a:first-child` and `.pagy a:last-child` pseudo classes
- Check the stylesheet comments to target other specific elements.
!!!

==- :icon-arrow-left:&nbsp; RTL

The pagy stylesheets automatically support Right-To-Left (RTL) languages. It respects the standard `dir="rtl"` attribute of the `html` tag or any parent element of the pagination.

===
