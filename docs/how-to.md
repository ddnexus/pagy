---
title: How To
order: 8
icon: tools-24
---

# How To

This page contains the practical tips and examples to get the job done with Pagy. If there is something missing, or some topic
that you think should be added, fixed or explained better, please open an issue.

## Control the items per page

You can control the items per page with the `items` variable. (Default `20`)

You can set its default in the `pagy.rb` initializer (see [How to configure pagy](/quick-start#configure)). For example:

```ruby pagy.rb (initializer)
Pagy::DEFAULT[:items] = 25
```

You can also pass it as an instance variable to the `Pagy.new` method or to the `pagy` controller method:

```ruby
@pagy, @records = pagy(Product.some_scope, items: 30)
```

!!! warning ActiveRecord `limit`
The defined `:items` variable overrides any `limit` already set in ActiveRecord collections:

```ruby
@pagy, @products = pagy(Product.limit(5)) #=> limit(5) gets overridden
```

!!!

See also a couple of extras that handle the `:items` in some special way:

- [gearbox](extras/gearbox.md): Automatically change the number of items per page depending on the page number
- [items](extras/items.md): Allow the client to request a custom number of items per page with an optional selector UI

## Control the page links

You can control the number and position of the page links in the navigation through the `:size` variable or override the
`series` method.

==- Fast nav

You can set the `:size` variable to an Integer representing the maximum page/gap slots rendered. The current
page will be placed as centered as possible in the series. For that reason, `:size` works better when it's an odd number.

For example:

```ruby
# size < 7
pagy = Pagy.new(count: 1000, page: 10, size: 5)
pagy.series
#=> [8, 9, "10", 11, 12]
pagy = Pagy.new(count: 1000, page: 2, size: 5)
pagy.series
#=> [1, "2", 3, 4, 5]
pagy = Pagy.new(count: 1000, page: 99, size: 5)
pagy.series
#=> [96, 97, 98, "99", 100] 

# size >= 7 (first, last and gap added)
pagy = Pagy.new(count: 1000, page: 10, size: 7)
pagy.series
#=> [1, :gap 9, "10", 11, :gap, 100]
pagy = Pagy.new(count: 1000, page: 2, size: 7)
pagy.series
#=> [1, "2", 3, 4, 5, :gap, 100]
pagy = Pagy.new(count: 1000, page: 99, size: 7)
pagy.series
#=> [1, :gap, 96, 97, 98, "99", 100] 

# size >= 7; ends: false (no ends added)
pagy = Pagy.new(count: 1000, page: 10, size: 7, ends: false)
pagy.series
#=> [7, 8, 9, "10", 11, 12, 13]
pagy = Pagy.new(count: 1000, page: 2, size: 7, ends: false)
pagy.series
#=> [1, "2", 3, 4, 5, 6, 7]
pagy = Pagy.new(count: 1000, page: 99, size: 7, ends: false)
pagy.series
#=> [94, 95, 96, 97, 98, "99", 100]
```

The fast nav uses a simpler and faster algorithm and the series length is more symmetrical and constant, it's cleaner and less confusing to the user. By default, if the size is at 
least `7`, it will insert the first and last pages as first and last links in the bar, also adding the `:gap`s accordingly.

If you want to remove the first, last and gaps slots and show only a series of contiguous pages around the current one you can 
set the `:ends` variable to `false`. This is especially useful with `Calendar` nav bars.

==- Legacy nav

See the [size extra](extras/size.md)

==- Skip the page links

If you want to skip the generation of the page links, just set the `:size` variable to `0`:

```ruby
pagy = Pagy.new count: 1000, size: 0 # etc
pagy.series
#=> []
```

==- Customize the series

If changing the `:size` is not enough for your requirements (e.g. if you need to add intermediate segments or midpoints in place
of gaps) you should override the `series` method. See more details and examples 
[here](https://github.com/ddnexus/pagy/issues/245).

===

## Pass the page number

You don't need to explicitly pass the page number to the `pagy` method, because it is pulled in by the `pagy_get_vars` (which is
called internally by the `pagy` method). However you can force a `page` number by just passing it to the `pagy` method. For
example:

```ruby controller
@pagy, @records = pagy(my_scope, page: 3) # force page #3
```

That will explicitly set the `:page` variable, overriding the default behavior (which pulls the page number from
the `params[:page]` by default).

## Customize the dictionary

Pagy composes its output strings using standard i18n dictionaries. That can be used to change the language and customize your
specific app.

<details>

<summary>Default en dictionary</summary>

:::code source="/gem/locales/en.yml" :::

</details>
<br>

If you are ok with the default supported locale dictionaries just refer to [Pagy::I18n](api/i18n.md).

If you want to customize the translations or some specific output, you should edit the relevant entries in the pagy dictionary.

If you explicitly use the [i18n extra](extras/i18n.md), override the pagy target entries in your own custom dictionary (refer to
the I18n official documentation).

If you don't use the above extra (and rely on the pagy faster code) you can copy and edit the dictionary files that your app uses
and configure pagy to use them.

```ruby pagy.rb (initializer)
# load the "en" and "de" locale defined in the custom files at :filepath:
Pagy::I18n.load({ locale: 'de', filepath: 'path/to/my-custom-de.yml' },
                { locale: 'en', filepath: 'path/to/my-custom-en.yml' })
```

## Customize the ARIA labels

You can customize the `aria-label` attributes of all the pagy helpers by passing the `:aria_label` string (
See [pagy_nav](api/frontend.md#pagy-nav-pagy-vars))

You can also replace the `pagy.aria_label.nav` strings in the dictionary, as well as the `pagy.aria_label.prev` and the
`pagy.aria_label.next`.

See more details in the [ARIA attributes Page](api/ARIA.md).

## Customize the page param

Pagy uses the `:page_param` variable to determine the param it should get the page number from and create the URL for. Its default
is set as `Pagy::DEFAULT[:page_param] = :page`, hence it will get the page number from the `params[:page]` and will create page
URLs like `./?page=3` by default.

You may want to customize that, for example to make it more readable in your language, or because you need to paginate different
collections in the same action. Depending on the scope of the customization, you have a couple of options:

1. `Pagy::DEFAULT[:page_param] = :custom_param` will be used as the global default
2. `pagy(collection, page_param: :custom_param)` or `Pagy.new(count:100, page_param: :custom_param)` will be used for a
   single instance (overriding the global default)

You can also override the [pagy_get_page](/docs/api/backend.md#pagy-get-page-vars) if you need some special way to get the page number.

## Customize the link attributes

If you need to customize some HTML attribute of the page links, you may not need to override the `pagy_nav*` helper. It might be
enough to pass some extra attribute string with the `:anchor_string` keyword argument. For example:

```erb
<%== pagy_nav(@pagy, anchor_string: 'data-remote="true"') %>
```

_See more advanced details about [The anchor_string argument](api/frontend.md#the-anchor_string-argument)_

## Customize the params

When you need to add some custom param or alter the params embedded in the URLs of the page links, you can set the
variable `:params` to a `Hash` of params to add to the URL, or a `Proc` that can edit/add/delete the request params.

If it is a `Proc` it will receive the **key-stringified** `params` hash complete with the `page` param and it should return a
possibly modified version of it.

An example using `except` and `merge!`:

```ruby controller
@pagy, @records = pagy(collection, params: ->(params) { params.except('not_useful').merge!('custom' => 'useful') })
```

You can also use the `:fragment` keyword argument to add a fragment to the URLs of the pages:

```erb view
<%== pagy_nav(@pagy, fragment: '#your-fragment') %>
```

!!!warning
For performance reasons the `:fragment` string must include the `"#"`!
!!!

## Customize the URL

When you need something more radical with the URL than just massaging the params, you should override the `pagy_url_for` right in
your helper.

!!!warning Override `pagy_trim` if using Trim Extra
If you are also using the [trim extra](extras/trim.md) you should also override
the [pagy_trim](extras/trim.md#pagy-trim-pagy-link)
method or the `Pagy.trim` javascript function.
!!!

The following are a couple of examples.

==- Enable fancy-routes

The following is a Rails-specific alternative that supports fancy-routes (e.g. `get 'your_route(/:page)' ...` that produce paths
like `your_route/23` instead of `your_route?page=23`):

```ruby controller

def pagy_url_for(pagy, page, absolute: false)
  params = request.query_parameters.merge(pagy.vars[:page_param] => page, only_path: !absolute)
  url_for(params)
end
```

!!!warning Performance affected!
The above overridden method is quite slower than the original because it passes through the rails helpers. However that gets
mitigated by the internal usage of `pagy_anchor` which calls the method only once even in the presence of many pages.
!!!

==- POST with page links

You may need to POST a very complex search form that would generate an URL potentially too long to be handled by a browser, and
your page links may need to use POST and not GET. In that case you can try this simple solution:

```ruby controller

def pagy_url_for(_pagy, page, **_)
  page
end
```

That would produce links that look like e.g. `<a href="2">2</a>`. Then you can attach a javascript "click" event on the page
links. When triggered, the `href` content (i.e. the page number) should get copied to a hidden `"page"` input and the form should
be posted.

For a broader tutorial about this topic
see [Handling Pagination When POSTing Complex Search Forms](https://benkoshy.github.io/2019/10/09/paginating-search-results-with-a-post-request.html)
by Ben Koshy.
===

## Customize the item name

The `pagy_info` and the `pagy_items_selector_js` helpers use the "item"/"items" generic name in their output. You can change that
by editing the values of the `"pagy.item_name"` i18n key in
the [dictionary files](https://github.com/ddnexus/pagy/blob/master/gem/locales) that your app is using.

Besides you can also pass the `:item_name` by passing an already pluralized string directly to the helper call:

```erb
<%== pagy_info(@pagy, item_name: t(`activerecord.model.product`, count: @pagy.count) %>
<%== pagy_items_selector_js(@pagy, item_name: t('activerecord.model.product', count: @pagy.vars[:items]) %>
```

## Customize CSS styles

For all its own interactive helpers the pagy gem includes a few [stylesheets](api/stylesheets.md) that you can customize.

Besides that, pagy provides a few frontend extras
for [bootstrap](extras/bootstrap.md), [bulma](extras/bulma.md) and [tailwind](api/stylesheets.md/#pagy-tailwind-scss)
 that come with a decent styling provided by their respective framework.

If you need to further customize the styles provided by the extras, you don't necessary need to override the helpers in most of
them: here are a few alternatives:

- Check whether the specific extra offers customization (e.g. [bulma](extras/bulma.md))
- Define the CSS styles to apply to the pagy CSS classes
- If sass/scss is available: extend the pagy CSS classes with some framework defined class, using the `@extend` sass/scss
  directive
- Use the jQuery `addClass` method
- Use a couple of lines of plain javascript

## Override CSS rules in element "style" attribute

In order to get a decent default look, a couple of helpers (i.e. `pagy*_combo_nav_js`, `pagy*_items_selector_js`) assign element
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
def pagy_get_count(collection, vars)
  collection.respond_to?(:count_documents) ? collection.count_documents : super
end
```

## Paginate an Array

See the [array](extras/array.md) extra.

## Paginate ActiveRecord collections

Pagy works out of the box with `ActiveRecord` collections, however here are a few specific cases that might be treated
differently:

==- Grouped collection

For better performance of grouped ActiveRecord collection counts, you may want to take a look at the [arel extra](extras/arel.md).

==- Decorated collection

Do it in 2 steps: first get the page of records without decoration, and then apply the decoration to it. For example:

```ruby controller
@pagy, records     = pagy(Post.all)
@decorated_records = records.decorate # or YourDecorator.method(records) whatever works
```

==- Custom scope/count

Your scope might become complex and the default pagy `collection.count(:all)` may not get the actual count. In that case you can
get the right count in a couple of ways:

```ruby controller
# Passing the right arguments to the internal `collection.count(...)` (See the ActiveRecord documentation for details)
@pagy, @records = pagy(custom_scope, count_args: [:join])

# or directly pass the right count to pagy (that will directly use it skipping its own `collection.count(:all)`)
@pagy, @records = pagy(custom_scope, count: custom_count)
```

==- Ransack results

Ransack `result` returns an `ActiveRecord` collection, which can be paginated out of the box. For example:

```ruby controller
q              = Person.ransack(params[:q])
@pagy, @people = pagy(q.result)
```

==- PostgreSQL Collections

[Always order your collections!](troubleshooting.md#records-may-randomly-repeat-in-different-pages-or-be-missing)

===

## Paginate for generic API clients

When your app is a service that doesn't need to serve any UI, but provides an API to some sort of client, you can serve the
pagination metadata as HTTP headers added to your response.

In that case you don't need the `Pagy::Frontend` nor any frontend extra. You should only require
the [headers extra](extras/headers.md) and use its helpers to add the headers to your responses.

## Paginate with JSON:API

See the [jsonapi extra](extras/jsonapi.md).

## Paginate for Javascript Frameworks

If your app uses ruby as pure backend and some javascript frameworks as the frontend (e.g. Vue.js, react.js, ...), then you may
want to generate the whole pagination UI directly in javascript (with your own code or using some available javascript module).

In that case you don't need the `Pagy::Frontend` nor any frontend extra. You should only require
the [metadata extra](extras/metadata.md) and pass the pagination metadata in your JSON response.

## Paginate search framework results

Pagy has a few extras dedicated to gems returning search results:

- [elasticsearch_rails](extras/elasticsearch_rails.md)
- [searchkick](extras/searchkick.md)
- [meilisearch](extras/meilisearch.md)

## Paginate by id instead of offset

With particular requirements/environment an id-based pagination might work better than a classical offset-based pagination, You
can use an interesting approach proposed [here](https://github.com/ddnexus/pagy/discussions/435#discussioncomment-4577136).

## Paginate by date instead of a fixed number of items

Use the [calendar extra](extras/calendar.md) that adds pagination filtering by calendar time unit (year, quarter, month, week,
day).

## Paginate multiple independent collections

By default pagy tries to derive parameters and variables from the request and the collection, so you don't have to explicitly pass
it to the `pagy*` method. That is very handy, but assumes you are paginating a single collection per request.

When you need to paginate multiple collections in a single request, you need to explicitly differentiate the pagination
objects. You have the following common ways to do so:

==- Pass the request path

By default pagy generates its links reusing the same `request_path` of the request, however if you want to generate links pointing
to a different controller/path, you should explicitly pass the targeted `:request_path`. For example:

+++ Good
!!!success Request Path Passed In:

```rb
# dashboard_controller
def index
  @pagy_foos, @foos = pagy(Foo.all, request_path: '/foos')
  @pagy_bars, @bars = pagy(Bar.all, request_path: '/bars')
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
  @pagy_foos, @foos = pagy(Foo.all)
  @pagy_bars, @bars = pagy(Bars.all)
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
  @pagy, @movies = pagy(Movie.good, items: 5)
end

def bad
  @pagy, @movies = pagy(Movie.bad, items: 5)
end 
```

Consider [Benito Serna's implementation of turbo-frames (on Rails) using search forms with the Ransack gem](https://bhserna.com/building-data-grid-with-search-rails-hotwire-ransack.html)
along with a corresponding [demo app](https://github.com/bhserna/dynamic_data_grid_hotwire_ransack) for a similar implementation
of the above logic.

==- Use different page_param(s)

You can also
paginate [multiple model in the same request](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy/)
by simply using multiple `:page_param`:

```rb

def index # controller action
  @pagy_stars, @stars     = pagy(Star.all, page_param: :page_stars)
  @pagy_nebulae, @nebulae = pagy(Nebula.all, page_param: :page_nebulae)
end
```
===

## Wrap existing pagination with pagy_calendar

You can easily wrap your existing pagination with the `pagy_calendar` method. Here are a few examples adding `:year` and `:month`
to different existing statements.

```ruby controller
# pagy without calendar
@pagy, @record = pagy(collection, any_vars: value, ...)
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

In order to limit the pagination to a maximum number of pages, you can pass the `:max_pages` variable.

For example:

```ruby
@pagy, @records = pagy(collection, max_pages: 50, items: 20)
@records.size #=> 20   
@pagy.count   #=> 10_000
@pagy.last    #=> 50

@pagy, @records = pagy(collection, max_pages: 50, items: 20, page: 51)
#=> Pagy::OverflowError: expected :page in 1..50; got 51
```

If the `@pagy.count` in the example is `10_000`, the pages served without `:max_pages` would be `500`, but with
`:max_pages: 50` pagy would serve only the first `50` pages of your collection.

That works at the `Pagy`/`Pagy::Countless` level, so it works with any combination of collection/extra, including `items`, 
`gearbox` and search extras, however it makes no sense in `Pagy::Calendar` unit objects (which ignore it). 

!!! Notice
The `items` and `gearbox` extras serve a variable number of items per page. If your goal is limiting the pagination to a max number of records (instead of pages), you have to keep into account how you configure the `items` range.
!!! 

## Paginate pre-offset and pre-limited collections

With the other pagination gems you cannot paginate a subset of a collection that you got using `offset` and `limit`. With Pagy it
is as simple as just adding the `:outset` variable, set to the initial offset. For example:

```ruby controller
subset                   = Product.offset(100).limit(315)
@pagy, @paginated_subset = pagy(subset, outset: 100)
```

Assuming the `:items` default of `20`, you will get the pages with the right records you are expecting. The first page from record
101 to 120 of the main collection, and the last page from 401 to 415 of the main collection. Besides the `from` and `to` attribute
readers will correctly return the numbers relative to the subset that you are paginating, i.e. from 1 to 20 for the first page and
from 301 to 315 for the last page.

## Paginate non-ActiveRecord collections

The `pagy_get_vars` method works out of the box with `ActiveRecord` collections; for other collections (e.g. `mongoid`, etc.)
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
2. Get the page of items from the collection using the start/offset and the per-page/limit (`pagy.offset` and `pagy.items`)

Here is an example with an array. (Please, notice that this is only a convenient example, but you should use
the [array](extras/array.md) extra to paginate arrays).

```ruby
# paginate an array
arr = (1..1000).to_a

# Create a Pagy object using the count of the collection to paginate
pagy = Pagy.new(count: arr.count, page: 2)
#=> #<Pagy:0x000055e39d8feef0 ... >

# Get the page of items using `pagy.offset` and `pagy.items`
paginated = arr[pagy.offset, pagy.items]
#=> [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40]
```

This is basically what the `pagy` method included in your controller does for you in one go:

```ruby controller
@pagy, @products = pagy(Product.some_scope)
```

Then of course, regardless the kind of collection, you can render the navigation links in your view:

```erb view
<%== pagy_nav(@pagy) %>
```

See the [Pagy::Backend API documentation](api/backend.md) for more details.

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

## Skip page=1 param

By default Pagy generates all the page links including the `page` param. If you want to remove the `page=1` param from the first
page link, just require the [trim extra](extras/trim.md).

## Deal with a slow collection COUNT(*)

Every pagination gem needs the collection count in order to calculate _all_ the other variables involved in the pagination. If you
use a storage system like any SQL DB, there is no way to paginate and provide a full nav system without executing an extra query
to get the collection count. That is usually not a problem if your DB is well organized and maintained, but that may not be always
the case.

Sometimes you may have to deal with not very efficient legacy apps/DBs that you cannot totally control. In that case the
extra count query may affect the performance of the app quite badly.

You have 2 possible solutions in order to improve the performance.

==- Cache the count

Depending on the nature of the app, a possible cheap solution would be caching the count of the collection, and Pagy makes that
really simple.

Pagy gets the collection count through its `pagy_get_count` method, so you can override it in your controller. Here is an example
using the rails cache:

```ruby controller
# override the pagy_get_count method adding
# the Rails.cache wrapper around the count call
def pagy_get_count(collection, _vars)
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

===

## Maximize Performance

Here are some tips that will help choosing the best way to use Pagy, depending on your requirements and environment.

==- Consider the nav_js

If you need the pagination bar with links and info, then you have a couple of choices, depending on your environment:

- Add the `oj` gem to your gemfile and use any `pagy*_nav_js` helper _(see [Javascript](api/javascript.md))_. That uses client
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

You can improve the performance for [grouped collections](#paginate-a-grouped-collection) with
the [arel extra](http://ddnexus.github.io/pagy/extras/arel), and queries on big data
with [fast_page](https://github.com/planetscale/fast_page#pagy).

===

## Ignore Brakeman UnescapedOutputs false positives warnings

Pagy output html safe HTML, however, being an agnostic pagination gem it does not use the specific `html_safe` rails helper on its
output. That is noted by the [Brakeman](https://github.com/presidentbeef/brakeman) gem, that will raise a warning.

You can avoid the warning adding it to the `brakeman.ignore` file. More details [here](https://github.com/ddnexus/pagy/issues/243)
and [here](https://github.com/presidentbeef/brakeman/issues/1519).

## Handle Pagy::OverflowError exceptions

Pass an overflowing `:page` number and Pagy will raise a `Pagy::OverflowError` exception.

This often happens because users/clients paginate over the end of the record set or records go deleted and a user went to a stale
page.

You can handle the exception by using the [overflow extra](extras/overflow.md) which provides a few easy and ready to use solutions for a few common cases, or you can rescue the exception manually and do whatever fits you better.

Here are a few options for manually handling the error in apps:

- Do nothing and let the page render a 500
- Rescue and render a 404
- Rescue and redirect to the last known page (Notice: the [overflow extra](extras/overflow.md) provides the same behavior without
  redirecting)

```ruby controller
rescue_from Pagy::OverflowError, with: :redirect_to_last_page

private

def redirect_to_last_page(exception)
  redirect_to url_for(page: exception.pagy.last), notice: "Page ##{params[:page]} is overflowing. Showing page #{exception.pagy.last} instead."
end
```

!!!warning Rescue from `Pagy::OverflowError` first
All Pagy exceptions are subclasses of `ArgumentError`, so if you need to `rescue_from ArgumentError, ...` along with 
`rescue_from Pagy::OverflowError, ...` then the `Pagy::OverflowError` line should go BEFORE the `ArgumentError` line or it 
will never get rescued.
!!!

## Test with Pagy

* Pagy has 100% test coverage.
* You only need to test pagy if you have overridden methods.

If you need to test pagination, remember:

- `Pagy::DEFAULT` should be set by your initializer and be frozen. You can test that your code cannot change it.
- You can override defaults - i.e. any pagy variable can be passed to a pagy constructor. For example:

```rb
@pagy, @books = pagy(Book.all, items: 10) # the items default has been overridden
```

## Using your pagination templates

!!!warning Warning!
The pagy nav helpers are not only a lot faster than templates, but accept dynamic arguments and comply with ARIA and I18n
standards. Using your own templates is possible, but it's likely just reinventing a slower wheel.
!!!

If you really need to use your own templates, you absolutely can. Here is a static example that doesn't use any other helper nor
dictionary file for the sake of simplicity, however feel free to add your dynamic variables and use any helper and dictionary
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
