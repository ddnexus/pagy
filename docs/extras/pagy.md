---
title: Pagy
image: none
categories:
  - Frontend
  - Extra
---

# Pagy Extra

Adds the pagy styled versions of the javascript-powered navs and a few other components to support countless or navless
pagination (incremental, auto-incremental, infinite pagination).

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#3-demo-app)

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/pagy'
```

```erb View (helper)
<%== pagy_nav_js(@pagy, **vars) %>
<%== pagy_combo_nav_js(@pagy, **vars) %>
<%== pagy_prev_a(@pagy, **vars) %>
<%== pagy_next_a(@pagy, **vars) %>
<%== pagy_prev_link(@pagy, **vars) %>
<%== pagy_next_link(@pagy, **vars) %>
```

```ruby URL helpers
pagy_prev_url(@pagy, absolute: bool)
pagy_next_url(@pagy, absolute: bool)
```

See [Javascript](/docs/api/javascript.md).

## Methods

==- `pagy_nav(pagy, **vars)`

!!!
This method is defined in the `Pagy::Frontend` module for efficiency, but referred here for consistency with the other frontend
extras and the same type of components here.
!!!

See [pagy_nav(pagy, **vars)](/docs/api/frontend.md#pagy-nav-pagy-vars).

==- `pagy_nav_js(pagy, **vars)`

See [Javascript Navs](/docs/api/javascript/navs.md).

==- `pagy_combo_nav_js(pagy, **vars)`

See [Javascript Combo Navs](/docs/api/javascript/combo-navs.md).

==- `pagy_info(pagy, **vars)`

!!!
This method is defined in the `Pagy::Frontend` module for efficiency, but referred here for consistency with the same type of
components here.
!!!

See [pagy_info(pagy, **vars)](/docs/api/frontend.md#pagy-info-pagy-vars).

==- `pagy_prev_url(pagy, absolute: false)`

Return the previous page URL string or nil. Useful to build minimalistic UIs that don't use nav
bar links (e.g. `countless` extra).

==- `pagy_next_url(pagy, absolute: false)`

Return the previous page URL string or nil. Useful to build minimalistic UIs that don't use nav bar
links (e.g. `countless` extra).

==- `pagy_prev_a(pagy, **vars)`

Return the enabled/disabled previous page anchor tag. It is the same prev link string which is
part of the `pagy_nav` helper.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `countless` extra).

The keyord argument used from `vars` are:
- `text: pagy_t('pagy.prev')`
- `aria_label: pagy_t('pagy.aria_label.prev)`
- `anchor_string: nil`

==- `pagy_next_a(pagy, **vars)`

Return the enabled/disabled next page anchor tag. It is the same next link string which is part of the
`pagy_nav` helper.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `countless` extra).

The keyord argument used from `vars` are:
- `text: pagy_t('pagy.prev')`
- `aria_label: pagy_t('pagy.aria_label.prev)`
- `anchor_string: nil`

==- `pagy_prev_link(pagy)`

Conditionally return the previous page `link` tag. Useful to add the link tag to the HTML `head`.

==- `pagy_next_link(pagy)`

Conditionally return the next page `link` tag. Useful to add the link tag to the HTML `head`.

===

## Support for alternative pagination types and features

Besides the classic `pagy*_nav` pagination, the `pagy*_nav_js` and the `pagy*_combo_nav_js` UI components, Pagy offers a few
helpers to support a few alternative types of pagination and related features.

### Countless

You can totally avoid one query per render by using the [countless](countless.md) extra. It has a few limitation, but still
supports navbar links (see also [Pagy::Countless](/docs/api/countless.md) for more details).

### Navless/incremental

If you don't need the navbar you can just set the `:size` variable to `0` and the page links will be skipped from the rendering.
That works with `Pagy` and `Pagy:Countless` instances. All the `*nav` helpers will render only the `prev` and `next`
links/buttons, allowing for a manual incremental pagination.

You can also use the `pagy_prev_html`, `pagy_next_html` mostly useful if you also use the `countless` extra.

Here is a basic example that uses `pagy_countless` (saving one query per render):

```ruby pagy.rb (initializer)
require 'pagy/extras/countless'
```

```ruby incremental (controller action)

def incremental
  @pagy, @records = pagy_countless(collection)
end
```

```erb incremental.html.erb (template)
<div id="content">
  <table id="records_table">
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
    <%= render partial: 'page_items' %>
  </table>
  <div id="div_next_link">
    <%= render partial: 'next_link' %>
  </div>
</div>
```

```erb _page_items.html.erb (partial)
<% @records.each do |record| %>
  <tr>
    <td><%= record.name %></td>
    <td><%= record.description %></td>
  </tr>
<% end %>
```

```erb _next_link.html.erb (partial)
<!-- Wrapped in a "pagy" class to apply the pagy CSS style -->
<span id: 'next_link' class="pagy"><%== pagy_next_a(@pagy, text: 'More...', anchor_string: 'data-remote="true"') %><span>
```

```erb incremental.js.erb (javascript template)
$('#records_table').append("<%= j(render 'page_items')%>");
$('#div_next_link').html("<%= j(render 'next_link') %>");
```

### Auto-incremental

Automatic incremental pagination (sometimes improperly called "infinite-scroll" pagination) is a UI-less pagination that loads the
next page at the end of the listing.

Depending on your environment, there are a few ways to implement it. You can find a simple generic example below, or some more
modern specific technique shown in the following posts:

- [Endless Scroll / Infinite Loading with Turbo Streams & Stimulus](https://www.stefanwienert.de/blog/2021/04/17/endless-scroll-with-turbo-streams/)
  by Stefan Wienert
- [Pagination with Hotwire](https://www.beflagrant.com/blog/pagination-with-hotwire) by Jonathan Greenberg

For a plain old javascript example, we are going to use the same [Incremental](#navlessincremental) code above with just a couple
of changes:

**1**. Hide the link in `_next_link.html.erb` by adding a style attribute:

```erb _next_link.html.erb (partial)
<span style="display: none;"><%== pagy_next_a(@pagy, text: 'More...') %></span>
```

**2**. Add a javascript that will click the link when the listing-bottom appears in the viewport on load/resize/scroll. It will
keep the page filled with results, one page at a time:

```js Javascript
var loadNextPage = function() {
  if ($('#next_link a').data("loading")) { return }  // prevent multiple loading
  var wBottom  = $(window).scrollTop() + $(window).height();
  var elBottom = $('#records_table').offset().top + $('#records_table').height();
  if (wBottom > elBottom) {
    $('#next_link a')[0].click();
    $('#next_link a').data("loading", true);
  }
};

window.addEventListener('resize', loadNextPage);
window.addEventListener('scroll', loadNextPage);
window.addEventListener('load', loadNextPage);
```

### Circular/Infinite

This type of pagination sets the `next` page to `1` when the current page is the last page, allowing an infinite loop through the
pages.

For example, it is often used to show a few suggestions of "similar products" in a horizontal stripe of just a few pages of a few
items each. Clicking on next will continue to loop through.

For example:

```ruby Controller (action)
@pagy, @suggestions = pagy_countless(collection, count: 25, items: 5, cycle: true)
```

Passing a forced `:count` of 25 will generate 5 pages of 5 items each that will always have a next page. Regardless the actual
collection count, you will show the first 25 items of the collection, looping in stripes of 5 items each.

You may want to combine it with something like:

```erb View
<%== pagy_next_html(@pagy, text: 'More...') %>
```
