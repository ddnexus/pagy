---
title: Bootstrap
categories:
- Frontend
- Extra
image: none
---

# Bootstrap Extra

Add nav helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination).

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/docs/Practical%20Guide/playground.md#3-demo-app)
## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/bootstrap'
```

```erb View (helper)
<%== pagy_bootstrap_nav(@pagy, **opts) %>
<%== pagy_bootstrap_nav_js(@pagy, **opts) %>
<%== pagy_bootstrap_combo_nav_js(@pagy, **opts) %>
```

See: [Javascript](/docs/resources/javascript.md) if you use `pagy_bootstrap_nav_js` or `pagy_bootstrap_combo_nav_js`.

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module.

!!!info Overriding Helpers
You can customize them by overriding in your own view helper(s).
!!!

=== `pagy_bootstrap_nav(pagy, **opts)`

![pagy_bootstrap_nav](/docs/assets/images/bootstrap_nav.png)

This method is the same as the `pagy_nav`, but customized for Bootstrap.

See: [pagy_nav(pagy, **opts)](/docs/api/frontend.md#pagy-nav-pagy-opts).

=== `pagy_bootstrap_nav_js(pagy, **opts)`

![bootstrap_nav_js: Responsive nav.](/docs/assets/images/bootstrap_nav_js.png)

See: [Javascript Navs](/docs/resources/javascript/navs.md).

=== `pagy_bootstrap_combo_nav_js(pagy, **opts)`

![bootstrap_combo_nav_js](/docs/assets/images/bootstrap_combo_nav_js.png)

See: [Javascript Combo Navs](/docs/resources/javascript/combo-navs.md).

===
