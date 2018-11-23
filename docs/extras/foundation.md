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
<%== pagy_foundation_nav(@pagy) %>
```

or with a template:

```erb
<%== render 'pagy/foundation_nav', locals: {pagy: @pagy} %>
```

Configure [javascript](../extras.md#javascript) if you use `pagy_foundation_responsive_nav` or `pagy_foundation_compact_nav`.

## Files

This extra is composed of 4 files:

- [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb)
- [foundation_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.erb) (optional template)
- [foundation_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.haml) (optional template)
- [foundation_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.slim)  (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize it by overriding it directly in your own view helper.

### pagy_foundation_nav(pagy)

This method is the same as the `pagy_nav`, but customized for Foundation.

The `foundation_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

### pagy_foundation_compact_nav(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for the Foundation framework.

See more details in the [compact navs](navs.md#compact-navs) documentation.

### pagy_foundation_responsive_nav(pagy, ...)

This method is the same as the `pagy_nav_responsive`, but customized for the Foundation framework.

See more details in the [responsive navs](navs.md#responsive-navs) documentation.

### Optional Template Files

See [Using Templates](../how-to.md#using-templates).
