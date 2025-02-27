---
title: How To
order: 90
icon: tools
---

This page contains the practical tips and examples to get the job done with Pagy.

You can also [Ask any question to the Pagy trained AI](https://gurubase.io/g/pagy) for instant answers not covered in this page.

==- Choose the right pagination technique         

[AI-powered answer](https://gurubase.io/g/pagy/choose-between-pagy-offset-countless-keyset)

==- Control the items per page

- **Server side**
  - Use the `:limit` option.
- **Client Side**
  - Use the `limit` option, combined with the `:requestable_limit` option, that allows the client to request a `:limit` up-to the
    `:requestable_limit`
  - Additionally, you can use the [limit_selector_js_tag](../toolbox/instance/limit_selector_is_tag.md) helper to provide a UI
    selector to the user.

```ruby
@pagy, @products = pagy(:offset, collection, limit: 10)
@pagy, @products = pagy(:offset, collection, limit: 10, requestable_limit: 1_000)
```

!!! warning ActiveRecord `limit`

The defined `:limit` option overrides any `limit` already set in `ActiveRecord` collections
!!!

See [Common Options](../toolbox/paginator.md#common-options).

==- Control the pagination bar

Pagy offers the [nav_tag](../toolbox/instance/nav_tag.md) and [nav_js_tag](../toolbox/instance/nav_js_tag.md) helpers with a
pagination bar.

You can control the number and position of the page links in the navigation through:

- The [:slots and :compact options](../toolbox/instance/nav_tag.md#options).
- Overriding the `series` method for full control over the pagination bar

==- Force the `:page`

Pagy gets the page from the `params[:page]`. You can force a `page` number by just passing it to the `pagy` method. For example:

```ruby controller
@pagy, @records = pagy(:offset, collection, page: 3) # force page #3
```

==- Customize the dictionary

Pagy uses standard i18n dictionaries to translate its string and allow overriding.

See [I18n](../resources/i18n.md).

==- Customize the ARIA labels

Customize the `aria-label` attributes of any `*nav*` helper by passing the `:aria_label` string

See [:aria_label option](../toolbox/instance.md#common-nav-options)

You can also replace the `pagy.aria_label.nav` strings in the dictionary, as well as the `pagy.aria_label.previous` and the
`pagy.aria_label.next`.

See [ARIA](../resources/ARIA.md).

==- Customize the page and limit symbols

By default, pagy gets the page from the `params[:page]` and creates the URLs using the `:page` query_param `?page=3`.

Set the `page_sym: :your_symbol` to override the URL generation (i.e. `?your_symbol=3`)

Set the `limit_sym` to customize the `limit` param the same way.

See [Common Options](../toolbox/paginator#common-options)

==- Customize the params

Alter the params embedded in the URLs of the page links by setting the option `:params` to a `Hash` of params to merge, or a
`Proc` that can edit/add/delete the request params.

If it is a `Proc` it will receive the **key-stringified** `query_params` hash complete with the pagy-added params, and it should
modify it in place.

An example using `except!` (available in Rails) and `merge!`:

```ruby controller
@pagy, @records = pagy(:offset, collection, params: ->(params) { params.except!('not_useful').merge!('custom' => 'useful') })
```

==- Add a URL fragment

You can use the [:fragment](../toolbox/instance.rb#common-url-option) option:

==- Customize CSS styles

Pagy includes a few [stylesheets](../resources/stylesheet) that you can customize, and provides the syled version of all the `nav`
tags for `:bootstrap` and `:bulma`.

You can also override the specific helper method.

==- Override CSS rules in element "style" attribute

A couple of helpers (i.e. `combo_nav_js_tag`, `limit_selector_js_tag`) assign element style attributes to one or more tags. You
can override their rules in your own stylesheets by using the attribute `[style]`
selector and `!important`. Here is an example for overriding the `width` of the `input` element:

```css
.pagy input[style] {
  width: 5rem !important; /* just an useless example */
}
```

==- Override pagy methods

- Find the method to override
- Find its path in the repo (e.g. 'pagy/...')
- Find the name of the module where is defined (e.g. `Pagy::...`).

If you need help ask in the [Q&A discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a)

Copy and paste the original method in the [Pagy Initializer](../toolbox/initializer.md)

```ruby pagy.rb (initializer)
require 'pagy/...' # path to the overridden method file
module MyOverridingModule # wrap it with your arbitrarily named module
  def any_method # edit/define your method with the same name
    #...
    super
    #...
  end
end
# prepend your module to the overridden module 
Pagy::AnyModule.prepend MyOverridingModule
```

==- Paginate an Array

Just pass it as the collection, to the [:offset paginator](../toolbox/paginator/offset.md)

==- Paginate ActiveRecord collections

Pagy works out of the box with `ActiveRecord` collections, however here are a few specific collection that might be treated a bit
differently:

- **Grouped collections**
  - For better performance of grouped counts, you may want to use the [:count_over](../toolbox/paginator/offset.md#options) option
- **Decorated collections**
  - Do it in two steps:
    1. Get the page of records without decoration
    2. Apply the decoration to it.
  ```ruby controller
  @pagy, records     = pagy(:offset, Post.all)
  @decorated_records = records.decorate # or YourDecorator.method(records) whatever works
  ```
- **Custom scope/count**
  - The default pagy `collection.count(:all)` may not get the actual count:
  ```ruby controller
  # pass the right count to pagy (that will directly use it skipping its own `collection.count(:all)`)
  @pagy, @records = pagy(:offset, custom_scope, count: custom_count)
  ```
- **Ransack results**
  - Ransack `result` returns an `ActiveRecord` collection, which can be paginated out of the box:
  ```ruby controller
  q = Person.ransack(params[:q])
  @pagy, @people = pagy(:offset, q.result)
  ```
- **PostgreSQL Collections**
  - [Always order your collections!](../toolbox/paginator.md#troubleshooting)

==- Paginate for generic API clients

Check out:

- [:keyset paginator](../toolbox/paginator/keyset.md)
- [headers_hash helper](../toolbox/instance/headers_hash.md)
- [:requestable_limit option](../toolbox/paginator.md#common-options)
- [:jsonapi option](../toolbox/paginator.md#common-options)

==- Paginate with JSON:API

Pass the `jsonapi: true` to the paginator, optionally using `:page_sym` and `:limit_sym`:

```ruby
# JSON:API nested query_params: E.g.: ?page[number]=2&page[size]=100
@pagy, @records = pagy(:offset, collection, jsonapi: true, page_sym: :number, limit_sym: :size)
```

==- Paginate for Javascript Frameworks

You can JSON send to the client selected `@pagy` instance data with the [data_hash helper](../toolbox/instance/data_hash.md) and
pass the pagination metadata in your JSON response.

==- Paginate search framework results

See these pagnators:

- [elasticsearch_rails](../toolbox/paginator/elasticsearch_rails.md)
- [searchkick](../toolbox/paginator/searchkick.md)
- [meilisearch](../toolbox/paginator/meilisearch.md)

==- Paginate by date

Use the [:calendar paginator](../toolbox/paginator/calendar.md) that adds pagination filtering by calendar time unit (year,
quarter, month, week, day).

==- Paginate multiple independent collections

By default, pagy tries to derive parameters and options from the request and the collection, so you don't have to explicitly pass
it to the `pagy*` method. That is very handy, but assumes you are paginating a single collection per request.

When you need to paginate multiple collections in a single request, you need to explicitly differentiate the pagination objects.
You have the following common ways to do so:

#### Pass the request path

By default, pagy generates its links reusing the same `request_path` of the request, however if you want to generate links
pointing to a different controller/path, you should explicitly pass the targeted `:request_path`. For example:

+++ Good
!!!success Request Path Passed In:

```rb
# dashboard_controller
def index
  @pagy_foos, @foos = pagy(:offset, Foo.all, request_path: '/foos')
  @pagy_bars, @bars = pagy(:offset, Bar.all, request_path: '/bars')
end
```

```erb
<-- /dashboard.html.erb -->
<%== @pagy_foos.nav_tag %>
<%== @pagy_bars.nav_tag %>
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
  @pagy_foos, @foos = pagy(:offset, Foo.all)
  @pagy_bars, @bars = pagy(:offset, Bars.all)
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

#### Use separate turbo frames actions

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
  @pagy, @movies = pagy(:offset, Movie.good, limit: 5)
end

def bad
  @pagy, @movies = pagy(:offset, Movie.bad, limit: 5)
end 
```

Consider [Benito Serna's implementation of turbo-frames (on Rails) using search forms with the Ransack gem](https://bhserna.com/building-data-grid-with-search-rails-hotwire-ransack.html)
along with a corresponding [demo app](https://github.com/bhserna/dynamic_data_grid_hotwire_ransack) for a similar implementation
of the above logic.

#### Use different page symbols

You can also
paginate [multiple model in the same request](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy/)
by simply using different `:page_sym` for each instance:

```rb

def index # controller action
  @pagy_stars, @stars     = pagy(:offset, Star.all, page_sym: :page_stars)
  @pagy_nebulae, @nebulae = pagy(:offset, Nebula.all, page_sym: :page_nebulae)
end
```

==- Paginate only max_pages, regardless the count

In order to limit the pagination to a maximum number of pages, you can pass the `:max_pages` option.

For example:

```ruby
@pagy, @records = pagy(:offset, collection, max_pages: 50, limit: 20)
@records.size #=> 20   
@pagy.count #=> 10_000
@pagy.last #=> 50

@pagy, @records = pagy(:offset, collection, max_pages: 50, limit: 20, page: 51)
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

==- Paginate non-ActiveRecord collections

The `pagy_get_count` method works out of the box with `ActiveRecord` collections; for other collections (e.g. `mongoid`, etc.)
you might want to change the `:count_arguments` default to suite your ORM count method:

```ruby pagy.rb (initializer)
Pagy.options[:count_arguments] = []
```

==- Paginate collections with metadata

When your collection is already paginated and contains count and pagination metadata, you don't need any `pagy*` controller
method. For example this is a Tmdb API search result object, but you can apply the same principle to any other type of collection
metadata:

```rb
#<Tmdb::Result page=1, total_pages=23, total_results=446, results=[#<Tmdb::Movie ..>,#<Tmdb::Movie...>,...]...>
```

As you can see, it contains the pagination metadata that you can use to set up the pagination with pagy:

```ruby controller
# get the paginated collection
tobj = Tmdb::Search.movie("Harry Potter", page: params[:page])
# use its count and page to initialize the @pagy object
@pagy = Pagy::Offset.new(count: tobj.total_results, page: tobj.page, request: Pagy::Get.hash_from(request))
# set the paginated collection records
@movies = tobj.results
```

==- Skip single page navs

Unlike other gems, Pagy does not decide for you that the nav of a single page of results must not be rendered. You may want it
rendered... or maybe you don't. If you don't:

```erb
<%== @pagy.nav_tag if @pagy.pages > 1 %>
```

==- Deal with a slow collection COUNT(*)

Check out these paginators:

- [:countless](../toolbox/paginator/countless.md)
- [:keyset](../toolbox/paginator/keyset.md)
- [:keynav_js](../toolbox/paginator/keynav.md)

==- Maximize Performance

- Consider the paginators:
  - [:countless](../toolbox/paginator/countless.md)
  - [:keyset](../toolbox/paginator/keyset.md)
  - [:keynav_js](../toolbox/paginator/keynav.md)
- Consider the `*_js_nav_tag`s (a few orders of magnitute faster)
  - Add the `oj` gem to your gemfile

==- Ignore Brakeman UnescapedOutputs false positives warnings

Pagy output html safe HTML, however, being an agnostic pagination gem it does not use the specific `html_safe` rails helper on its
output. That is noted by the [Brakeman](https://github.com/presidentbeef/brakeman) gem, that will raise a warning.

You can avoid the warning adding it to the `brakeman.ignore` file. More details [here](https://github.com/ddnexus/pagy/issues/243)
and [here](https://github.com/presidentbeef/brakeman/issues/1519).

==- Raise Pagy::RangeError exceptions

With the OFFSET pagination technique, it may happen that the users/clients paginate over the end of the record set or records go
deleted and a user went to a stale page.

By default, Pagy doesn't raise any exceptions for requesting an out-of-range page. Instead, it does not retrieve any records and
serves the UI navigators as usual, so the user can click to a different page.

Sometimes you may want to take a diffrent action, so you can set the `raise_range_error: true` option, and `rescue` it and do
whatever fits your app better. For example:

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

==- Test with Pagy

* Pagy has 100% test coverage.
* You only need to test pagy if you have overridden methods.

==- Using your pagination templates

!!!warning Warning!
The pagy nav helpers are not only a lot faster than templates, but accept dynamic arguments and comply with ARIA and I18n
standards. Using your own templates is possible, but it's likely just reinventing a slower wheel.
!!!

If you really need to use your own templates, you absolutely can. Here is a static example that doesn't use any other helper nor
dictionary file for the sake of simplicity, however feel free to add your dynamic options and use any helper and dictionary
entries as you need:

:::code source="../assets/nav.html.erb" :::

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

You may want to read also the [Pagy::Frontend API documentation](../toolbox/frontend.md) for complete control over your templates.

==- Use Pagy with a non-rack app

For non-rack environments that don't respond to the request method, you should pass the `:request` option to the paginator, set
with a hash with the following keys:

- `:base_url`     (e.g. 'http://www.example.com')
- `:path`         (e.g. '/path')
- `:query_params` (e.g. a string-key hash of the request query_params)

Pagy rely also on the `params` method inside the app, which should be a hash of the params from the request. Define an alias or a
method if your environment doesn't respond to it.
 
===
