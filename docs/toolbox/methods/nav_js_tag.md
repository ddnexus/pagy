---
label: nav_js_tag
icon: code
order: 160
image: ""
categories:
  - Methods
  - Navs
  - Tags
---

#

## :icon-code: nav_js_tag

---

`nav_js_tag` functions similarly to a [nav_tag](nav_tag.md), with the following added features:

1. Enables client-side rendering.
2. Provides optional responsiveness.
3. Improves performance and optimizes resource usage (see [Maximizing Performance](../../guides/how-to#maximize-performance)).

![Responsive nav_js_tag (:bootstrap style)](/assets/images/bootstrap_nav_js.png){width=500}

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground.md#3-demo-app)

!!!warning It works with all paginators but `:keyset`
!!!

```erb
<%== @pagy.nav_js_tag(**options %>  <%# default pagy style %>
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

The `nav_js_tag` elements are automatically re-rendered on window resize. If another function changes the size without causing a window resize, you need to explicitly re-render:

```js
document.getElementById('my-pagy-nav-js').render();
```

!!!

!!!danger Overriding `*_js*` helpers is not recommended

The `*_js*` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile
and might break in a next release.
!!!

==- Styles

See [Common Nav Styles](../methods.md#common-nav-styles)

==- Options

- `steps: { 0 => 5, 540 => 7, 720 => 9 }`
  - Enable responsiveness. Assign different number of `:slots` to different tag widths.

See also other applicabe options: [nav_tag Options](nav_tag.md#options)

==- In Depth: `:steps` Option

Notice: when `:steps` is not set, the `nav_js_tag` behaves exactly as a `nav_tag`: just faster.

Set it as a hash, where the keys are integers representing the widths in pixels, and the values are the `:slots` options to be
applied for those widths.

For example:

`{ 0 => 5, 540 => 7, 720 => 9 }` means that from `0` to `540` pixels width, Pagy will use `5` slots, from `540` to `720` it will
use `7` slots, and over `720` it will use `9` slots. (Read more about the `:slots`
option in the [How to control the pagination bar](../../guides/how-to#control-the-pagination-bar) section.)

!!!warning :steps must contain a `0` width 

You can set any number of steps with any arbitrary width/slots. The only requirement is
that the `:steps` hash must always contain the `0` width, or a `Pagy::OptionsError` exception will be raised.
!!!

#### Setting the right steps

Setting the `:steps` can enhance responsiveness and ensure seamless transitions.

Consider these guidelines to achieve optimal results:

1. Define discrete `:steps` using width/slots pairs to control the pagination behavior.

2. Ensure the container's width accommodates all slots for a smooth transition as it resizes.

3. Synchronize the pagy `:steps` with your container's discrete width changes, for consistent alignment.

4. Test responsiveness to confirm that assigned slots fit within the corresponding width for each step.

===
