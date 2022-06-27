---
title: UIkit
category: Frontend Extras
image: null
---
# UIkit Extra

This extra adds nav helpers and templates for the UIkit [pagination component](https://getuikit.com/docs/pagination).

## Synopsis

See [extras](/docs/extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/uikit'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_uikit_nav(@pagy, ...) %>
<%== pagy_uikit_nav_js(@pagy, ...) %>
<%== pagy_uikit_combo_nav_js(@pagy, ...) %>
```

or with a template:

```erb
<%== render partial: 'pagy/uikit_nav', locals: {pagy: @pagy} %>
```

## Files

- [uikit.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/uikit.rb)
- [uikit_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit.html.erb) (optional template)
- [uikit_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit_nav.html.haml) (optional template)
- [uikit_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit_nav.html.slim) (optional template)

## Methods

This extra adds nav helper to the `Pagy::Frontend` module. You can customize it by direct overriding in your own view helper.

### pagy_uikit_nav(pagy)

This method is the same as the `pagy_nav`, but customized for UIkit.

See the [pagy_nav(pagy, ...)](/docs/api/frontend.md#pagy_navpagy-) documentation.

The `uikit_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it. See [How to use templates](../how-to.md#use-templates).

### pagy_uikit_nav_js(pagy, ...)

See the [Javascript Navs](/docs/api/javascript/navs.md) documentation

### pagy_uikit_combo_nav_js(pagy, ...)

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.

Here is an example:

![uikit_combo_nav_js](/docs/assets/images/uikit_combo_nav_js-g.png)
