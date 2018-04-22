---
title: Bootstrap
---

# Bootstrap

This extra adds a nav helper compatible with the Bootstrap pagination.

## Synopsys

Render the navigation links in some view...
with a fast helper:
```erb
<%== pagy_nav_bootstrap(@pagy) %>
```
or with a template:
```erb
<%== render 'pagy/nav_bootstrap', locals: {pagy: @pagy} %>
```

## Files

This extra is composed of 4 files:

- [bootstrap.rb](https://github.com/ddnexus/pagy-extras/blob/master/lib/pagy-extras/bootstrap.rb)
- [nav_bootstrap.html.erb](https://github.com/ddnexus/pagy-extras/blob/master/lib/templates/nav_bootstrap.html.erb)
- [nav_bootstrap.html.haml](https://github.com/ddnexus/pagy-extras/blob/master/lib/templates/nav_bootstrap.html.haml)
- [nav_bootstrap.html.slim](https://github.com/ddnexus/pagy-extras/blob/master/lib/templates/nav_bootstrap.html.slim)


## Methods

This extra adds one nav helpers to the `Pagy::Frontend` module. You can customize it by overriding it directly in your own view helper.

### pagy_nav_bootstrap(pagy)

This method is the same as the `pagy_nav`, but customized for Bootstrap.

The `nav_bootstrap.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

See also [Using Templates](../how-to.md#using-templates).
