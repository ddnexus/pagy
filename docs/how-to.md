---
title: How To
order: 8
icon: tools-24
---

# How To

This page contains the practical tips and examples to get the job done with Pagy.

You can also [Ask any question to the Pagy trained AI](https://gurubase.io/g/pagy) for instant answers not covered in this page.

## Choose the right pagination technique

[AI-powered answer](https://gurubase.io/g/pagy/choose-between-pagy-offset-countless-keyset)

## Control the items per page
 
==- Server side

Use the `limit` option passing it to ANY paginator method. For example:

```ruby
@pagy, @records = pagy_offset(collection, limit: 30)
```

!!! warning ActiveRecord `limit`
The defined `:limit` option overrides any `limit` already set in `ActiveRecord` collections:

```ruby
# the limit used in the query will be 10
@pagy, @products = pagy_offset(collection, limit: 10)
```

!!!

==- Client Side

You can also allow the client to request a custom limit by using the `:requestable_limit` option, set to the maximum requestable limit.

```ruby
# The client can request any limit up-to 1_000
@pagy, @products = pagy_offset(collection, requestable_limit: 1_000)
```

Optionally, you can use the `pagy_limit_selector_js` helper to provide a UI selector to the user.
[TODO REPLACE LINK]

===

## Control the page links

You can control the number and position of the page links in the navigation through the `:length` option or overriding the
`series` method.

==- Using `:length`

The `:length` option determines the length of the series of page links, used by the helpers providing a nav bar. The option should be passed to the nav helper but it can also be passed to the paginator.

The current page is placed
as centered as possible in the series, so `:length` works better when it's an odd number.

By default, the series includes the first/last and `:gap`s pages (if the `:length` is at least `7`)

Set the `compact: true` option, to ingore first/last and gaps, and get always an uninterrupted/compact series.

Use `length: 0` to skip the generation of the series:

Examples:

```ruby
# Skip the generation of the series
pagy, = pagy_offset(collection, page: 99, length: 0)
pagy.series
#=> []

# length < 7   (compact series by default)
pagy, = pagy_offset(collection, page: 10, length: 5)
pagy.series
#=> [8, 9, "10", 11, 12]
pagy, = pagy_offset(collection, page: 2, length: 5)
pagy.series
#=> [1, "2", 3, 4, 5]
pagy, = pagy_offset(collection, page: 99, length: 5)
pagy.series
#=> [96, 97, 98, "99", 100] 

# length >= 7 (first, last and gap added)
pagy, = pagy_offset(collection, page: 10, length: 7)
pagy.series
#=> [1, :gap, 9, "10", 11, :gap, 100] 
pagy, = pagy_offset(collection, page: 10, length: 7, compact: true)
pagy.series
#=> [7, 8, 9, "10", 11, 12, 13]  # compact series without gaps 
pagy, = pagy_offset(collection, page: 2, length: 7)
pagy.series
#=> [1, "2", 3, 4, 5, :gap, 100]
pagy, = pagy_offset(collection, page: 99, length: 7)
pagy.series
#=> [1, :gap, 96, 97, 98, "99", 100] 
```

==- Overriding `series`

If changing the `:length` is not enough for your requirements (e.g. if you need to add intermediate segments or midpoints in place
of gaps) you should override the `series` method (defined in the `Pagy::Core::Seriable` module).

===

## Pass the page number

You don't need to explicitly pass the page number to the `pagy` method, because pagy gets it from the `params[:page]`, however,
you can force a `page` number by just passing it to the `pagy` method. For example:

```ruby controller
@pagy, @records = pagy_offset(collection, page: 3) # force page #3
```

## Customize the dictionary

Pagy uses standard i18n dictionaries to translate its string and allow overriding. (see [Pagy::I18n documentation](api/frontend/support/i18n.md).)

<details>

<summary>Default en dictionary</summary>

:::code source="/gem/locales/en.yml" :::

</details>
<br>

Customize the translations by creating a customized copy of the dictionaries in a dir (e.g. `config/locales`), and unshift its pathname to the `PATHNAMES` array.

Example for Rails:

```ruby pagy.rb (initializer)
Pagy::I18n::PATHNAMES.unshift(Rails.root.join('config/locales'))
```

## Customize the ARIA labels

Customize the `aria-label` attributes of any `*nav*` helpers by passing the `:aria_label` string (
See [pagy_nav](api/frontend.md#pagy-nav-pagy-opts))

You can also replace the `pagy.aria_label.nav` strings in the dictionary, as well as the `pagy.aria_label.prev` and the
`pagy.aria_label.next`.

See more details in the [ARIA attributes Page](api/frontend/support/ARIA.md).

## Customize the page or limit symbols

By default, pagy gets the page from the `params[:page]` and creates the URLs using the `:page` query_param `?page=3`.

Set the `page_sym: :your_symbol` to override the URL generation (i.e. `?your_symbol=3`)

Set the `limit_sym` to customize the `limit` param the same way.

## Customize the link attributes

Customize the HTML attribute of the page links by passing some extra attribute string with the `:a_string_attributes` keyword argument. For example:

```erb
<%== pagy_nav(@pagy, a_string_attributes: 'data-remote="true"') %>
```

_See more advanced details about [The a_string_attributes argument](api/frontend.md#the-a_string_attributes-argument)_

## Customize the params

Alter the params embedded in the URLs of the page links by setting the option
`:params` to a `Hash` of params to merge, or a `Proc` that can edit/add/delete the request params.

If it is a `Proc` it will receive the **key-stringified** `params` hash complete with the `page` param, and it should modify it in place.

An example using `except!` (available in Rails) and `merge!`:

```ruby controller
@pagy, @records = pagy_offset(collection, params: ->(params) { params.except!('not_useful').merge!('custom' => 'useful') })
```

You can also use the `:fragment` keyword argument to add a fragment to the URLs of the pages:

```erb view
<%== pagy_nav(@pagy, fragment: '#your-fragment') %>
```

!!!warning For efficiency reasons the `:fragment` string must include the `"#"`!
!!!

## Customize CSS styles

Pagy includes a few [stylesheets](api/frontend/support/stylesheets.md) that you can customize, and provides a few styled frontend for [bootstrap](extras/bootstrap.md), [bulma](extras/bulma.md)
 that come with a decent styling provided by their respective framework.

You can also override the specific helper method.

## Override CSS rules in element "style" attribute

In order to get a decent default look, a couple of helpers (i.e. `pagy*_combo_nav_js`, `pagy_limit_selector_js`) assign element
style attributes to one or more tags. You can override their rules in your own stylesheets by using the attribute `[style]`
selector and `!important`. Here is an example for overriding the `width` of the `input` element:

```css
.pagy input[style] {
  /* This is just for the sake of demo: indeed the width is already calculated and assigned dynamically 
     considering the total number of digits that may appear in the input, so you should not need to override it */
  width: 5rem !important;
}
```

## Override pagy methods

You include the pagy modules in your controllers and helpers, so if you want to override any of them, you can redefine them right
in your code, where you included them.

You can read more details in the
nice [How to Override pagy methods only in specific circumstances](https://benkoshy.github.io/2020/02/01/overriding-pagy-methods.html)
mini-post by Ben Koshy.

Also, consider that you can use `prepend` if you need to do it globally:

```ruby

module MyOverridingModule
  def pagy_any_method
    #...
    super
    #...
  end
end
Pagy::Backend.prepend MyOverridingModule
# and/or
Pagy::Frontend.prepend MyOverridingModule
```

### Override `pagy_get_count`: use `count_documents` with Mongoid

```rb
# e.g. applicaton_controller.rb
def pagy_get_count(collection, opts)
  collection.respond_to?(:count_documents) ? collection.count_documents : super
end
```

## Paginate an Array

See the [array](extras/array.md) extra.
[TODO REPLACE LINK]

## Paginate ActiveRecord collections

Pagy works out of the box with `ActiveRecord` collections, however here are a few specific cases that might be treated
differently:

==- Grouped collection

For better performance of grouped ActiveRecord collection counts, you may want to take a look at the [arel extra](extras/arel.md). [TODO REPLACE LINK]

==- Decorated collection

Do it in 2 steps: first get the page of records without decoration, and then apply the decoration to it. For example:

```ruby controller
@pagy, records     = pagy_offset(Post.all)
@decorated_records = records.decorate # or YourDecorator.method(records) whatever works
```

==- Custom scope/count

Your scope might become complex and the default pagy `collection.count(:all)` may not get the actual count. In that case you can
get the right count in a couple of ways:

```ruby controller
# Passing the right arguments to the internal `collection.count(...)` (See the ActiveRecord documentation for details)
@pagy, @records = pagy_offset(custom_scope, count_args: [:join])

# or directly pass the right count to pagy (that will directly use it skipping its own `collection.count(:all)`)
@pagy, @records = pagy_offset(custom_scope, count: custom_count)
```

==- Ransack results

Ransack `result` returns an `ActiveRecord` collection, which can be paginated out of the box. For example:

```ruby controller
q              = Person.ransack(params[:q])
@pagy, @people = pagy_offset(q.result)
```

==- PostgreSQL Collections

[Always order your collections!](troubleshooting.md#records-may-randomly-repeat-in-different-pages-or-be-missing)

===

## Paginate for generic API clients

Check out:
- [Pagy::Keyset](api/keyset.md) 
- [headers extra](extras/headers.md) 
- [limit extra](extras/limit.md)
- [jsonapi extra](extras/jsonapi.md)

[TODO REPLACE LINKS]

## Paginate with JSON:API

Pass the `jsonapi: true` to the paginator, optionally using `:page_sym` and `:limit_sym`:

```ruby
# JSON:API nested query_params: E.g.: ?page[number]=2&page[size]=100
@pagy, @records = pagy_offset(collection, jsonapi: true, page_sym: :number, limit_sym: :size)
```

## Paginate for Javascript Frameworks

If your app uses ruby as pure backend and some javascript frameworks as the frontend (e.g. Vue.js, react.js, ...), then you may
want to generate the whole pagination UI directly in javascript (with your own code or using some available javascript module).

Use [metadata extra](extras/metadata.md) and pass the pagination metadata in your JSON response.
[TODO REPLACE LINK]

## Paginate search framework results

Pagy has a few extras dedicated to gems returning search results:

- [elasticsearch_rails](api/backend/paginators/search/elasticsearch_rails.md)
- [searchkick](api/backend/paginators/search/searchkick.md)
- [meilisearch](api/backend/paginators/search/meilisearch.md)
  [TODO REPLACE LINKS]

## Paginate by date

Use the [calendar extra](extras/calendar.md) that adds pagination filtering by calendar time unit (year, quarter, month, week,
day).

## Paginate multiple independent collections

By default, pagy tries to derive parameters and options from the request and the collection, so you don't have to explicitly pass
it to the `pagy*` method. That is very handy, but assumes you are paginating a single collection per request.

When you need to paginate multiple collections in a single request, you need to explicitly differentiate the pagination objects.
You have the following common ways to do so:

==- Pass the request path

By default, pagy generates its links reusing the same `request_path` of the request, however if you want to generate links pointing
to a different controller/path, you should explicitly pass the targeted `:request_path`. For example:

+++ Good
!!!success Request Path Passed In:

```rb
# dashboard_controller
def index
  @pagy_foos, @foos = pagy_offset(Foo.all, request_path: '/foos')
  @pagy_bars, @bars = pagy_offset(Bar.all, request_path: '/bars')
end
```

```erb
<-- /dashboard.html.erb -->
<%== pagy_nav(@pagy_foos) %>
<%== pagy_nav(@pagy_bars) %>
<-- Pagination links of `/foos?page=2` instead of `/dashboard?page=2` -->
<-- Pagination links of `/bars?page=2` etc. -->
<-- Success -->
```

!!!
+++ Bad
!!!danger No Path Passed In

Path customization typically required when rendering multiple `@pagy` instances in the same view. e.g.:

```rb
# dashboard_controller
def index
  @pagy_foos, @foos = pagy_offset(Foo.all)
  @pagy_bars, @bars = pagy_offset(Bars.all)
end
```

```erb
<-- /dashboard.html.erb -->
<% turbo_frame "foos" do %>
<%== pagy_nav(@pagy_foos) %>
<% end%>
<% turbo_frame "bars" do %>
<%== pagy_nav(@pagy_bars) %>
<% end%>
<-- Pagination links will be `/dashboard?page=2` -->
<-- We don't want that! -->
```

!!!
+++

==- Use separate turbo frames actions

If you're using [hotwire](https://hotwired.dev/) ([turbo-rails](https://github.com/hotwired/turbo-rails) being the Rails
implementation), another way of maintaining independent contexts is using separate turbo frames actions. Just wrap each
independent context in a `turbo_frame_tag` and ensure a matching `turbo_frame_tag` is returned:

```html+erb
  <-- movies/index.html.erb -->
  
  <-- movies#bad_movies -->
  <%= turbo_frame_tag "bad_movies", src: bad_movies_path do %>    
      <%= render "movies_table", locals: {movies: @movies}%>
      <%== pagy_bootstrap_nav(@pagy) %>    
  <% end %>

  <-- movies#good_movies -->
  <%= turbo_frame_tag "good_movies", src: good_movies_path  do %>    
      <%= render "movies_table", locals: {movies: @movies}%>
      <%== pagy_bootstrap_nav(@pagy) %>    
  <% end %>   
```

```rb
  # controller action 
def good
  @pagy, @movies = pagy_offset(Movie.good, limit: 5)
end

def bad
  @pagy, @movies = pagy_offset(Movie.bad, limit: 5)
end 
```

Consider [Benito Serna's implementation of turbo-frames (on Rails) using search forms with the Ransack gem](https://bhserna.com/building-data-grid-with-search-rails-hotwire-ransack.html)
along with a corresponding [demo app](https://github.com/bhserna/dynamic_data_grid_hotwire_ransack) for a similar implementation
of the above logic.

==- Use different page symbols

You can also
paginate [multiple model in the same request](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy/)
by simply using different `:page_sym` for each instance:

```rb

def index # controller action
  @pagy_stars, @stars     = pagy_offset(Star.all, page_sym: :page_stars)
  @pagy_nebulae, @nebulae = pagy_offset(Nebula.all, page_sym: :page_nebulae)
end
```

===

## Wrap existing pagination with pagy_calendar

You can easily wrap your existing pagination with the `pagy_calendar` method. Here are a few examples adding `:year` and `:month`
to different existing statements.

```ruby controller
# pagy without calendar
@pagy, @record = pagy_offset(collection, any_vars: value, ...)
# wrapped with pagy_calendar
@calendar, @pagy, @records = pagy_calendar(collection,
                                           year:  {},
                                           month: {},
                                           pagy:  { any_vars: value, ... })

# any other backend constructors (e.g. pagy_searchkick)
@pagy, @record = pagy_searchkick(pagy_search_args, any_vars: value, ...)
# wrapped with pagy_calendar
@calendar, @pagy, @records = pagy_calendar(pagy_search_args,
                                           year:  {},
                                           month: {},
                                           pagy:  { backend:  :pagy_searchkick,
                                                    any_vars: value, ... })
```

Then follow the [calendar extra documentation](extras/calendar.md) for more details.

## Paginate only max_pages, regardless the count

In order to limit the pagination to a maximum number of pages, you can pass the `:max_pages` option.

For example:

```ruby
@pagy, @records = pagy_offset(collection, max_pages: 50, limit: 20)
@records.size #=> 20   
@pagy.count #=> 10_000
@pagy.last #=> 50

@pagy, @records = pagy_offset(collection, max_pages: 50, limit: 20, page: 51)
#=> Pagy::RangeError: expected :page in 1..50; got 51
```

If the `@pagy.count` in the example is `10_000`, the pages served without `:max_pages` would be `500`, but with
`:max_pages: 50` pagy would serve only the first `50` pages of your collection.

That works at the `Pagy`/`Pagy::Countless` level, so it works with any combination of collection/extra, including `limit`,
`gearbox` and search extras, however it makes no sense in `Pagy::Calendar` unit objects (which ignore it).

!!! Notice

The `limit` and `gearbox` extras serve a option number of records per page. If your goal is limiting the pagination to a max
number of records (instead of pages), you have to keep into account how you configure the `limit` range.

!!!

## Paginate pre-offset and pre-limited collections

With the other pagination gems you cannot paginate a subset of a collection that you got using `offset` and `limit`. With Pagy it
is as simple as just adding the `:outset` option, set to the initial offset. For example:

```ruby controller
subset                   = Product.offset(100).limit(315)
@pagy, @paginated_subset = pagy_offset(subset, outset: 100)
```

Assuming the `:limit` default of `20`, you will get the pages with the records you are expecting. The first page from record 101
to 120 of the main collection, and the last page from 401 to 415 of the main collection. Besides the `from` and `to` attribute
readers will correctly return the numbers relative to the subset that you are paginating, i.e. from 1 to 20 for the first page and
from 301 to 315 for the last page.

## Paginate non-ActiveRecord collections

The `pagy_get_count` method works out of the box with `ActiveRecord` collections; for other collections (e.g. `mongoid`, etc.)
you might want to change the `:count_args` default to suite your ORM count method:

```ruby pagy.rb (initializer)
Pagy::DEFAULT[:count_args] = []
```

or in extreme cases you may need to override it in your controller.

## Paginate collections with metadata

When your collection is already paginated and contains count and pagination metadata, you don't need any `pagy*` controller
method. For example this is a Tmdb API search result object, but you can apply the same principle to any other type of collection
metadata:

```rb
#<Tmdb::Result page=1, total_pages=23, total_results=446, results=[#<Tmdb::Movie ..>,#<Tmdb::Movie...>,...]...>
```

As you can see, it contains the pagination metadata that you can use to setup the pagination with pagy:

```ruby controller
# get the paginated collection
tobj = Tmdb::Search.movie("Harry Potter", page: params[:page])
# use its count and page to initialize the @pagy object
@pagy = Pagy.new(count: tobj.total_results, page: tobj.page)
# set the paginated collection records
@movies = tobj.results
```

## Paginate Any Collection

Pagy doesn't need to know anything about the kind of collection you paginate. It can paginate any collection, because every
collection knows its count and has a way to extract a chunk of items given a start/offset and a per-page/limit. It does not matter
if it is an `Array` or an `ActiveRecord` scope or something else: the simple mechanism is the same:

1. Create a Pagy object using the count of the collection to paginate
2. Get the page of items from the collection using the start/offset and the per-page/limit (`pagy.offset` and `pagy.limit`)

Here is an example with an array. (Please, notice that this is only a convenient example, but you should use
the [array](extras/array.md) extra to paginate arrays).

```ruby
# paginate an array
arr = (1..1000).to_a

# Create a Pagy object using the count of the collection to paginate
pagy = Pagy.new(count: arr.count, page: 2)
#=> #<Pagy:0x000055e39d8feef0 ... >

# Get the page using `pagy.offset` and `pagy.limit`
paginated = arr[pagy.offset, pagy.limit]
#=> [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40]
```

This is basically what the `pagy` method included in your controller does for you in one go:

```ruby controller
@pagy, @products = pagy_offset(Product.some_scope)
```

Then of course, regardless the kind of collection, you can render the navigation links in your view:

```erb view
<%== pagy_nav(@pagy) %>
```

See the [Pagy::Backend API documentation](api/methods/backend.md) for more details.

## Use the pagy_nav* helpers

These helpers take the Pagy object and return the HTML string with the pagination links, which are wrapped in a `nav` tag and are
ready to use in your view. For example:

```erb view
<%== pagy_nav(@pagy) %>
```

!!!primary Extras Provide Added Functionality

The [frontend extras](/categories/frontend) add a few other helpers that you can use the same way, in order to get added features

!!!

## Skip single page navs

Unlike other gems, Pagy does not decide for you that the nav of a single page of results must not be rendered. You may want it
rendered... or maybe you don't. If you don't... wrap it in a condition and use the `pagy_nav*` only if `@pagy.pages > 1` is true.
For example:

```erb
<%== pagy_nav(@pagy) if @pagy.pages > 1 %>
```

## Deal with a slow collection COUNT(*)

Every pagination gem needs the collection count in order to calculate _all_ the other options involved in the pagination. If you
use a storage system like any SQL DB, there is no way to paginate and provide a full nav system without executing an extra query
to get the collection count. That is usually not a problem if your DB is well organized and maintained, but that may not be always
the case.

Sometimes you may have to deal with not very efficient legacy apps/DBs that you cannot totally control. In that case the extra
count query may affect the performance of the app quite badly.

You have 2 possible solutions in order to improve the performance.

==- Cache the count

Depending on the nature of the app, a possible cheap solution would be caching the count of the collection, and Pagy makes that
really simple.

Pagy gets the collection count through its `pagy_get_count` method, so you can override it in your controller. Here is an example
using the rails cache:

```ruby controller
# override the pagy_get_count method adding
# the Rails.cache wrapper around the count call
def pagy_get_count(collection, _opts)
  cache_key = "pagy-#{collection.model.name}:#{collection.to_sql}"
  Rails.cache.fetch(cache_key, expires_in: 20 * 60) do
    collection.count(:all)
  end
end
```

```ruby model
# reset the cache when the model changes (you may omit the callbacks if your DB is static)
after_create { Rails.cache.delete_matched /^pagy-#{self.class.name}:/ }
after_destroy { Rails.cache.delete_matched /^pagy-#{self.class.name}:/ }
```

That may work very well with static (or almost static) DBs, where there is not much writing and mostly reading. Less so with more
DB writing, and probably not particularly useful with a DB in constant change.

==- Avoid the count

When the count caching is not an option, you may want to use the [countless extra](extras/countless.md), which totally avoids the
need for a count query, still providing an acceptable subset of the full pagination features.

==- Use Pagy Keyset

If the slowness of the DB is caused by paginating big tables toward the ends of the collection (i.e. when the `offset` is a big
number) then you should use the [keyset extra](extras/keyset.md). (See lso the [keyset API](api/keyset.md))

===

## Maximize Performance

Here are some tips that will help choosing the best way to use Pagy, depending on your requirements and environment.

==- Consider the nav_js

If you need the pagination bar with links and info, then you have a couple of choices, depending on your environment:

- Add the `oj` gem to your gemfile and use any `pagy*_nav_js` helper _(see [Javascript](api/frontend/support/javascript.md))_. That uses client
  side rendering and it is faster and lighter than using any `pagy*_nav` helper _(40x faster, 36x lighter and 1,410x more
  efficient than Kaminari)_. _Notice: the `oj` gem is not a requirement but helps the performance when it is available._

==- Consider the combo_nav_js

If you don't have strict requirements but still need to give the user total feedback and control on the page to display, then
consider the `pagy*_combo_nav_js` helpers. They are faster and lighter, and even more when the `oj` gem is available. That gives
you the best performance with nav info and UI _(48x faster, 48x lighter and 2,270x more efficient than Kaminari)_ also saving real
estate.

==- Consider the countless extra

If your requirements allow to use the `countless` extra (minimal or automatic UI) you can save one query per page, and drastically
boost the efficiency eliminating the nav info and almost all the UI. Take a look at the examples in
the [pagy extra](extras/pagy.md).

==- Consider the Arel extra and/or the fast_page gem

You can improve the performance for [grouped collections](#paginate-a-grouped-collection) with the [arel extra](extras/arel.md),
and queries on big data with [fast_page](https://github.com/planetscale/fast_page#pagy).

===

## Ignore Brakeman UnescapedOutputs false positives warnings

Pagy output html safe HTML, however, being an agnostic pagination gem it does not use the specific `html_safe` rails helper on its
output. That is noted by the [Brakeman](https://github.com/presidentbeef/brakeman) gem, that will raise a warning.

You can avoid the warning adding it to the `brakeman.ignore` file. More details [here](https://github.com/ddnexus/pagy/issues/243)
and [here](https://github.com/presidentbeef/brakeman/issues/1519).

## Raise Pagy::RangeError exceptions

With the OFFSET pagination technique, it may happen that the users/clients paginate over the end of the record set or records go deleted and a user went to a stale
page.

By default, Pagy doesn't raise any exceptions for requesting an out-of-range page. Instead, it does not retrieve any records and serves the UI navigators as usual, so the user can click to a different page.

Sometimes you may want to take a diffrent action, so you can set the `raise_range_error: true` option, and `rescue` it and do whatever fits your app better. For example:

```ruby controller
rescue_from Pagy::RangeError, with: :redirect_to_last_page

private

def redirect_to_last_page(exception)
  redirect_to url_for(page: exception.pagy.last), notice: "Page ##{params[:page]} is out-of-range. Showing page #{exception.pagy.last} instead."
end
```

!!!warning Rescue from `Pagy::RangeError` first

All Pagy exceptions are subclasses of `ArgumentError`, so if you need to `rescue_from ArgumentError, ...` along with
`rescue_from Pagy::RangeError, ...` then the `Pagy::RangeError` line should go BEFORE the `ArgumentError` line, or it will never
get rescued.

!!!

## Test with Pagy

* Pagy has 100% test coverage.
* You only need to test pagy if you have overridden methods.

If you need to test pagination, remember:

- `Pagy::DEFAULT` should be set by your initializer and be frozen. You can test that your code cannot change it.
- You can override defaults - i.e. any pagy option can be passed to a pagy constructor. For example:

```rb
@pagy, @books = pagy_offset(Book.all, limit: 10) # the default limit has been overridden
```

## Using your pagination templates

!!!warning Warning!
The pagy nav helpers are not only a lot faster than templates, but accept dynamic arguments and comply with ARIA and I18n
standards. Using your own templates is possible, but it's likely just reinventing a slower wheel.
!!!

If you really need to use your own templates, you absolutely can. Here is a static example that doesn't use any other helper nor
dictionary file for the sake of simplicity, however feel free to add your dynamic options and use any helper and dictionary
entries as you need:

:::code source="assets/nav.html.erb" :::

You can use it as usual: just remember to pass the `:pagy` local set to the `@pagy` object:

```erb
<%== render file: 'nav.html.erb', locals: {pagy: @pagy} %>
```

!!!
You may want to look at the actual output interactively by running:

```sh
pagy demo
# or: bundle exec pagy demo
```

...and point your browser at http://0.0.0.0:8000/template
!!!

You may want to read also the [Pagy::Frontend API documentation](api/frontend.md) for complete control over your templates.

## Use Pagy with a non-rack app

For non-rack environments that don't respond to the request method, pass the `:request` option to the paginator with your
request[:url_prefix] (i.e. everything that comes before the `?` in the complete url), and your request[:query_params] hash to be
merged with the pagy params and form the complete url

```ruby
@pagy, @records = pagy_offset(collection, request: { url_prefix:   'https://my.domain.com/path/script',
                                                     query_params: { a: 'a', b: 'b' } })
```

That would compose urls of the pages like: `https://my.domain.com/path/script?a=a&b=b&page=3`.

Pagy rely also on the `params` method inside the app, which should be a hash of the params from the request. Define an alias or a
method if your environment doesn't respond to it.
