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

<br>

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


[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#demo-app)

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

==- Examples

```ruby Console
require 'pagy/console'
=> true

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007f3d1c193718 @count=1000, @from=41, @in=20, @in_range=true, @last=50, @limit=20, @next=4, @offset=40, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, count: 1000}, @page=3, @previous=2, @request=#<Pagy::Request:0x00007f3d1c7ff2f0 @base_url="http://www.example.com", @cookie=nil, @jsonapi=nil, @path="/path", @params={example: "123"}>, @to=60>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> puts @pagy.series_nav_js
<nav class="pagy series-nav-js" aria-label="Pages" data-pagy="WyJzbmoiLFsiPGEgaHJlZj1cIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9MlwiIHJlbD1cInByZXZcIiBhcmlhLWxhYmVsPVwiUHJldmlvdXNcIj4mbHQ7PC9hPiIsIjxhIGhyZWY9XCIvcGF0aD9leGFtcGxlPTEyMyZwYWdlPVAgXCI+TDwvYT4iLCI8YSByb2xlPVwibGlua1wiIGFyaWEtY3VycmVudD1cInBhZ2VcIiBhcmlhLWRpc2FibGVkPVwidHJ1ZVwiPkw8L2E+IiwiPGEgcm9sZT1cInNlcGFyYXRvclwiIGFyaWEtZGlzYWJsZWQ9XCJ0cnVlXCI+JmhlbGxpcDs8L2E+IiwiPGEgaHJlZj1cIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9NFwiIHJlbD1cIm5leHRcIiBhcmlhLWxhYmVsPVwiTmV4dFwiPiZndDs8L2E+Il0sW1swXSxbWzEsMiwiMyIsNCw1LCJnYXAiLDUwXV0sbnVsbF1d"></nav>
=> nil

>> puts @pagy.series_nav_js(:bulma, id: 'my-nav', aria_label: 'Products', slots: 3)
<nav id="my-nav" class="pagy-bulma series-nav-js pagination" aria-label="Products" data-pagy="WyJzbmoiLFsiPHVsIGNsYXNzPVwicGFnaW5hdGlvbi1saXN0XCI+PGxpPjxhIGhyZWY9XCIvcGF0aD9leGFtcGxlPTEyMyZwYWdlPTJcIiBjbGFzcz1cInBhZ2luYXRpb24tcHJldmlvdXNcIiByZWw9XCJwcmV2XCIgYXJpYS1sYWJlbD1cIlByZXZpb3VzXCI+Jmx0OzwvYT48L2xpPiIsIjxsaT48YSBocmVmPVwiL3BhdGg/ZXhhbXBsZT0xMjMmcGFnZT1QIFwiIGNsYXNzPVwicGFnaW5hdGlvbi1saW5rXCI+TDwvYT48L2xpPiIsIjxsaT48YSByb2xlPVwibGlua1wiIGNsYXNzPVwicGFnaW5hdGlvbi1saW5rIGlzLWN1cnJlbnRcIiBhcmlhLWN1cnJlbnQ9XCJwYWdlXCIgYXJpYS1kaXNhYmxlZD1cInRydWVcIj5MPC9hPjwvbGk+IiwiPGxpPjxzcGFuIGNsYXNzPVwicGFnaW5hdGlvbi1lbGxpcHNpc1wiPiZoZWxsaXA7PC9zcGFuPjwvbGk+IiwiPGxpPjxhIGhyZWY9XCIvcGF0aD9leGFtcGxlPTEyMyZwYWdlPTRcIiBjbGFzcz1cInBhZ2luYXRpb24tbmV4dFwiIHJlbD1cIm5leHRcIiBhcmlhLWxhYmVsPVwiTmV4dFwiPiZndDs8L2E+PC9saT48L3VsPiJdLFtbMF0sW1sxLDIsIjMiLDQsNSwiZ2FwIiw1MF1dLG51bGxdXQ=="></nav>
=> nil
```

==- Styles

See [Common Nav Styles](../helpers#common-nav-styles)

==- Options

- `steps: { 0 => 5, 540 => 7, 720 => 9 }`
  - Enable responsiveness. Assign different number of `:slots` to different tag widths.

See also other appicable options: [Common Nav Options](../helpers#common-nav-options) and [Common URL Options](../paginators#common-url-options)

==- In Depth: `:steps` Option

Notice: when `:steps` is not set, the `series_nav_js` behaves almost as a `series_nav`: just faster.

Set it as a hash, where the keys are integers representing the widths in pixels, and the values are the `:slots` options to be applied for those widths.

For example:

`{ 0 => 5, 540 => 7, 720 => 9 }` means that from `0` to `540` pixels width, Pagy will use `5` slots, from `540` to `720` it will use `7` slots, and over `720` it will use `9` slots. (Read more about the `:slots` option in the [How to control the pagination bar](../../guides/how-to#control-the-pagination-bar) section.)

!!!warning :steps must contain a `0` width 

You can set any number of steps with any arbitrary width/slots. The only requirement is that the `:steps` hash must always contain the `0` width, or a `Pagy::OptionsError` exception will be raised.
!!!

!!! Notice

The `:slots` and `:compact` options used by the `series_nav` are not directly available.
!!!

#### Setting the right steps

<br/>

Setting the `:steps` can enhance responsiveness and ensure seamless transitions.

Consider these guidelines to achieve optimal results:

1. Define discrete `:steps` using width/slots pairs to control the pagination behavior.
2. Ensure the container's width accommodates all slots for a smooth transition as it resizes.
3. Synchronize the pagy `:steps` with your container's discrete width changes, for consistent alignment.
4. Test responsiveness to confirm that assigned slots fit within the corresponding width for each step.

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

The `*_js` helpers are tightly coupled with the javascript code, so any partial overriding on one side would be quite fragile
and might break in a next release.
!!!

===
