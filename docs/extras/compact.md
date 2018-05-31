---
title: Compact
---
# Compact Extra

The `compact` extra adds an alternative pagination UI that joins the pagination feature with the navigation info in one compact element. It is especially useful for small size screens.

Here is an example (bootstrap style):

![pagy-compact](../assets/images/pagy-compact-g.png)

## Synopsys

See [extras](../extras.md) for general usage info.

In an initializer file:

```ruby
# in rails apps: add the assets-path
Rails.application.config.assets.paths << Pagy.root.join('pagy', 'extras', 'javascripts')
```

In rails: add the javascript file to the application.js

```js
//= require pagy-compact
```

In non-rails apps: ensure the `pagy/extras/javascripts/pagy-compact.js` script gets served with the page

Then use the responsive helper(s) in any view:

```erb
<%== pagy_nav_compact(@pagy) %>
<%== pagy_nav_bootstrap_compact(@pagy) %>
```

## Files

This extra is composed of 2 small files:

- [compact.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagyextras/compact.rb)
- [pagy-compact.js](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/javascripts/pagy-compact.js)

## Methods

This extra adds a couple of nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_nav_compact(pagy, ...)

Renders a compact navigation with a style similar to the `pagy_nav` helper.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id assignation is based on the code line where you use the helper, you should pass an explicit id only if you are going to use more than one `*_responsive` call in the same line for the same page.

### pagy_nav_bootstrap_compact(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for Bootstrap.
