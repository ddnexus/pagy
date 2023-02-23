---
title: Foundation
categories:
- Frontend
- Extra
---

# Foundation Extra

Add nav helpers and templates for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html).

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/foundation'
```
|||

||| View (helper)
```erb
<%== pagy_foundation_nav(@pagy, ...) %>
<%== pagy_foundation_nav_js(@pagy, ...) %>
<%== pagy_foundation_combo_nav_js(@pagy, ...) %>
```
|||

||| View (template)
```erb
<%== render partial: 'pagy/foundation_nav', locals: {pagy: @pagy} %>
```
|||

See [Javascript](/docs/api/javascript.md) if you use `pagy_foundation_nav_js` or `pagy_foundation_combo_nav_js`.

## Files

- [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb)
- [foundation_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.erb) (optional template)
- [foundation_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.haml) (optional template)
- [foundation_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.slim)  (optional template)

## Methods

=== `pagy_foundation_nav(pagy)`

![Foundation Nav](/docs/assets/images/foundation_nav.png)

This method is the same as the `pagy_nav`, but customized for Foundation.

See the [pagy_nav(pagy, ...)](/docs/api/frontend.md#pagy-nav-pagy) documentation.

The `foundation_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it. See [How to use templates](/docs/how-to.md#use-templates).

=== `pagy_foundation_nav_js(pagy, ...)`

![Warning: Bootstrap style shown above as a representative example - the responsive `pagy_foundation_nav_js` looks like the `pagy_foundation_nav` helper.](/docs/assets/images/bootstrap_nav_js.png)

It's rendered on the client, with optional responsiveness. See the [Javascript Navs](/docs/api/javascript/navs.md) documentation for more information.

=== `pagy_foundation_combo_nav_js(pagy, ...)`

![Foundation Combo Nav JS](/docs/assets/images/foundation_combo_nav_js.png)

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.

===
