---
title: Navs
---
# Navs Extra

This extra adds a couple of javascript nav helpers to the `Pagy::Frontend` module: `pagy_combo_nav_js` and `pagy_nav_js`. These are the unstyled versions of the javascript-powered nav helpers.

Other extras (e.g. [bootstrap](bootstrap.md), [bulma](bulma.md), [foundation](foundation.md), [materialize](materialize.md), [semantic](semantic.md)) provide framework-styled versions of the same `nav` helpers, so you may not need this extra if you use one of the above framework-styled extra.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/navs'
```

Configure [javascript](../extras.md#javascript).

## Files

- [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb)

# Javascript Navs

The `pagy*_nav_js` (implemented by this extra or by other frontend extras) looks like a normal `*_nav` but has a a few added features:

1. It is rendered on the client side
2. It offers optional responsiveness
3. It is faster and lighter than a simple `pagy*_nav` helper _(see [Maximizing Performance](../how-to.md#maximizing-performance))_

Here is a screenshot (from the `bootstrap`extra) showing responsiveness at different widths:

![bootstrap_nav_js](../assets/images/bootstrap_nav_js-g.png)

## Synopsis

Use the `pagy*_nav_js` helpers in any view:

```erb
<%== pagy_nav_js(@pagy) %>
```

Other extras provide also the following framework-styled helpers:

```erb
<%== pagy_bootstrap_nav_js(@pagy) %>
<%== pagy_bulma_nav_js(@pagy) %>
<%== pagy_foundation_nav_js(@pagy) %>
<%== pagy_materialize_nav_js(@pagy) %>
<%== pagy_semantic_nav_js(@pagy) %>
```

## Variables

| Variable | Description                                                       | Default |
|:---------|:------------------------------------------------------------------|:--------|
| `:steps` | Hash variable to control multipe pagy `:size` at different widths | `false`   |

### :steps

The `:steps` is an optional non-core variable used by the `pagy*_nav_js` navs. If it's `false`, the `pagy*_nav_js` will behave exactly as a static `pagy*_nav` respecting the single `:size` variable, just faster and lighter. If it's defined as a hash, it allows you to control multiple pagy `:size` at different widths.

You can set the `:steps` as a hash where the keys are integers representing the widths in pixels and the values are the Pagy `:size` variables to be applied for that width.

As usual, depending on the scope of the customization, you can set the variables globally or for a single pagy instance.

For example:

```ruby
# globally
Pagy::VARS[:steps] = { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] }

# or for a single instance
pagy, records = pagy(collection, steps: { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] } )

# or use the :size as any static pagy*_nav
pagy, records = pagy(collection, steps: false )

```

The above statement means that from `0` to `540` pixels width, Pagy will use the `[2,3,3,2]` size, from `540` to `720` it will use the `[3,5,5,3]` size and over `720` it will use the `[5,7,7,5]` size. (Read more about the `:size` variable in the [How to control the page links](../how-to.md#controlling-the-page-links) section).

**IMPORTANT**: You can set any number of steps with any arbitrary width/size. The only requirement is that the `:steps` hash must contain always the `0` width or a `Pagy::VariableError` exception will be raised.

#### Setting the right sizes

Setting the widths and sizes can create a nice transition between widths or some apparently erratic behavior.

Here is what you should consider/ensure:

1. The pagy size changes in discrete `:steps`, defined by the width/size pairs.

2. The automatic transition from one size to another depends on the width available to the pagy nav. That width is the _internal available width_ of its container (excluding eventual horizontal padding).

3. You should ensure that - for each step - each pagy `:size` produces a nav that can be contained in its width.

4. You should ensure that the minimum internal width for the container div be equal (or a bit bigger) to the smaller positive width. (`540` pixels in our previous example).

5. If the container width snaps to specific widths in discrete steps, you should sync the quantity and widths of the pagy `:steps` to the quantity and internal widths for each discrete step of the container.

#### Javascript Caveats

In case of a window resize, the `pagy_*nav_js` elements on the page are re-rendered (when the container width changes), however if the container width changes in any other way that does not involve a window resize, then you should re-render the pagy element explicitly. For example:

```js
document.getElementById('my-pagy-nav-js').render();
```

## Methods

### pagy_nav_js(pagy, ...)

Similar to the `pagy_nav` helper, but faster and rendered on the client side, with added responsiveness.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id generation is based on the code line where you use the helper, you _must_ pass an explicit id if you are going to use more than one `*_js` call in the same line for the same file.

**Notice**: passing an explicit id is also a bit faster than having pagy to generate one.

# Javascript Combo Navs

The `pagy*_combo_nav_js` (implemented by this extra or by other frontend extras) offers an alternative pagination UI that combines navigation and pagination info in a single compact element.

It is the fastest and lighter `nav` on modern environments, recommended when you care about efficiency and server load _(see [Maximizing Performance](../how-to.md#maximizing-performance))_.

Here is a screenshot (from the `bootstrap` extra):

![bootstrap_combo_nav_js](../assets/images/bootstrap_combo_nav_js-g.png)

## Synopsis

Use the `pagy*_combo_nav_js helpers in any view:

```erb
<%== pagy_combo_nav_js(@pagy) %>
```

Other extras provide also the following framework-styled helpers:

```erb
<%== pagy_bootstrap_combo_nav_js(@pagy) %>
<%== pagy_bulma_combo_nav_js(@pagy) %>
<%== pagy_foundation_combo_nav_js(@pagy) %>
<%== pagy_materialize_combo_nav_js(@pagy) %>
<%== pagy_semantic_combo_nav_js(@pagy) %>
```

## Methods

### pagy_combo_nav_js(pagy, ...)

Renders a javascript-powered compact navigation helper.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id generation is based on the code line where you use the helper, you _must_ pass an explicit id if you are going to use more than one `*_js` call in the same line for the same page.

**Notice**: passing an explicit id is also a bit faster than having pagy to generate one.
