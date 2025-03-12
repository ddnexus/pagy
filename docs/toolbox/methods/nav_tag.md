---
label: nav_tag
icon: code
order: 170
image: ""
categories:
  - Methods
  - Navs
  - Tags
---

#

## :icon-code: nav_tag

---

`nav_tag` returns an HTML string containing pagination links, wrapped in a `nav` tag, ready to be used in your view.

![nav_tag (:bootstrap style)](/assets/images/bootstrap_nav.png){width=300}

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#3-demo-app)

!!!warning It works with all paginators but `:keyset`
!!!

```erb
<%== @pagy.nav_tag(**options) %>  <%# default pagy style %>
<%== @pagy.nav_tag(:bootstrap, **options) %>
<%== @pagy.nav_tag(:bulma, **options) %>
```

Try this method in the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.nav_tag
<nav class="pagy nav" aria-label="Pages"><a href="/path?example=123&page=2" aria-label="Previous">&lt;</a><a href="/path?example=123&page=1">1</a><a href="/path?example=123&page=2">2</a><a role="link" aria-disabled="true" aria-current="page" class="current">3</a><a href="/path?example=123&page=4">4</a><a href="/path?example=123&page=5">5</a><a role="link" aria-disabled="true" class="gap">&hellip;</a><a href="/path?example=123&page=50">50</a><a href="/path?example=123&page=4" aria-label="Next">&gt;</a></nav>
=> nil

>> puts @pagy.nav_tag(:bulma, id: 'my-nav', aria_label: 'Products', slots: 3)
<nav id="my-nav" class="pagy-bulma nav pagination is-centered" aria-label="Products"><a href="/path?example=123&page=2" class="pagination-previous" aria-label="Previous">&lt;</a><a href="/path?example=123&page=4" class="pagination-next" aria-label="Next">&gt;</a><ul class="pagination-list"><li><a href="/path?example=123&page=2" class="pagination-link">2</a></li><li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">3</a></li><li><a href="/path?example=123&page=4" class="pagination-link">4</a></li></ul></nav>
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
