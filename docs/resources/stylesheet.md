---
label: Stylesheet
icon: file
order: 90
image: ""
---

# 

## Pagy Stylesheet

---

![](../assets/images/series_nav.png){width=288}
![](../assets/images/input_nav_js.png){width=204}
![](../assets/images/limit_tag_js.png){width=202}

Pagy includes a few stylesheet files that you can download, link, or copy, and integrate with your app.

!!!warning

You don't need any stylesheets if you use nav tag with `:bootstrap` or `:bulma` styles.
!!!

#### HTML Structure of Nav Bars

To ensure a minimalistic valid output, complete with all the ARIA attributes, pagy outputs a single line with the minimum number of tags
and attributes required to identify all the parts of the nav bars:

- The output of `series_nav` and `series_nav_js` helpers, is a series of `a` tags inside a `nav` tag wrapper.
- The disabled links are so because they are missing the `href` attributes.
- The `pagy nav` and `pagy nav-js` classes are assigned to the `nav` tag.

!!! Tips

- You can target the `gap` with `a:not([role="separator"])`
- You can target the previous and next links by using `pagy a:first-child` and `pagy a:last-child` pseudo classes

!!!

#### Files

!!!success

You can customize all the colors by just overriding the CSS variables.

Use the GUI editor in the [Demo app](../sandbox/playground#3-demo-app).
!!!

+++ pagy.css

[!file](../gem/stylesheet/pagy.css)

```ruby 
stylesheet_path = Pagy::ROOT.join('stylesheet/pagy.css')
```

:::code source="/gem/stylesheet/pagy.css" title="pagy.css":::

+++ pagy-tailwind.css

[!file](../gem/stylesheet/pagy-tailwind.css)

```ruby 
stylesheet_path = Pagy::ROOT.join('stylesheet/pagy-tailwind.css')
```

:::code source="/gem/stylesheet/pagy-tailwind.css" title="pagy-tailwind.css":::

+++

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../sandbox/playground#3-demo-app)
