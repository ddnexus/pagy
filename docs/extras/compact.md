---
title: Compact
---
# Compact Extra

The `compact` extra adds an alternative pagination UI that combines the pagination feature with the navigation info in a single compact element.

It is especially useful for small size screens, but it is used also with wide layouts since it is __even faster__ than the classic nav of links, because it needs to render just a minimal HTML string.

Here is an example (bootstrap style):

![pagy-compact](../assets/images/pagy-compact-g.png)

## Synopsys

See [extras](../extras.md) for general usage info.

Configure [javascript](../extras.md#javascript)

Then use the responsive helper(s) in any view:

```erb
<%== pagy_nav_compact(@pagy) %>
<%== pagy_nav_compact_bootstrap(@pagy) %>
<%== pagy_nav_compact_bulma(@pagy) %>
```

## Files

This extra is composed of the [compact.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/compact.rb)  and uses the [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/javascripts/pagy.js) file.

## Methods

This extra adds a couple of nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_nav_compact(pagy, ...)

Renders a compact navigation with a style similar to the `pagy_nav` helper.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id assignation is based on the code line where you use the helper, you should pass an explicit id only if you are going to use more than one `pagy_nav_compact` or `pagy_nav_compact_bootstrap` call in the same line for the same page.

### pagy_nav_compact_bootstrap(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for Bootstrap.

### pagy_nav_compact_bulma(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for Bulma CSS framework.

Generated pagination preview:

![pagy-compact-bulma](../assets/images/pagy-compact-bulma-g.png)
