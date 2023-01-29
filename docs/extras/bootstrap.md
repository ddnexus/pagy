---
title: Bootstrap
categories:
- Frontend
- Extra
image: none
---

# Bootstrap Extra

Add nav helpers and templates for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination).

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/bootstrap'
```
|||

||| View (helper)
```erb
<%== pagy_bootstrap_nav(@pagy, ...) %>
<%== pagy_bootstrap_nav_js(@pagy, ...) %>
<%== pagy_bootstrap_combo_nav_js(@pagy, ...) %>
```
|||

||| View (template)
```erb
<%== render partial: 'pagy/bootstrap_nav', locals: {pagy: @pagy} %>
```
|||

See: [Javascript](/docs/api/javascript.md) if you use `pagy_bootstrap_nav_js` or `pagy_bootstrap_combo_nav_js`.

## Files

- [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb)
- [bootstrap_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.erb) (optional template)
- [bootstrap_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.haml) (optional template)
- [bootstrap_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.slim) (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. 

!!!info Overriding Helpers
You can customize them by overriding in your own view helper(s).
!!!

==- `pagy_bootstrap_nav(pagy, ...)`

![pagy_bootstrap_nav](/docs/assets/images/bootstrap_nav.png)

This method is the same as the `pagy_nav`, but customized for Bootstrap.

See: [pagy_nav(pagy, ...)](/docs/api/frontend.md#pagy-nav-pagy).

The `bootstrap_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it. See [How to use templates](/docs/how-to.md#use-templates).

=== `pagy_bootstrap_nav_js(pagy, ...)`

![bootstrap_nav_js: It is responsive.](/docs/assets/images/bootstrap_nav_js-g.png)

See: [Javascript Navs](/docs/api/javascript/navs.md).

=== `pagy_bootstrap_combo_nav_js(pagy, ...)`

![bootstrap_combo_nav_js](/docs/assets/images/bootstrap_combo_nav_js.png)

See: [Javascript Combo Navs](/docs/api/javascript/combo-navs.md).

===
