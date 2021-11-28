---
title: Foundation
---
# Foundation Extra

This extra adds nav helper and templates for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html).

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/foundation'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_foundation_nav(@pagy, ...) %>
<%== pagy_foundation_nav_js(@pagy, ...) %>
<%== pagy_foundation_combo_nav_js(@pagy, ...) %>
```

or with a template:

```erb
<%== render partial: 'pagy/foundation_nav', locals: {pagy: @pagy} %>
```

See [Javascript](../api/javascript.md) if you use `pagy_foundation_nav_js` or `pagy_foundation_combo_nav_js`.

## Files

- [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb)
- [foundation_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.erb) (optional template)
- [foundation_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.haml) (optional template)
- [foundation_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.slim)  (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by direct overriding in your own view helper.

### pagy_foundation_nav(pagy)

This method is the same as the `pagy_nav`, but customized for Foundation.

See the [pagy_nav(pagy, ...)](../api/frontend.md#pagy_navpagy-) documentation.

The `foundation_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it. See [How to use templates](../how-to.md#use-templates).

### pagy_foundation_nav_js(pagy, ...)

See the [Javascript Navs](../api/javascript.md#javascript-navs) documentation.

### pagy_foundation_combo_nav_js(pagy, ...)

See the [Javascript Combo Navs](../api/javascript.md#javascript-combo-navs) documentation.
