#

## :icon-list-unordered:&nbsp;&nbsp;urls_hash

---

`urls_hash` returns the `:first`, `:previous`, `:next`, `:last` non-`nil` URLs hash.

!!! JSON:API
With the `jsonapi: true` option, the `:previous` key becomes `:prev`, as the [JSON:API](https://jsonapi.org/format/#fetching-pagination) specification requires.
!!!

!!!success It works with all paginators
!!!

=== :icon-tools:&nbsp; Usage

```ruby Controller
urls_hash = @pagy.urls_hash(**options)
```

==- :icon-pin:&nbsp; Examples

```ruby Console
require 'pagy/console'
=> true

>> @pagy, @records = pagy(:offset, collection.new)
=> [#<Pagy::Offset:0x00007f0802ee9560 @request=#<Pagy::Request:0x00007f0802fa3d98 @options={request: #<Pagy::Request:0x00007f0802fa3d98 ...>, page: 1, client_limit: nil, limit: 20, count: 1000}, @base_url="http://www.example.com", @path="/path", @params={example: "123"}, @cookie=nil>, @options={limit: 20, limit_key: "limit", page_key: "page", page: 1, client_limit: nil, count: 1000}, @limit=20, @count=1000, @page=1, @last=50, @offset=0, @in_range=true, @from=1, @to=20, @in=20, @next=2>, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]]

>> @pagy.urls_hash
=> {first: "/path?example=123", next: "/path?example=123&page=2", last: "/path?example=123&page=50"}

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007f0802ee4b00 @request=#<Pagy::Request:0x00007f0802fa3078 @options={page: 3, request: #<Pagy::Request:0x00007f0802fa3078 ...>, client_limit: nil, limit: 20, count: 1000}, @base_url="http://www.example.com", @path="/path", @params={example: "123"}, @cookie=nil>, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, client_limit: nil, count: 1000}, @limit=20, @count=1000, @page=3, @last=50, @offset=40, @in_range=true, @from=41, @to=60, @in=20, @previous=2, @next=4>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> @pagy.urls_hash
=> {first: "/path?example=123", previous: "/path?example=123&page=2", next: "/path?example=123&page=4", last: "/path?example=123&page=50"}
```

==- :icon-sliders:&nbsp; Options

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

===
