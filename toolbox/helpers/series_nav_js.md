#

## :icon-code:&nbsp;&nbsp;series_nav_js&nbsp;&nbsp;[!button variant="info" icon="alert" size="s" corners="pill" text="JavaScript Setup Required!"](/resources/javascript)

<br>

+++Pagy

:::raised
![](/assets/images/pagy-series_nav_js-11.png){width=428}
:::
:::raised
![](/assets/images/pagy-series_nav_js-9.png){width=358}
:::
:::raised
![](/assets/images/pagy-series_nav_js-7.png){width=288}
:::

+++Bootstrap

:::raised
![](/assets/images/bootstrap-series_nav_js-11.png){width=428}
:::
:::raised
![](/assets/images/bootstrap-series_nav_js-9.png){width=358}
:::
:::raised
![](/assets/images/bootstrap-series_nav_js-7.png){width=288}
:::

+++Bulma

:::raised
![](/assets/images/bulma-series_nav_js-11.png){width=428}
:::
:::raised
![](/assets/images/bulma-series_nav_js-9.png){width=358}
:::
:::raised
![](/assets/images/bulma-series_nav_js-7.png){width=288}
:::

+++

:::content-center
[!button corners="pill" variant="info" icon="play-24" text="Check it out with `bundle exec pagy demo`"](/sandbox/playground/#demo)
:::

`series_nav_js` functions similarly to a [series_nav](series_nav.md), with the following added features:

1. Optional responsiveness: dynamically fills the container width.
2. Improves performance and optimizes resource usage (see [Maximize performance](/guides/how-to#maximize-performance)).

!!!warning
It works with all paginators but `:keyset`.
!!!

=== :icon-tools:&nbsp; Usage

```erb
<%== @pagy.series_nav_js(**options) %>  <%# default pagy style %>
<%== @pagy.series_nav_js(:bootstrap, **options) %>
<%== @pagy.series_nav_js(:bulma, **options) %>
```

==- :icon-pin:&nbsp; Examples

```ruby Console
require 'pagy/console'
=> true

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007f0802cb1540 @request=#<Pagy::Request:0x00007f0802fa9068 @options={page: 3, request: #<Pagy::Request:0x00007f0802fa9068 ...>, client_limit: nil, limit: 20, count: 1000}, @base_url="http://www.example.com", @path="/path", @params={example: "123"}, @cookie=nil>, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, client_limit: nil, count: 1000}, @limit=20, @count=1000, @page=3, @last=50, @offset=40, @in_range=true, @from=41, @to=60, @in=20, @previous=2, @next=4>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> puts @pagy.series_nav_js
<nav class="pagy series-nav-js" aria-label="Pages" data-pagy="WyJzbmoiLFsiPGEgaHJlZj1cIi9wYXRoP2V4YW1wbGU9MTIzJmFtcDtwYWdlPTJcIiByZWw9XCJwcmV2XCIgYXJpYS1sYWJlbD1cIlByZXZpb3VzXCI+Jmx0OzwvYT4iLCI8YSBocmVmPVwiL3BhdGg/ZXhhbXBsZT0xMjMmYW1wO3BhZ2U9UCBcIj5MPC9hPiIsIjxhIHJvbGU9XCJsaW5rXCIgYXJpYS1jdXJyZW50PVwicGFnZVwiIGFyaWEtZGlzYWJsZWQ9XCJ0cnVlXCI+TDwvYT4iLCI8YSByb2xlPVwic2VwYXJhdG9yXCIgYXJpYS1kaXNhYmxlZD1cInRydWVcIj4maGVsbGlwOzwvYT4iLCI8YSBocmVmPVwiL3BhdGg/ZXhhbXBsZT0xMjMmYW1wO3BhZ2U9NFwiIHJlbD1cIm5leHRcIiBhcmlhLWxhYmVsPVwiTmV4dFwiPiZndDs8L2E+Il0sIlAgIixbWzBdLFtbMSwyLCIzIiw0LDUsImdhcCIsNTBdXSxudWxsXV0="></nav>
=> nil

>> puts @pagy.series_nav_js(:bulma, id: 'my-nav', aria_label: 'Products', slots: 3)
<nav id="my-nav" class="pagy-bulma series-nav-js pagination" aria-label="Products" data-pagy="WyJzbmoiLFsiPHVsIGNsYXNzPVwicGFnaW5hdGlvbi1saXN0XCI+PGxpPjxhIGhyZWY9XCIvcGF0aD9leGFtcGxlPTEyMyZhbXA7cGFnZT0yXCIgY2xhc3M9XCJwYWdpbmF0aW9uLXByZXZpb3VzXCIgcmVsPVwicHJldlwiIGFyaWEtbGFiZWw9XCJQcmV2aW91c1wiPiZsdDs8L2E+PC9saT4iLCI8bGk+PGEgaHJlZj1cIi9wYXRoP2V4YW1wbGU9MTIzJmFtcDtwYWdlPVAgXCIgY2xhc3M9XCJwYWdpbmF0aW9uLWxpbmtcIj5MPC9hPjwvbGk+IiwiPGxpPjxhIHJvbGU9XCJsaW5rXCIgY2xhc3M9XCJwYWdpbmF0aW9uLWxpbmsgaXMtY3VycmVudFwiIGFyaWEtY3VycmVudD1cInBhZ2VcIiBhcmlhLWRpc2FibGVkPVwidHJ1ZVwiPkw8L2E+PC9saT4iLCI8bGk+PHNwYW4gY2xhc3M9XCJwYWdpbmF0aW9uLWVsbGlwc2lzXCI+JmhlbGxpcDs8L3NwYW4+PC9saT4iLCI8bGk+PGEgaHJlZj1cIi9wYXRoP2V4YW1wbGU9MTIzJmFtcDtwYWdlPTRcIiBjbGFzcz1cInBhZ2luYXRpb24tbmV4dFwiIHJlbD1cIm5leHRcIiBhcmlhLWxhYmVsPVwiTmV4dFwiPiZndDs8L2E+PC9saT48L3VsPiJdLCJQICIsW1swXSxbWzIsIjMiLDRdXSxudWxsXV0="></nav>
=> nil
```

==- :icon-eye:&nbsp; Styles

`:pagy/nil`
: Pagy default style

`:bootstrap`
: Set `classes: 'pagination pagination-sm any-class'` style option to override the default `'pagination'` class.

`:bulma`
: Set `classes: 'pagination is-small any-class'` style option to override the default `'pagination'` classes.

==- :icon-sliders:&nbsp; Options

`slots: 9`
: Override the default number of page `:slots` used for the navigation bar.
  - `slots < 7` fills the slots with contiguous pages around the current one.
  - `slots >= 7` reserves the first and last slots for the first and last pages, separated from the rest by a `...` (`:gap`) slot when needed.
  - Prefer odd numbers of slots, which place the current page in the central slot.

`compact: true`
: Fill all the slots with contiguous pages, regardless of the number of slots.

`steps: { 0 => 5, 540 => 7, ... }`
: Enable responsiveness. Assign a different number of `:slots` to different tag widths. It overrides the `:slots` option.

`id: 'my-nav'`
: Set the `id` HTML attribute of the `nav` tag.

`aria_label: 'My Label'`
: Override the default `pagy.aria_label.nav` string of the `aria-label` attribute.<br/>See [ARIA](/resources/ARIA.md).

  !!!danger
  The `nav` elements are `landmark roles` and should be distinctly labeled!
  !!!

  !!!success
  Override the default `:aria_label`s for multiple navs with distinct values!
  ```erb
  <%# Explicitly set the aria_label %>
  <%== @pagy.series_nav(aria_label: 'Search result pages') %>
  ```
  !!!

`anchor_string: 'data-turbo-frame="paginate"'`
: Concatenate a verbatim raw string to the internal HTML of the anchor tags. It must contain properly formatted HTML attributes. It's not suitable for `*_hash` helpers.

`absolute: true`
: Makes the URL absolute.

`path: '/my_path'`
: Overrides the request path in pagination URLs. Use the path only (not the absolute URL). _(see [Override the request path](/guides/how-to#override-the-request-path))_

`fragment: '...'`
: URL fragment string.

`querify: tweak`
: Set it to a `lambda` to directly edit the passed string-keyed params hash itself. Its result is ignored.
  ```ruby
  tweak = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
  ```

==- :icon-log:&nbsp; In Depth: `:steps` Option

Notice: when `:steps` is not set, the `series_nav_js` behaves almost like a `series_nav`: just faster.

Set it as a hash, where the keys are integers representing the widths in pixels, and the values are the `:slots` options to be applied for those widths.

For example:

`{ 0 => 5, 540 => 7, 720 => 9 }` means that from `0` to `540` pixels width, Pagy will use `5` slots, from `540` to `720` it will use `7` slots, and over `720` it will use `9` slots. (Read more about the `:slots` option in the [Control the pagination bar](/guides/how-to#control-the-pagination-bar) section.)

!!!warning :steps must contain a `0` width
You can set any number of steps with any arbitrary width/slots. The only requirement is that the `:steps` hash must always contain the `0` width, or a `Pagy::OptionError` exception will be raised.
!!!

!!! Notice
The `:steps` option overrides the `:slots` option, while the `:compact` option applies to all the steps.
!!!

#### Setting the right steps

<br/>

Setting the `:steps` can enhance responsiveness and ensure seamless transitions.

Consider these guidelines to achieve optimal results:

1. Define discrete `:steps` using width/slots pairs to control the pagination behavior.
2. Ensure the container's width accommodates all slots for a smooth transition as it resizes.
3. Synchronize the pagy `:steps` with your container's discrete width changes, for consistent alignment.
4. Test responsiveness to confirm that assigned slots fit within the corresponding width for each step.

==- :icon-alert:&nbsp; Caveats

!!!warning HTML Fallback
If JavaScript is disabled in the client browser, this helper will not render anything. You should implement your own HTML fallback:
```erb
<noscript><%== @pagy.series_nav %></noscript>
```
!!!

!!!warning Window Resizing
The `series_nav_js` elements are automatically re-rendered on window resize. If another function changes the size without causing a window resize, you need to explicitly re-render:
```js
document.getElementById('my-pagy-nav-js').render();
```
!!!

!!!danger Overriding `*_js` helpers is not recommended
The `*_js` helpers are tightly coupled with the JavaScript code, so any partial overriding on one side would be quite fragile and might break in future releases.
!!!

===
