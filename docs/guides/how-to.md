---
title: How To
order: 90
icon: tools
---

This page provides practical tips and examples to help you effectively use Pagy.

You can also [ask the Pagy-trained AI](https://gurubase.io/g/pagy) for instant answers to questions not covered on this page.

==- Choose the right pagination technique         

[AI-powered answer](https://gurubase.io/g/pagy/choose-between-pagy-offset-countless-keyset)

==- Control the items per page

- **Server side**
  - Use the `:limit` option.
- **Client Side**
  - Use the `limit` option combined with the `:requestable_limit` option, which allows the client to request a `:limit` up to the
    specified `:requestable_limit`.
  - Additionally, you can use the [limit_selector_js_tag](../toolbox/methods/limit_selector_js_tag) helper to provide a UI
    selector to the user.

```ruby
@pagy, @products = pagy(:offset, collection, limit: 10)
@pagy, @products = pagy(:offset, collection, limit: 10, requestable_limit: 1_000)
```

!!! warning ActiveRecord `limit`

The `:limit` option defined here will override any existing `limit` set in `ActiveRecord` collections.
!!!

See [Common Options](../toolbox/paginators#common-options).

==- Control the pagination bar

Pagy provides [nav_tag](../toolbox/methods/nav_tag.md) and [nav_js_tag](../toolbox/methods/nav_js_tag.md) helpers for displaying a
pagination bar.

You can customize the number and position of page links in the navigation bar using:

- The [:slots and :compact options](../toolbox/methods/nav_tag.md#options).
- Overriding the `series` method for full control over the pagination bar

==- Force the `:page`

Pagy retrieves the page from the `params[:page]`. To force a specific page number, pass it directly to the `pagy` method. For example:

```ruby controller
@pagy, @records = pagy(:offset, collection, page: 3) # force page #3
```

==- Customize the dictionary

Pagy uses standard i18n dictionaries for string translations and supports overriding them.

See [I18n](../resources/i18n.md).

==- Customize the ARIA labels

You can customize the `aria-label` attributes of any `*nav*` helper by providing a `:aria_label` string.

See [:aria_label option](../toolbox/methods#common-nav-options)

You can also replace the `pagy.aria_label.nav` strings in the dictionary, as well as the `pagy.aria_label.previous` and the
`pagy.aria_label.next`.

See [ARIA](../resources/ARIA.md).

==- Customize the page and limit symbols

By default, Pagy retrieves the page from `params[:page]` and generates URLs using the `:page` query parameter, e.g., `?page=3`.

Set `page_sym: :your_symbol` to customize URL generation, e.g., `?your_symbol=3`.

Set the `limit_sym` to customize the `limit` param the same way.

See [Common Options](../toolbox/paginators#common-options)

==- Customize the params

Modify the parameters embedded in page link URLs by using the `:params` option, which can be a `Hash` of parameters to merge or a
`Proc` to edit, add, or delete request parameters.

If it is a `Proc` it will receive the **key-stringified** `query_params` hash complete with the pagy-added params, and it should
modify it in place.

Here is an example with `except!` (available in Rails) and `merge!`:

```ruby
@pagy, @records = pagy(:offset, collection, params: ->(params) { params.except!('not_useful').merge!('custom' => 'useful') })
```

==- Add a URL fragment

You can use the [:fragment](../toolbox/methods.md#common-url-options) option.

==- Customize CSS styles

Pagy includes a [stylesheet](../resources/stylesheet) (in different formats) for customization, as well as styled `nav` tags for `:bootstrap` and `:bulma`.

You can also override the specific helper method.

==- Override CSS rules in element "style" attribute

The `combo_nav_js_tag` and `limit_selector_js_tag` use inline style attributes. You can override these rules in your stylesheet files using the `[style]`
attribute selector and `!important`. Below is an example of overriding the `width` of an `input` element:

```css
.pagy input[style] {
  width: 5rem !important; /* just an useless example */
}
```

==- Override pagy methods

- Identify its path in the repository (e.g., 'pagy/...').
- Note the name of the module where it is defined (e.g., `Pagy::...`).

If you need assistance, visit the [Q&A discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a).

Copy and paste the original method in the [Pagy Initializer](../toolbox/initializer.md)

```ruby pagy.rb (initializer)
require 'pagy/...' # path to the overridden method file
module MyOverridingModule # wrap it with your arbitrarily named module
  def any_method # Edit or define your method with the identical name
    # Custom logic here...
    super
    # Custom logic here...
  end
end
# prepend your module to the overridden module 
Pagy::AnyModule.prepend MyOverridingModule
```

==- Paginate an Array

Simply pass it as the collection to the [:offset](../toolbox/paginators/offset.md) paginator.

==- Paginate ActiveRecord collections

Pagy works seamlessly with `ActiveRecord` collections, but certain collections may require specific handling:

- **Grouped collections**
  - For better performance of grouped counts, you may want to use the [:count_over](../toolbox/paginators/offset.md#options) option
- **Decorated collections**
  - Do it in two steps:
    1. Get the page of records without decoration
    2. Decorate the retrieved records.
  ```ruby controller
  @pagy, records     = pagy(:offset, Post.all)
  @decorated_records = records.decorate # or YourDecorator.method(records) whatever works
  ```
- **Custom scope/count**
  - The default pagy `collection.count(:all)` may not get the actual count:
  ```ruby controller
  # pass the right count to pagy (that will directly use it skipping its own `collection.count(:all)`)
  @pagy, @records = pagy(:offset, custom_scope, count: custom_count) # Example implementation
  ```
- **Ransack results**
  - Ransack's `result` method returns an `ActiveRecord` collection that is ready for pagination:
  ```ruby controller
  q = Person.ransack(params[:q])
  @pagy, @people = pagy(:offset, q.result)
  ```
- **PostgreSQL Collections**
  - [Always ensure your collections are ordered!](../toolbox/paginators#troubleshooting)

==- Paginate for generic API clients

Explore the following options:

- [:keyset paginator](../toolbox/paginators/keyset.md)
- [headers_hash helper](../toolbox/methods/headers_hash.md)
- [:requestable_limit option](../toolbox/paginators#common-options)
- [:jsonapi option](../toolbox/paginators#common-options)

==- Paginate with JSON:API

Enable `jsonapi: true`, optionally providing `:page_sym` and `:limit_sym`:

```ruby
# JSON:API nested query_params: E.g.: ?page[number]=2&page[size]=100
@pagy, @records = pagy(:offset, collection, jsonapi: true, page_sym: :number, limit_sym: :size)
```

==- Paginate for Javascript Frameworks

You can send selected `@pagy` instance data to the client as JSON using the [data_hash helper](../toolbox/methods/data_hash.md),
including pagination metadata in your JSON response.

==- Paginate search framework results

See these paginators:

- [elasticsearch_rails](../toolbox/paginators/elasticsearch_rails.md)
- [searchkick](../toolbox/paginators/searchkick.md)
- [meilisearch](../toolbox/paginators/meilisearch.md)

==- Paginate by date

Use the [:calendar](../toolbox/paginators/calendar.md) paginator for pagination filtering by calendar time units (e.g., year,
quarter, month, week, day).

==- Paginate multiple independent collections

When you need to paginate multiple collections in a single request, you need to explicitly differentiate the pagination objects.
Here are some common methods to achieve this:

#### Pass the request path
<br/>

By default, Pagy generates links using the same `request_path` as the request. To generate links pointing to a different controller or path, explicitly pass the desired `:request_path`. For example:

```rb
def index
  @pagy_foos, @foos = pagy(:offset, Foo.all, request_path: '/foos')
  @pagy_bars, @bars = pagy(:offset, Bar.all, request_path: '/bars')
end
```

```erb
<%== @pagy_foos.nav_tag %>
<%== @pagy_bars.nav_tag %>
<!-- Pagination links of `/foos?page=2` instead of `/dashboard?page=2` -->
<!-- Pagination links of `/bars?page=2` etc. -->
```

#### Use separate turbo frames actions

<br/>

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

<br/>

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

See [:max_pages](../toolbox/paginators.md#common-options) option.

==- Paginate non-ActiveRecord collections

For collections other than `ActiveRecord` (e.g. `mongoid`, etc.), you might want to change the `:count_arguments` default to suite your ORM count method:

```ruby pagy.rb (initializer)
Pagy.options[:count_arguments] = []
```

==- Paginate collections with metadata

When your collection is already paginated and contains count and pagination metadata, you don't need any `pagy*` controller
method. 

For example this is a Tmdb API search result object, but you can apply the same principle to any other type of collection
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

- [:countless](../toolbox/paginators/countless.md)
- [:keyset](../toolbox/paginators/keyset.md)
- [:keynav_js](../toolbox/paginators/keynav_js.md)

==- Maximize Performance

- Consider the paginators:
  - [:countless](../toolbox/paginators/countless.md)
  - [:keyset](../toolbox/paginators/keyset.md)
  - [:keynav_js](../toolbox/paginators/keynav_js.md)
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

Sometimes you may want to take a diffrent action, so you can set the `raise_range_error: true` option, `rescue` it and do
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

==- Use Pagy with a non-rack app

For non-rack environments that don't respond to the request method, you should pass the `:request` option to the paginator, set
with a hash with the following keys:

- `:base_url`     (e.g. 'http://www.example.com')
- `:path`         (e.g. '/path')
- `:query_params` (e.g. a string-key hash of the request query_params)

Pagy rely also on the `params` method inside the app, which should be a hash of the params from the request. Define an alias or a
method if your environment doesn't respond to it.
 
==- Use `pagy` outside of a controller or view

The `pagy` method is intended for environments that define both `params` and `request`, as it depends on them to set several options.

If you define a method (e.g., in a model) that uses `pagy`, the call will originate either from the controller or the view.

The simplest way to make it work is as follows:

```ruby YourModel
include Pagy::Method

def self.paginated(view, my_arg1, my_arg2, **)
  collection = my_method(my_arg1, my_arg2)
  view.instance_eval { pagy(:offset, collection, **) }
end
```

```ERB view
<% pagy, records = YourModel.paginated(self, my_arg1, my_arg2, **options) %>
```

===
