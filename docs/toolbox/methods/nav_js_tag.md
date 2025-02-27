---
title: nav_js_tag
icon: code
order: 160
image: ""
categories:
  - Methods
  - Navs
  - Tags
---

The `nav_js_tag` looks like a normal [nav_tag](nav_tag.md), but it has a few added features:

1. Client-side rendering
2. Optional responsiveness
3. Better performance and resource usage (see [Maximizing Performance](../../guides/how-to#maximize-performance))

![Responsive nav_js_tag (:bootstrap style)](/assets/images/bootstrap_nav_js.png){width=500}

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground.md#3-demo-app)

```erb
<%== @pagy.nav_js_tag(**options %>  <%# native pagy style %>
<%== @pagy.nav_js_tag(:bootstrap, **options) %>
<%== @pagy.nav_js_tag(:bulma, **options) %>
```
  
==- Caveats

!!!warning HTML Fallback

If Javascript is disabled in the client browser, this helper will not render anything. You should implement your own HTML fallback:

```erb
<noscript><%== pagy_nav(@pagy) %></noscript>
```

!!!

!!!warning Window Resizing

The `nav_js_tag` elements are automatically re-rendered on window resize. However, if the container width changes *without*
being triggered by a window resize (i.e. another javascript function did it), you need to explicitly re-render:

```js
document.getElementById('my-pagy-nav-js').render();
```

!!!

!!!danger Overriding `*_js*` helpers is not recommended

The `*_js*` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile
and might break in a next release.
!!!

==- Styles

- default
- `:boostrap`
  - Set `classes: 'pagination bootstrap class` to override the default `'pagination'` class.
- `:bulma`
  - Set `classes: 'pagination bulma class` to override the default `'pagination is-centered'` classes.

==- Options

- `slots: 9`
  - Override the default number of page `:slots` used for the navigation bar.
  - `slots < 7` causes the slots to be filled by contiguous pages around the current one
  - `slots >= 7` causes the first and last slots to be occupied by first and last pages, separated by the rest with a `...` (
    `:gap`) slot when needed.
  - Even numbers determine the current page to be in the central slot.
- `compact: true`
  - Fill all the slots with contiguos pages, regardles the number of slots.
- `steps: { 0 => 5, 540 => 7, 720 => 9 }`
  - Enable responsiveness. Assign different number of `:slots` to different tag widths.

See also [Common Nav Options](../methods#common-nav-options) and [Common URL Options](../methods#common-url-options)

==- In Depth: `:steps` Option

Notice: when `:steps` is not set, the `nav_js_tag` behave exactly as a `nav_tag`: just faster.

Set it as a hash, where the keys are integers representing the widths in pixels, and the values are the `:slots` options to be
applied for that width.

For example:

`{ 0 => 5, 540 => 7, 720 => 9 }` means that from `0` to `540` pixels width, Pagy will use `5` slots, from `540` to `720` it will
use `7` slots and over `720` it will use `9` slots. (Read more about the `:slots`
option in the [How to control the pagination bar](../../guides/how-to#control-the-pagination-bar) section).

!!!primary :steps must contain `0` width You can set any number of steps with any arbitrary width/slots. The only requirement is
that the `:steps` hash must contain always the `0` width or a `Pagy::OptionsError` exception will be raised.
!!!

#### Setting the right steps

Setting the `:steps` can create a nice transition between widths or some apparently erratic behavior.

Here is what you should consider/ensure:

1. The pagy slots changes in discrete `:steps`, defined by the width/slots pairs.

2. The automatic transition from one step to another depends on the width available to the pagy nav. That width is the _internal
   available width_ of its container (excluding eventual horizontal padding).

3. You should ensure that - for each step - each assigned number of `:slots` produces a nav that can be contained in its width.

4. You should ensure that the minimum internal width for the container div, be equal (or a bit bigger) to the smaller positive
   width. (`540` pixels in our previous example).

5. If the container width snaps to specific widths in discrete steps, you should sync the quantity and widths of the pagy `:steps`
   to the quantity and internal widths for each discrete step of the container.

===
