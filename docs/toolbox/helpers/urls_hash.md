---
label: urls_hash
icon: list-unordered
order: 180
categories:
  - Methods
  - Helpers
---

#

## :icon-list-unordered: urls_hash

---

`urls_hash` returns the `:first`, `:previous`, `:next`, `:last` non-`nil` URLs hash.

!!!success It works with all paginators
!!!

```ruby Controller
urls_hash = @pagy.urls_hash(**options)
```

==- Examples

```ruby
>> include Pagy::Console
=> Object

>> @pagy, @records = pagy(:offset, collection.new)
=> [#<Pagy::Offset:0x00007ff137d44290 @count=1000, @from=1, @in=20, @in_range=true, @last=50, @limit=20, @next=2, @offset=0, @options={limit: 20, limit_key: "limit", page_key: "page", page: 1, count: 1000}, @page=1, @request=#<Pagy::Request:0x00007ff1383bc2d0 @base_url="http://www.example.com", @cookie=nil, @jsonapi=nil, @path="/path", @params={example: "123"}>, @to=20>, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]]

>> @pagy.urls_hash
=> {first: "/path?example=123", next: "/path?example=123&page=2", last: "/path?example=123&page=50"}

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007ff137cba6f8 @count=1000, @from=41, @in=20, @in_range=true, @last=50, @limit=20, @next=4, @offset=40, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, count: 1000}, @page=3, @previous=2, @request=#<Pagy::Request:0x00007ff137cd4030 @base_url="http://www.example.com", @cookie=nil, @jsonapi=nil, @path="/path", @params={example: "123"}>, @to=60>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> @pagy.urls_hash
=> {first: "/path?example=123", previous: "/path?example=123&page=2", next: "/path?example=123&page=4", last: "/path?example=123&page=50"}
```

==- Options

See [Common URL Options](../paginators#common-url-options)

===
