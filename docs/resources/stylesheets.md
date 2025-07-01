---
label: Stylesheets
icon: file
order: 90
image: ""
---

# 

## Pagy Stylesheet

---
Pagy includes a couple of CSS files that you can download, link, or copy, and integrate with your app.

!!!warning

You don't need any stylesheets if you use the pagy `:bootstrap` or `:bulma` helpers and styles.
!!!

### Pagy Wand

The [Pagy Wand](../sandbox/dev_tools/#pagy-wand) integrates pagy with your app's themes interactively. 

:::raised
![PagyWand](../assets/images/dev-tools.png){width=606}
:::

<br>

Should you need finer control, the `pagy.css` and `pagy-tailwind.css` calculate more specific variables, that you can manually override.

==- CSS Files

!!!success

Color variables are calculated automatically, however you can customize any color by just overriding its variable.

Use the [Pagy Wand](#pagy-wand) right in your app or in the [Demo app](../sandbox/playground#demo-app).
!!!

+++ pagy.css

[!file](../gem/stylesheets/pagy.css)

```ruby 
stylesheet_path = Pagy::ROOT.join('stylesheets/pagy.css')
```

:::code source="/gem/stylesheets/pagy.css" title="pagy.css":::

+++ pagy-tailwind.css

[!file](../gem/stylesheets/pagy-tailwind.css)

```ruby 
stylesheet_path = Pagy::ROOT.join('stylesheets/pagy-tailwind.css')
```

:::code source="/gem/stylesheets/pagy-tailwind.css" title="pagy-tailwind.css":::

+++

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

===
