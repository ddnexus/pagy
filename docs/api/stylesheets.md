---
title: Stylesheets
image: none
---

# Stylesheets

<img src="/pagy/docs/assets/images/pagy-style.png" width="300" title="Pagy Style">

## Overview

For all its own interactive helpers shown above, the pagy gem includes a few stylesheets files that you can download, link or
copy.

!!!warning
You don't need any stylesheet if you use a frontend extra like: 
[bootstrap](/docs/extras/bootstrap), [bulma](/docs/extras/bulma), [foundation](/docs/extras/foundation), 
[materialize](/docs/extras/materialize), [semantic](/docs/extras/semantic), [uikit](/docs/extras/uikit)
!!!

### HTML Structure

In order to ensure a minimalistic valid output, still complete with all the ARIA attributes, we use a single line with the minimum
number of tags and class attributes that can identify all the parts of the nav bars:

- The output of `pagy_nav` and `pagy_nav_js` are a series of `a` tags inside a wrapper `nav` tag
- The disabled links are so because they are missing the `href` attributes
- The `pagy nav` and `pagy nav-js` classes are assigned to the `nav` tag
- The `current`, `gap` classes are assigned to the specific `a` tags

!!! Notice

- The stylesheets target the disabled `a` tags by using the `pagy a:not([href])` selector
- You can make the `gap` look like the other pages by removing the `:not(.gap)`
- You can target the previous and next links by using `pagy a:first-child` and `pagy a:last-child` pseudo classes

!!!

!!!success 
You can totally transform the stylesheets below by just editing the content inside the curly brackets, usually leaving
the rest untouched.

!!!warning The order of the selectors is important!
!!!

+++ pagy.scss

[!file](/lib/stylesheets/pagy.scss)

```ruby 
stylesheet_path = Pagy.root.join('stylesheets', 'pagy.scss')
```

:::code source="/lib/stylesheets/pagy.scss" :::

+++ pagy.css

[!file](/lib/stylesheets/pagy.css)

```ruby 
stylesheet_path = Pagy.root.join('stylesheets', 'pagy.css')
```

:::code source="/lib/stylesheets/pagy.css" :::

+++ pagy.tailwind.scss

[!file](/lib/stylesheets/pagy.tailwind.scss)

```ruby 
stylesheet_path = Pagy.root.join('stylesheets', 'pagy.tailwind.scss')
```

:::code source="/lib/stylesheets/pagy.tailwind.scss" :::

+++

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/try-it.md)
