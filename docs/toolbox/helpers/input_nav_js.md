---
label: input_nav_js
icon: code
order: 150
image: ""
categories:
  - Methods
  - Navs
  - Tags
---

#

## :icon-code: input_nav_js

---
 
:::raised
![input_nav_js](../../assets/images/pagy-input_nav_js.png){width=204}

---

![input_nav_js(:bootstrap)](../../assets/images/bootstrap-input_nav_js.png){width=178}

---

![input_nav_js(:bulma)](../../assets/images/bulma-input_nav_js.png){width=201}
:::

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#demo-app)

`input_nav_js` combines navigation and pagination info in a single compact element.

It is the fastest and lightest navigator, recommended when you care about efficiency and server load (
see [Maximizing Performance](../../guides/how-to#maximize-performance)) still needing UI.

!!!warning It works with all paginators but `:keyset`
!!!

```erb
<%== @pagy.input_nav_js(**options) %>  <%# default pagy style %>
<%== @pagy.input_nav_js(:bootstrap, **options) %>
<%== @pagy.input_nav_js(:bulma, **options) %>
```

==- Examples

```ruby
>> include Pagy::Console
=> Object

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007f0b3c132998 @count=1000, @from=41, @in=20, @in_range=true, @last=50, @limit=20, @next=4, @offset=40, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, count: 1000}, @page=3, @previous=2, @request=#<Pagy::Request:0x00007f0b3c7ac530 @base_url="http://www.example.com", @cookie=nil, @jsonapi=nil, @path="/path", @query={example: "123"}>, @to=60>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> puts @pagy.input_nav_js
<nav class="pagy input-nav-js" aria-label="Pages" data-pagy="WyJpbmoiLCIvcGF0aD9leGFtcGxlPTEyMyZwYWdlPVAgIl0="><a href="/path?example=123&page=2" rel="prev" aria-label="Previous">&lt;</a><label>Page <input name="page" type="number" min="1" max="50" value="3" aria-current="page" style="text-align: center; width: 2rem; padding: 0;"><a style="display: none;">#</a> of 50</label><a href="/path?example=123&page=4" rel="next" aria-label="Next">&gt;</a></nav>
=> nil

>> puts @pagy.input_nav_js(:bulma, id: 'input-nav', aria_label: 'My pages')
<nav id="input-nav" class="pagy-bulma input-nav-js pagination" aria-label="My pages" data-pagy="WyJpbmoiLCIvcGF0aD9leGFtcGxlPTEyMyZwYWdlPVAgIl0="><ul class="pagination-list"><li><a href="/path?example=123&page=2" class="pagination-previous" rel="prev" aria-label="Previous">&lt;</a></li><li class="pagination-link"><label>Page <input name="page" type="number" min="1" max="50" value="3" aria-current="page"style="text-align: center; width: 2rem; line-height: 1.2rem; border: none; border-radius: .25rem; padding: .0625rem; color: white; background-color: #485fc7;"><a style="display: none;">#</a> of 50</label></li><li><a href="/path?example=123&page=4" class="pagination-next" rel="next" aria-label="Next">&gt;</a></li></ul></nav>
=> nil
```

==- Caveats

!!!danger Overriding `*_js` helpers is not recommended

The `*_js` helpers are tightly coupled with the javascript code, so any partial overriding on one side would be quite fragile
and might break in a next release.
!!!

==- Styles

See [Common Nav Styles](../helpers#common-nav-styles)

==- Options

See [Common Nav Options](../helpers#common-nav-options) and [Common URL Options](../paginators#common-url-options)
===
