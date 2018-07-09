---
title: Bulma
---
# Bulma Extra

This extra adds nav helper and templates for Bulma CSS framework [pagination component](https://bulma.io/documentation/components/pagination).

## Synopsys

See [extras](../extras.md) for general usage info.

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav_bulma(@pagy) %>
```

or with a template:

```erb
<%== render 'pagy/nav_bulma', locals: {pagy: @pagy} %>
```

## Files

This extra is composed of 4 files:

- [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb)
- [nav_bulma.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/templates/nav_bulma.html.erb) (optional template)
- [nav_bulma.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/templates/nav_bulma.html.haml) (optional template)
- [nav_bulma.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/templates/nav_bulma.html.slim)  (optional template)

## Methods

This extra adds one nav helpers to the `Pagy::Frontend` module. You can customize it by overriding it directly in your own view helper.

### pagy_nav_bulma(pagy)

This method is the same as the `pagy_nav`, but customized for Bulma.

The `nav_bulma.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

### Optional Template Files

See [Using Templates](../how-to.md#using-templates).
