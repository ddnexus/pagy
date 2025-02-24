---
title: pagy • Console
icon: terminal
order: 90
---

Allows you to test Pagy in an [irb](https://github.com/ruby/irb) with an environment stubbed for you.

Standard pagination requires controller, model, view and request object to work, i.e. you need an environment. `Pagy::Console`
gives you that environment, without an app.


```ruby
>> include Pagy::Console
=> Object

>> request
=> #<Pagy::Console::Request:0x00007fb92fb37aa0 @base_url="http://www.example.com", @params={example: "123"}, @path="/path">

>> params
=> {example: "123"}

>> pagy, records = pagy(:offset, collection.new, limit: 10)
=> [#<Pagy::Offset:0x00007fb92fb35840 @count=1000, @from=1, @in=10, @in_range=true, @last=100, @limit=10, @next=2, @offset=0, @options={limit: 10, limit_sym: :limit, page_sym: :page, page: 1, request: {base_url: "http://www.example.com", path: "/path", query_params: {example: "123"}}, count: 1000}, @page=1, @to=10>, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]]

>> pagy.data_hash
=> {url_template: "/path?example=123&page=P ", first_url: "/path?example=123", previous_url: "/path?example=123&page=", page_url: "/path?example=123&page=1", next_url: "/path?example=123&page=2", last_url: "/path?example=123&page=100", count: 1000, page: 1, limit: 10, last: 100, in: 10, from: 1, to: 10, previous: nil, next: 2, options: {limit: 10, limit_sym: :limit, page_sym: :page, page: 1, request: {base_url: "http://www.example.com", path: "/path", query_params: {example: "123"}}, count: 1000}}

>> pagy.links_hash
=> {first: "/path?example=123", next: "/path?example=123&page=2", last: "/path?example=123&page=100"}
=> nil

>> pagy.page_url(23)
=> "/path?example=123&page=23"

>> pagy.page_url(:next, absolute: true, fragment: '#my-fragment')
=> "http://www.example.com/path?example=123&page=2#my-fragment"

>> pagy.page_url(:last)
=> "/path?example=123&page=100"

>> puts pagy.nav_tag
<nav class="pagy nav" aria-label="Pages"><a role="link" aria-disabled="true" aria-label="Previous">&lt;</a><a role="link" aria-disabled="true" aria-current="page" class="current">1</a><a href="/path?example=123&page=2">2</a><a href="/path?example=123&page=3">3</a><a href="/path?example=123&page=4">4</a><a href="/path?example=123&page=5">5</a><a role="link" aria-disabled="true" class="gap">&hellip;</a><a href="/path?example=123&page=100">100</a><a href="/path?example=123&page=2" aria-label="Next">&gt;</a></nav>
=> nil

>> puts pagy.combo_nav_js_tag
<nav class="pagy combo-nav-js" aria-label="Pages" data-pagy="WyJjaiIsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><a role="link" aria-disabled="true" aria-label="Previous">&lt;</a><label>Page <input name="page" type="number" min="1" max="100" value="1" aria-current="page" style="text-align: center; width: 4rem; padding: 0;"><a style="display: none;">#</a> of 100</label><a href="/path?example=123&page=2" aria-label="Next">&gt;</a></nav>
=> nil 
 
>> puts pagy.info_tag
<span class="pagy info">Displaying items 1-10 of 1000 in total</span>
=> nil
 ```
