---
label: page_url
icon: arrow-right
order: 175
categories:
  - Methods
  - Helpers
---

`page_url` returns the URL of any page of any instance. If the page is not available it returns `nil`. It is useful to build minimalistic UIs that don't use nav bar links (e.g. [:keyset](../paginators/keyset.md) paginator).

!!!success It works with all paginators
!!!

Try this method in the [Pagy Console](../../sandbox/console.md):

```ruby
>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007f77c4a352f8 @count=1000, @from=41, @in=20, @in_range=true, @last=50, @limit=20, @next=4, @offset=40, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, request: {base_url: "http://www.example.com", path: "/path", query_hash: {example: "123"}}, count: 1000}, @page=3, @previous=2, @to=60>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> @pagy.page_url(:first)
=> "/path?example=123"

>> @pagy.page_url(:current)
=> "/path?example=123&page=3"

>> @pagy.page_url(:previous)
=> "/path?example=123&page=2"

>> @pagy.page_url(:next)
=> "/path?example=123&page=4"

>> @pagy.page_url(:last)
=> "/path?example=123&page=50"

>> @pagy.page_url(23, page_key: 'custom_page')
=> "/path?example=123&custom_page=23"

>> @pagy.page_url(23, absolute: true)
=> "http://www.example.com/path?example=123&page=23"

>> @pagy.page_url('long-page-id', absolute: true)
=> "http://www.example.com/path?example=123&page=long-page-id"
```

==- Options

See [Common URL Options](../methods#common-url-options)

===
