#

## :icon-terminal:&nbsp;&nbsp;Console

---

Allows you to interact with Pagy in an [irb](https://github.com/ruby/irb) or [pry](https://github.com/pry/pry) environment without an app, providing a pre-configured stubbed environment for you.

You can use a few methods to create a simple collection paginated with the `:offset` paginator or to set the parameters as needed.

```ruby Console
require 'pagy/console'
=> true

>> request
=> {base_url: "http://www.example.com", path: "/path", params: {example: "123"}}

>> params
=> {example: "123"}

>> collection
=> Pagy::Console::Collection

>> pagy, records = pagy(:offset, collection.new, limit: 10) # Example pagination of sample data
=> [#<Pagy::Offset:0x00007f0802b89438 @request=#<Pagy::Request:0x00007f0802bd0b58 @options={limit: 10, request: #<Pagy::Request:0x00007f0802bd0b58 ...>, page: 1, client_limit: nil, count: 1000}, @base_url="http://www.example.com", @path="/path", @params={example: "123"}, @cookie=nil>, @options={limit: 10, limit_key: "limit", page_key: "page", page: 1, client_limit: nil, count: 1000}, @limit=10, @count=1000, @page=1, @last=100, @offset=0, @in_range=true, @from=1, @to=10, @in=10, @next=2>, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]]

>> pagy.data_hash
=> {url_template: "/path?example=123&page=P ", first_url: "/path?example=123", current_url: "/path?example=123&page=1", page_url: "/path?example=123&page=1", next_url: "/path?example=123&page=2", last_url: "/path?example=123&page=100", count: 1000, page: 1, limit: 10, last: 100, in: 10, from: 1, to: 10, next: 2, options: {limit: 10, limit_key: "limit", page_key: "page", page: 1, client_limit: nil, count: 1000}, series: ["1", 2, 3, 4, 5, :gap, 100]}

>> pagy.urls_hash
=> {first: "/path?example=123", next: "/path?example=123&page=2", last: "/path?example=123&page=100"}

>> pagy.page_url(23)
=> "/path?example=123&page=23"

>> pagy.page_url(:next, absolute: true, fragment: '#my-fragment')
=> "http://www.example.com/path?example=123&page=2#my-fragment"

>> pagy.page_url(:last)
=> "/path?example=123&page=100"

>> puts pagy.series_nav
<nav class="pagy series-nav" aria-label="Pages"><a role="link" aria-disabled="true" aria-label="Previous">&lt;</a><a role="link" aria-disabled="true" aria-current="page">1</a><a href="/path?example=123&amp;page=2" rel="next">2</a><a href="/path?example=123&amp;page=3">3</a><a href="/path?example=123&amp;page=4">4</a><a href="/path?example=123&amp;page=5">5</a><a role="separator" aria-disabled="true">&hellip;</a><a href="/path?example=123&amp;page=100">100</a><a href="/path?example=123&amp;page=2" rel="next" aria-label="Next">&gt;</a></nav>
=> nil

>> puts pagy.input_nav_js
<nav class="pagy input-nav-js" aria-label="Pages" data-pagy="WyJpbmoiLCIvcGF0aD9leGFtcGxlPTEyMyZwYWdlPVAgIiwiUCAiXQ=="><a role="link" aria-disabled="true" aria-label="Previous">&lt;</a><label>Page <input name="page" type="number" min="1" max="100" value="1" aria-current="page" style="text-align: center; width: 2rem; padding: 0;"><a style="display: none;">#</a> of 100</label><a href="/path?example=123&amp;page=2" rel="next" aria-label="Next">&gt;</a></nav>
=> nil

>> puts pagy.info_tag
<span class="pagy info">Displaying items 1-10 of 1000 in total</span>
=> nil
```
