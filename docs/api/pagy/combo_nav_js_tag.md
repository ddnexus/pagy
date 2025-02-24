---
title: combo_nav_js_tag
icon: code
order: 150
categories:
  - Instance Methods
  - Navs
  - Tags
---

The `combo_nav_js_tag` offers a tag that combines navigation and pagination info in a single compact element.

It is the fastest and lightest navigator, recommended when you care about efficiency and server load (
see [Maximizing Performance](../../guides/how-to.md#maximize-performance)) still needing UI.

![combo_nav_js (:bootstrap style)](/assets/images/bootstrap_combo_nav_js.png)

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/docs/Practical%20Guide/playground.md#3-demo-app)


```erb Any View
<!-- Use just one: -->
<%== @pagy.combo_nav_js(**options) %>
<%== @pagy.combo_nav_js(:bootstrap, **options) %>
<%== @pagy.combo_nav_js(:bulma, **options) %>
```
