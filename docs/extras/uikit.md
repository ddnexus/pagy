---
title: UIkit
image: none
category: Frontend
---

# UIkit Extra

Add nav helpers and templates for the UIkit [pagination component](https://getuikit.com/docs/pagination).

## Synopsis


||| pagy.rb (initializer)
```ruby
require 'pagy/extras/uikit'
```
|||

||| View
```erb
<-- Nav Helpers: -->
<%== pagy_uikit_nav(@pagy, ...) %>
<%== pagy_uikit_nav_js(@pagy, ...) %>
<%== pagy_uikit_combo_nav_js(@pagy, ...) %>
```
|||

||| Template

```rb
# or you can render with a template
<%== render partial: 'pagy/uikit_nav', locals: {pagy: @pagy} %>
```
|||

## Files

- [uikit.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/uikit.rb)
- [uikit_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit.html.erb) (optional template)
- [uikit_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit_nav.html.haml) (optional template)
- [uikit_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit_nav.html.slim) (optional template)

## Methods

This extra adds the above nav helpers to the `Pagy::Frontend` module. You can customize it by direct overriding in your own view helper.

=== `pagy_uikit_nav(pagy)`

![uikit_nav](/docs/assets/images/uikit_nav.png)

This method is the same as the `pagy_nav`, but customized for UIkit.

See the [pagy_nav(pagy, ...)](/docs/api/frontend.md#pagy-nav-pagy) documentation.

The `uikit_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it. See [How to use templates](/docs/how-to.md#use-templates).

=== `pagy_uikit_nav_js(pagy, ...)`

![Warning: Bootstrap style shown above as a representative example - the responsive `pagy_uikit_nav_js` looks like the `pagy_uikit_nav` helper.](/docs/assets/images/bootstrap_nav_js.png)

It's rendered on the client, with optional responsiveness. See the [Javascript Navs](/docs/api/javascript/navs.md) documentation for more information.

=== `pagy_uikit_combo_nav_js(pagy, ...)`

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.

Here is an example:

![uikit_combo_nav_js](/docs/assets/images/uikit_combo_nav_js.png)

===
