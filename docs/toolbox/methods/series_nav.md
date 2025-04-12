---
label: series_nav
icon: code
order: 170
image: ""
categories:
  - Methods
  - Navs
  - Tags
---

#

## :icon-code: series_nav

---

:::raised
![series_nav](../../assets/images/series_nav.png){width=288}

---

![series_nav(:bootstrap)](../../assets/images/series_nav-bootstrap.png){width=248}

---

![series_nav(:bulma)](../../assets/images/series_nav-bulma.png){width=304}
:::
<br/>

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#3-demo-app)

`series_nav` returns an HTML string containing pagination links, wrapped in a `nav` tag, ready to be used in your view.

!!!warning It works with all paginators but `:keyset`
!!!

```erb
<%== @pagy.series_nav(**options) %>  <%# default pagy style %>
<%== @pagy.series_nav(:bootstrap, **options) %>
<%== @pagy.series_nav(:bulma, **options) %>
```

Try this method in the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.series_nav
<nav class="pagy series-nav" aria-label="Pages"><a href="/path?example=123&page=2" aria-label="Previous">&lt;</a><a href="/path?example=123&page=1">1</a><a href="/path?example=123&page=2">2</a><a role="link" aria-disabled="true" aria-current="page" class="current">3</a><a href="/path?example=123&page=4">4</a><a href="/path?example=123&page=5">5</a><a role="link" aria-disabled="true" class="gap">&hellip;</a><a href="/path?example=123&page=50">50</a><a href="/path?example=123&page=4" aria-label="Next">&gt;</a></nav>
=> nil

>> puts @pagy.series_nav(:bulma, id: 'my-nav', aria_label: 'Products', slots: 3)
<nav id="my-nav" class="pagy-bulma series-nav pagination is-centered" aria-label="Products"><a href="/path?example=123&page=2" class="pagination-previous" aria-label="Previous">&lt;</a><a href="/path?example=123&page=4" class="pagination-next" aria-label="Next">&gt;</a><ul class="pagination-list"><li><a href="/path?example=123&page=2" class="pagination-link">2</a></li><li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">3</a></li><li><a href="/path?example=123&page=4" class="pagination-link">4</a></li></ul></nav>
=> nil
```

==- Styles

See [Common Nav Styles](../methods#common-nav-styles)

==- Options

- `slots: 9`
  - Override the default number of page `:slots` used for the navigation bar.
  - `slots < 7` causes the slots to be filled by contiguous pages around the current one
  - `slots >= 7` causes the first and last slots to be occupied by first and last pages, separated by the rest with a `...` (`:gap`) slot when needed.
  - Prefer odd numbers of slots, which determine the current page to be in the central slot.
- `compact: true`
  - Fill all the slots with contiguos pages, regardles the number of slots.

See also other appicable options: [Common Nav Options](../methods#common-nav-options) and [Common URL Options](../paginators#common-url-options)

===
