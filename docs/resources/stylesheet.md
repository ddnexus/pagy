---
label: Stylesheet
icon: file
order: 90
image: ""
---

# 

## Pagy Stylesheet

---
Pagy includes a couple of CSS files that you can download, link, or copy, and integrate with your app.

!!!warning

You don't need any stylesheets if you use nav tag with `:bootstrap` or `:bulma` styles.
!!!

### Pagy Wand

The best way to integrate the pagy style with your app is adding the `PagyWand` to the head of your pages _(while you customize it in place):_

```erb
<%== Pagy.wand_tags %>
```

:::raised
![PagyWnd](../assets/images/pagy-wand.png){width=607}
:::
<br>

You can control most of the visual aspects of pagy with a few presets and sliders. Then copy/paste the generated "CSS Override" block in your stylesheet to persist it in your app.

Should you need finer control, the `pagy.css` and `pagy-tailwind.css` calculate more specific variables, that you can manually override.

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../sandbox/playground#3-demo-app)

==-  HTML Structure of Nav Bars

To ensure a minimalistic valid output, complete with all the ARIA attributes, pagy outputs a single line with the minimum number of tags
and attributes required to identify all the parts of the nav bars:

- The output of `series_nav` and `series_nav_js` helpers, is a series of `a` tags inside a `nav` tag wrapper.
- The disabled links are so because they are missing the `href` attributes.
- The `pagy nav` and `pagy nav-js` classes are assigned to the `nav` tag.

!!! Tips

- You can target the `gap` with `.pagy a:[role="separator"]`
- You can target the previous and next links by using `.pagy a:first-child` and `.pagy a:last-child` pseudo classes
- Check the stylesheet comment to target other specific elements.

!!!

==- CSS Files

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

===
