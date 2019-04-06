---
title: Navs
---
# Navs Extra

This extra adds a couple of javascript nav helpers to the `Pagy::Frontend` module: `pagy_compact_nav_js` and `pagy_nav_js`. These are the unstyled nav helpers for pagination.

Other extras (e.g. [bootstrap](bootstrap.md), [bulma](bulma.md), [foundation](foundation.md), [materialize](materialize.md), [semantic](semantic.md)) provide framework-styled versions of the same `nav`, `nav_js` and `compact_nav_js` helpers, so you may not need this extra if you use one of those.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/navs'
```

Configure [javascript](../extras.md#javascript).

## Files

- [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb)

# Javascript Compact Navs

The `*_compact_nav_js` navs (implemented by this extra or by other frontend extras) add an alternative pagination UI that combines the pagination feature with the navigation info in a single compact element.

It is especially useful for small size screens, but it is used also with wide layouts since it is __even faster__ than the classic nav of links, because it needs to render just a minimal HTML string.

## Synopsis

Use the `*_compact_nav_js helpers in any view:

```erb
<%== pagy_compact_nav_js(@pagy) %>
```

Other extras provide also the following framework-styled helpers:

```erb
<%== pagy_bootstrap_compact_nav_js(@pagy) %>
<%== pagy_bulma_compact_nav_js(@pagy) %>
<%== pagy_foundation_compact_nav_js(@pagy) %>
<%== pagy_materialize_compact_nav_js(@pagy) %>
<%== pagy_semantic_compact_nav_js(@pagy) %>
```

## Methods

### pagy_compact_nav_js(pagy, ...)

Renders a compact navigation with a style similar to the `pagy_nav` helper.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id assignation is based on the code line where you use the helper, you _must_ pass an explicit id if you are going to use more than one `pagy_*_nav_js` or `pagy_*_compact_nav_js` call in the same line for the same page.

**Notice**: passing an explicit id is also a bit faster than having pagy to generate one.

# Javascript Navs

With the `*_nav_js` navs (implemented by this extra or by other frontend extras) the number of page links will adapt in real-time to the available window or container width.

Here is a screenshot (from the `bootstrap`extra) of how the same pagination nav might look like by resizing the browser window/container at different widths:

![pagy-nav_js](../assets/images/pagy-nav_js-g.png)

## Synopsis

```ruby
# set your default custom sizes (width/size pairs) globally (it can be overridden per Pagy instance)
Pagy::VARS[:sizes] = { 0 => [1,0,0,1], 540 => [2,3,3,2], 720 => [3,4,4,3] }
```

Use the `*_nav_js` helpers in any view:

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
| `:sizes` | Hash variable to control multipe pagy `:size` at different widths | `nil`   |

### :sizes

The `:sizes` variable is an optional non-core variable used by the `*_nav_js` navs. If defined, it allows you to control multipe pagy `:size` at different widths; if `nil` the `*_nav_js` will behave exactly as a static `*_nav` respecting the single `:size` variable _(see also the [pagy variables](../api/pagy.md#other-variables) doc for details)_.

The `:sizes` variable is a hash where the keys are integers representing the widths in pixels and the values are the Pagy `:size` variables to be applied for that width.

As usual, depending on the scope of the customization, you can set the variables globally or for a single pagy instance.

For example:

```ruby
# globally
Pagy::VARS[:sizes] = { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] }

# or for a single instance
pagy, records = pagy(collection, sizes: { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] } )
```

The above statement means that from `0` to `540` pixels width, Pagy will use the `[2,3,3,2]` size, from `540` to `720` it will use the `[3,5,5,3]` size and over `720` it will use the `[5,7,7,5]` size. (Read more about the `:size` variable in the [How to control the page links](../how-to.md#controlling-the-page-links) section).

**IMPORTANT**: You can set any number of sizes with any arbitrary width/size. The only requirement is that the `:sizes` hash (when defined) must contain always the `0` width or an `ArgumentError` exception will be raises.

#### Setting the right sizes

Setting the widths and sizes can create a nice transition between sizes or some apparently erratic behavior.

Here is what you should consider/ensure:

1. The pagy size can only change in discrete steps: each widht/size pair in your `:sizes` represents a step.

2. The transition from one size to another depends on the width available to the pagy nav. That width is the _internal available width_ of its container (excluding eventual horizontal padding).

3. You should ensure that each pagy `:size` produces a nav that can be contained in its width.

4. You should ensure that the minimum internal width for the container div be equal (or a bit bigger) to the smaller positive width. (`540` pixels in our previous example).

5. If the container width snaps to specific widths in discrete steps, you should sync the quantity and widths of the pagy `:sizes` to the quantity and internal widths for each discrete step of the container.

## Methods

### pagy_nav_js(pagy, ...)

Similar to the `pagy_nav` helper, with added responsiveness.

It can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id assignation is based on the code line where you use the helper, you _must_ pass an explicit id if you are going to use more than one `pagy_*_nav_js` or `pagy_*_compact_nav_js` call in the same line for the same file.

**Notice**: passing an explicit id is also a bit faster than having pagy to generate one.
