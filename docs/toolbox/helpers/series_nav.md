---
label: series_nav
icon: code
order: 170
image: ""
---

#

## :icon-code:&nbsp;&nbsp;series_nav

---

:::raised
![series_nav](/assets/images/pagy-series_nav.png){width=288}

---

![series_nav(:bootstrap)](/assets/images/bootstrap-series_nav.png){width=248}

---

![series_nav(:bulma)](/assets/images/bulma-series_nav.png){width=304}
:::
<br/>

:::content-center
{{ include "snippets/run-app" app: "demo" }}
:::

`series_nav` returns an HTML string containing pagination links, wrapped in a `nav` tag, ready to be used in your view.

{{ include "snippets/all-but-keyset" }}

=== :icon-tools:&nbsp; Usage

```erb
<%== @pagy.series_nav(**options) %>  <%# default pagy style %>
<%== @pagy.series_nav(:bootstrap, **options) %>
<%== @pagy.series_nav(:bulma, **options) %>
```

==- :icon-pin:&nbsp; Examples

```ruby Console
require 'pagy/console'
=> true

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007f6b44bf36f8 @count=1000, @from=41, @in=20, @in_range=true, @last=50, @limit=20, @next=4, @offset=40, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, count: 1000}, @page=3, @previous=2, @request=#<Pagy::Request:0x00007f6b4525f320 @base_url="http://www.example.com", @cookie=nil, @jsonapi=nil, @path="/path", @params={example: "123"}>, @to=60>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> puts @pagy.series_nav
<nav class="pagy series-nav" aria-label="Pages"><a href="/path?example=123&page=2" rel="prev" aria-label="Previous">&lt;</a><a href="/path?example=123&page=1">1</a><a href="/path?example=123&page=2" rel="prev">2</a><a role="link" aria-disabled="true" aria-current="page">3</a><a href="/path?example=123&page=4" rel="next">4</a><a href="/path?example=123&page=5">5</a><a role="separator" aria-disabled="true">&hellip;</a><a href="/path?example=123&page=50">50</a><a href="/path?example=123&page=4" rel="next" aria-label="Next">&gt;</a></nav>
=> nil

>> puts @pagy.series_nav(:bulma, id: 'my-nav', aria_label: 'Products', slots: 3)
<nav id="my-nav" class="pagy-bulma series-nav pagination" aria-label="Products"><ul class="pagination-list"><li><a href="/path?example=123&page=2" class="pagination-previous" rel="prev" aria-label="Previous">&lt;</a></li><li><a href="/path?example=123&page=2" class="pagination-link" rel="prev">2</a></li><li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">3</a></li><li><a href="/path?example=123&page=4" class="pagination-link" rel="next">4</a></li><li><a href="/path?example=123&page=4" class="pagination-next" rel="next" aria-label="Next">&gt;</a></li></ul></nav>
=> nil
```

{{ include "snippets/nav-styles" }}

==- :icon-sliders:&nbsp; Options

{{ include "options/series" }}

{{ include "options/navs" }}

{{ include "options/helper" }}

===
