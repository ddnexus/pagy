---
title: Navs
image: none
order: 3
---

# Javascript Navs

The following `pagy*_nav_js` helpers:

- `pagy_nav_js`
- `pagy_bootstrap_nav_js`
- `pagy_bulma_nav_js`
- `pagy_foundation_nav_js`
- `pagy_materialize_nav_js`
- `pagy_semantic_nav_js`

look like a normal `pagy*_nav` but have a few added features:

1. Client-side rendering
2. Optional responsiveness
3. Better performance and resource usage (see [Maximizing Performance](/docs/how-to#maximize-performance))

Here is a screenshot (from the `bootstrap`extra) showing responsiveness at different widths:

![bootstrap_nav_js](/docs/assets/images/bootstrap_nav_js.png)

!!! Interactive Demo Available!

```sh
pagy run demo
```
...and point your browser at http://0.0.0.0:8000
!!!

## Synopsis

See [Setup Javascript](setup).

||| pagy.rb (initializer)

```ruby
# Use just one:
require 'pagy/extras/bootstrap'
require 'pagy/extras/bulma'
require 'pagy/extras/foundation'
require 'pagy/extras/materialize'
require 'pagy/extras/pagy'
require 'pagy/extras/semantic'
require 'pagy/extras/uikit'
```

|||

||| Any View

```erb
<!-- Use just one: -->
<%== pagy_nav_js(@pagy) %>
<%== pagy_bootstrap_nav_js(@pagy) %>
<%== pagy_bulma_nav_js(@pagy) %>
<%== pagy_foundation_nav_js(@pagy) %>
<%== pagy_materialize_nav_js(@pagy) %>
<%== pagy_semantic_nav_js(@pagy) %>
```

|||

## Variables

| Variable | Description                                                        | Default |
|:---------|:-------------------------------------------------------------------|:--------|
| `:steps` | Hash variable to control multiple pagy `:size` at different widths | `false` |

=== How to use the :steps variable

The `:steps` is an optional non-core variable used by the `pagy*_nav_js` navs. If it's `false`, the `pagy*_nav_js` will behave
exactly as a static `pagy*_nav` respecting the single `:size` variable, just faster and lighter. If it's defined as a hash, it
allows you to control multiple pagy `:size` at different widths.

You can set the `:steps` as a hash where the keys are integers representing the widths in pixels and the values are the
Pagy `:size` variables to be applied for that width.

As usual, depending on the scope of the customization, you can set the variables globally or for a single pagy instance, or even
pass it to the `pagy*_nav_js` helper as an optional keyword argument.

For example:

||| pagy.rb (initializer)

```ruby
# globally
Pagy::DEFAULT[:steps] = { 0 => 5, 540 => [3, 5, 5, 3], 720 => [5, 7, 7, 5] }
```

|||

||| Controller

```ruby
# or for a single instance
pagy, records = pagy(collection, steps: { 0 => 5, 540 => [3, 5, 5, 3], 720 => [5, 7, 7, 5] })

# or use the :size as any static pagy*_nav
pagy, records = pagy(collection, steps: false)
```

|||

```erb
or pass it to the helper
<%== pagy_nav_js(@pagy, steps: {...}) %>
```

The above statement means that from `0` to `540` pixels width, Pagy will use the `5` size (orginating a simple nav without gaps),
from `540` to `720` it will use the `[3,5,5,3]` size and over `720` it will use the `[5,7,7,5]` size. (Read more about the `:size`
variable in the [How to control the page links](/docs/how-to#control-the-page-links) section).

!!!primary :steps must contain `0` width
You can set any number of steps with any arbitrary width/size. The only requirement is that the `:steps` hash must contain always
the `0` width or a `Pagy::VariableError` exception will be raised.
!!!

#### Setting the right sizes

Setting the widths and sizes can create a nice transition between widths or some apparently erratic behavior.

Here is what you should consider/ensure:

1. The pagy size changes in discrete `:steps`, defined by the width/size pairs.

2. The automatic transition from one size to another depends on the width available to the pagy nav. That width is the _internal
   available width_ of its container (excluding eventual horizontal padding).

3. You should ensure that - for each step - each pagy `:size` produces a nav that can be contained in its width.

4. You should ensure that the minimum internal width for the container div be equal (or a bit bigger) to the smaller positive
   width. (`540` pixels in our previous example).

5. If the container width snaps to specific widths in discrete steps, you should sync the quantity and widths of the pagy `:steps`
   to the quantity and internal widths for each discrete step of the container.

===

!!!warning Window Resizing
The `pagy_*nav_js` elements are automatically re-rendered on window resize. However, if the container width changes *without*
being triggered by a window resize, you need to explicitly re-render:

```js
document.getElementById('my-pagy-nav-js').render();
```

!!!

## Methods

==- `pagy*_nav_js(pagy, **vars)`

The method accepts also the same optional keyword arguments variables of
the [pagy_nav(pagy, **vars)](/docs/api/frontend#pagy-nav-pagy-vars)

===
