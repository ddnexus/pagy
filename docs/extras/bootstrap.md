---
title: Bootstrap
categories:
- Frontend
- Extra
image: none
---

# Bootstrap Extra

Add nav helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination).

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
pagy run demo
# or: bundle exec pagy run demo
```
...and point your browser at http://0.0.0.0:8000
!!!

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/bootstrap'
```

```erb View (helper)
<%== pagy_bootstrap_nav(@pagy, **vars) %>
<%== pagy_bootstrap_nav_js(@pagy, **vars) %>
<%== pagy_bootstrap_combo_nav_js(@pagy, **vars) %>
```

See: [Javascript](/docs/api/javascript.md) if you use `pagy_bootstrap_nav_js` or `pagy_bootstrap_combo_nav_js`.

## Files

- [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module.

!!!info Overriding Helpers
You can customize them by overriding in your own view helper(s).
!!!

=== `pagy_bootstrap_nav(pagy, **vars)`

![pagy_bootstrap_nav](/docs/assets/images/bootstrap_nav.png)

This method is the same as the `pagy_nav`, but customized for Bootstrap.

See: [pagy_nav(pagy, **vars)](/docs/api/frontend.md#pagy-nav-pagy-vars).

=== `pagy_bootstrap_nav_js(pagy, **vars)`

![bootstrap_nav_js: Responsive nav.](/docs/assets/images/bootstrap_nav_js.png)

See: [Javascript Navs](/docs/api/javascript/navs.md).

=== `pagy_bootstrap_combo_nav_js(pagy, **vars)`

![bootstrap_combo_nav_js](/docs/assets/images/bootstrap_combo_nav_js.png)

See: [Javascript Combo Navs](/docs/api/javascript/combo-navs.md).

===
