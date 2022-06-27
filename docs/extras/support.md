---
title: Support
category: Feature Extras
---
# Support Extra

This extra adds support for features like countless or navless pagination, where you don't need the full link bar but only a simple `next` or `prev` link or no link at all (as for [auto-incremental](#auto-incremental)).

## Synopsis

See [extras](/docs/extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/support'
```

## Support for alternative pagination types and features

Besides the classic `pagy*_nav` pagination, the `pagy*_nav_js` and the `pagy*_combo_nav_js` UI components, Pagy offers a few helpers to support a few alternative types of pagination and related features.

### Countless

You can totally avoid one query per render by using the [countless](countless.md) extra. It has a few limitation, but still supports navbar links (see also [Pagy::Countless](/docs/api/countless.md) for more details).

### Navless/incremental

If you don't need the navbar you can just set the `:size` variable to an empty value and the page links will be skipped from the rendering. That works with `Pagy` and `Pagy:Countless` instances. All the `*nav` helpers will render only the `prev` and `next` links/buttons, allowing for a manual incremental pagination.

You can also use the `pagy_prev_link` and `pagy_next_link` helpers provided by this extra, mostly useful if you also use the `countless` extra.

Here is a basic example that uses `pagy_countless` (saving one query per render): 

`pagy.rb` initializer:

```ruby
require 'pagy/extras/countless'
```

`incremental` controller action:

```ruby
def incremental
  @pagy, @records = pagy_countless(Product.all, link_extra: 'data-remote="true"')
end
```

`incremental.html.erb` template:

```erb
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

`_page_items.html.erb` partial shared for AJAX and non-AJAX rendering:

```erb
<% @records.each do |record| %>
  <tr>
    <td><%= record.name %></td>
    <td><%= record.description %></td>
  </tr>
<% end %>
```

`_next_link.html.erb` partial shared for AJAX and non-AJAX rendering:

```erb
<%== pagy_next_link(@pagy, text: 'More...', link_extra: 'id="next_link"') %>
```

`incremental.js.erb` javascript template:

```erb
$('#records_table').append("<%= j(render 'page_items')%>");
$('#div_next_link').html("<%= j(render 'next_link') %>");
```

### Auto-incremental

Automatic incremental pagination (sometimes improperly called "infinite-scroll" pagination) is a UI-less pagination that loads the next page at the end of the listing.

Depending on your environment, there are a few ways to implement it. You can find a simple generic example below, or some more modern specific technique shown in the following posts:

- [Endless Scroll / Infinite Loading with Turbo Streams & Stimulus](https://www.stefanwienert.de/blog/2021/04/17/endless-scroll-with-turbo-streams/) by Stefan Wienert
- [Pagination with Hotwire](https://www.beflagrant.com/blog/pagination-with-hotwire) by Jonathan Greenberg

For a plain old javascript example, we are going to use the same [Incremental](#navlessincremental) code above with just a couple of changes:

**1**. Hide the link in `_next_link.html.erb` by adding a style attribute:

```erb
<%== pagy_next_link(@pagy, text: 'More...', link_extra: 'id="next_link" style="display: none;"') %>
```

**2**. Add a javascript that will click the link when the listing-bottom appears in the viewport on load/resize/scroll. It will keep the page filled with results, one page at a time:

```js
var loadNextPage = function(){
  if ($('#next_link').data("loading")){ return }  // prevent multiple loading
  var wBottom  = $(window).scrollTop() + $(window).height();
  var elBottom = $('#records_table').offset().top + $('#records_table').height();
  if (wBottom > elBottom){
    $('#next_link')[0].click();
    $('#next_link').data("loading", true);
  }
};

window.addEventListener('resize', loadNextPage);
window.addEventListener('scroll', loadNextPage);
window.addEventListener('load',   loadNextPage);
```

### Circular/Infinite

This type of pagination sets the `next` page to `1` when the current page is the last page, allowing an infinite loop through the pages.

For example, it is often used to show a few suggestions of "similar products" in a horizontal stripe of just a few pages of a few items each. Clicking on next will continue to loop through.

For example:

```ruby
@pagy, @suggestions = pagy_countless(Product.all, count: 25, items: 5, cycle: true)
```

Passing a forced `:count` of 25 will generate 5 pages of 5 items each that will always have a next page. Regardless the actual collection count, you will show the first 25 items of the collection, looping in stripes of 5 items each.

You may want to combine it with something like:

```erb
<%== pagy_next_link(@pagy, text: 'More...') %>
```

## Methods

### pagy_prev_url(pagy)

Returns the url for the previous page. Useful to build minimalistic UIs that don't use nav bar links (e.g. `countless` extra).

### pagy_next_url(pagy)

Returns the url for the next page. Useful to build minimalistic UIs that don't use nav bar links (e.g. `countless` extra).

### pagy_prev_link(pagy, text: pagy_t('pagy.nav.prev'), link_extra: "")

Returns the `a` tag for the previous page. It is the same prev link string which is part of the `pagy_nav` helper.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `countless` extra).

### pagy_next_link(pagy, text: pagy_t('pagy.nav.next'), link_extra: "")

Returns the `a` tag for the next page. It is the same next link string which is part of the `pagy_nav` helper.

Useful to build minimalistic helpers UIs that don't use nav bar links (e.g. `countless` extra).

### pagy_prev_link_tag(pagy)

Returns the `link` tag for the previous page. Useful to add the link tag to the HTML `head`.

### pagy_next_link_tag(pagy)

Returns the `link` tag for the next page. Useful to add the link tag to the HTML `head`.
