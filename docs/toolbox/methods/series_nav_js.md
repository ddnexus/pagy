---
label: series_nav_js
icon: code
order: 160
image: ""
categories:
  - Methods
  - Navs
  - Tags
---

#

## :icon-code: series_nav_js

---

+++Pagy

:::raised
![](../../assets/images/pagy-series_nav_js-11.png){width=428}
:::
:::raised
![](../../assets/images/pagy-series_nav_js-9.png){width=358}
:::
:::raised
![](../../assets/images/pagy-series_nav_js-7.png){width=288}
:::

+++Bootstrap

:::raised
![](../../assets/images/bootstrap-series_nav_js-11.png){width=428}
:::
:::raised
![](../../assets/images/bootstrap-series_nav_js-9.png){width=358}
:::
:::raised
![](../../assets/images/bootstrap-series_nav_js-7.png){width=288}
:::

+++Bulma

:::raised
![](../../assets/images/bulma-series_nav_js-11.png){width=428}
:::
:::raised
![](../../assets/images/bulma-series_nav_js-9.png){width=358}
:::
:::raised
![](../../assets/images/bulma-series_nav_js-7.png){width=288}
:::

+++


[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#3-demo-app)

`series_nav_js` functions similarly to a [series_nav](series_nav.md), with the following added features:

1. Optional responsiveness: Dynamically fills the container width.
2. Improves performance and optimizes resource usage (see [Maximizing Performance](../../guides/how-to#maximize-performance)).

!!!warning It works with all paginators but `:keyset`
!!!

```erb
<%== @pagy.series_nav_js(**options %>  <%# default pagy style %>
<%== @pagy.series_nav_js(:bootstrap, **options) %>
<%== @pagy.series_nav_js(:bulma, **options) %>
```
  
==- Caveats

!!!warning HTML Fallback

If Javascript is disabled in the client browser, this helper will not render anything. You should implement your own HTML fallback:

```erb
<noscript><%== pagy_nav(@pagy) %></noscript>
```

!!!

!!!warning Window Resizing

The `series_nav_js` elements are automatically re-rendered on window resize. If another function changes the size without causing a window resize, you need to explicitly re-render:

```js
document.getElementById('my-pagy-nav-js').render();
```

!!!

!!!danger Overriding `*_js` helpers is not recommended

The `*_js` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile
and might break in a next release.
!!!

==- Styles

See [Common Nav Styles](../methods#common-nav-styles)

==- Options

- `steps: { 0 => 5, 540 => 7, 720 => 9 }`
  - Enable responsiveness. Assign different number of `:slots` to different tag widths.

See also other appicable options: [Common Nav Options](../methods#common-nav-options) and [Common URL Options](../paginators#common-url-options)

==- In Depth: `:steps` Option

Notice: when `:steps` is not set, the `series_nav_js` behaves almost as a `series_nav`: just faster.

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

!!! Notice

The `:slots` and `:compact` options used by the `series_nav` are not directly available.
!!!

#### Setting the right steps

Setting the `:steps` can enhance responsiveness and ensure seamless transitions.

Consider these guidelines to achieve optimal results:

1. Define discrete `:steps` using width/slots pairs to control the pagination behavior.

2. Ensure the container's width accommodates all slots for a smooth transition as it resizes.

3. Synchronize the pagy `:steps` with your container's discrete width changes, for consistent alignment.

4. Test responsiveness to confirm that assigned slots fit within the corresponding width for each step.

===
