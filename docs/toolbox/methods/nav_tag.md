---
title: nav_tag
icon: code
order: 170
image: ""
categories:
  - Methods
  - Navs
  - Tags
---

This method takes the Pagy object and returns the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

![nav_tag (:bootstrap style)](/assets/images/bootstrap_nav.png){width=300}

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground.md#3-demo-app)

```erb View
<%== @pagy.nav_tag(**options) %>
<%== @pagy.nav_tag(:bootstrap, **options) %>
<%== @pagy.nav_tag(:bulma, **options) %>
```

Try it with the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.nav_tag
<nav class="pagy nav" aria-label="Pages"><a href="/path?example=123&page=2" aria-label="Previous">&lt;</a><a href="/path?example=123&page=1">1</a><a href="/path?example=123&page=2">2</a><a role="link" aria-disabled="true" aria-current="page" class="current">3</a><a href="/path?example=123&page=4">4</a><a href="/path?example=123&page=5">5</a><a role="link" aria-disabled="true" class="gap">&hellip;</a><a href="/path?example=123&page=50">50</a><a href="/path?example=123&page=4" aria-label="Next">&gt;</a></nav>
=> nil

>> puts @pagy.nav_tag(:bulma, id: 'my-nav', aria_label: 'Products', slots: 3)
<nav id="my-nav" class="pagy-bulma nav pagination is-centered" aria-label="Products"><a href="/path?example=123&page=2" class="pagination-previous" aria-label="Previous">&lt;</a><a href="/path?example=123&page=4" class="pagination-next" aria-label="Next">&gt;</a><ul class="pagination-list"><li><a href="/path?example=123&page=2" class="pagination-link">2</a></li><li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">3</a></li><li><a href="/path?example=123&page=4" class="pagination-link">4</a></li></ul></nav>
=> nil
```

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

See also [Common Nav Options](../methods#common-nav-options) and [Common URL Options](../methods#common-url-options)

===
