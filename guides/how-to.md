#

## :icon-tools:&nbsp;&nbsp;How To

---

This page provides practical tips and examples to help you to use Pagy efficiently.

==- Choose the right pagination technique

Check the [Choose Right Guide](choose-right)

==- Control the items per page

Fixed
: Pass the `:limit` option to the paginator to set the number of items to serve with each page.

Requestable
: Pass the `:limit` option combined with the `:max_limit` option to the paginator, allowing the client to request a variable `:limit` up to the specified `:max_limit`.

Interactive
: Use the [limit_tag_js](/toolbox/helpers/limit_tag_js) helper to provide a UI selector to the user.

==- Control the pagination bar

Pagy provides [series_nav](/toolbox/helpers/series_nav) and [series_nav_js](/toolbox/helpers/series_nav_js) helpers for displaying a pagination bar.

You can customize the number and position of page links in the navigation bar using:

- The [:slots and :compact options](/toolbox/helpers/series_nav#options).
- Overriding the `series` method for full control over the pagination bar

==- Force the `:page`

Pagy retrieves the page from the `'page'` request params hash. To force a specific page number, pass it directly to the `pagy` method. For example:

```ruby controller
@pagy, @records = pagy(:offset, collection, page: 3) # force page #3
```

==- Customize the ARIA labels

You can customize the `aria-label` attributes of any `*nav*` helper by providing a `:aria_label` string.

Pass the `:aria_label` option to the helper.

You can also replace the `pagy.aria_label.nav` strings in the dictionary, as well as the `pagy.aria_label.previous` and the `pagy.aria_label.next`.

See [ARIA](/resources/ARIA).

==- Customize the page and limit URL keys

By default, Pagy retrieves the page from the request params hash and generates URLs using the `"page"` key, e.g., `?page=3`.

- Set `page_key: 'custom_page'` to customize URL generation, e.g., `?custom_page=3`.
- Set the `:limit_key` to customize the `limit` param the same way.

See [URL Options](/resources/urls#options)

==- Paginate with JSON:API nested URLs

Enable `jsonapi: true`, optionally providing `:page_key` and `:limit_key`:

```ruby
# JSON:API nested query string: E.g.: ?page[number]=2&page[size]=100
@pagy, @records = pagy(:offset, collection, jsonapi: true, page_key: 'number', limit_key: 'size')
```

==- Customize the URL query

See the [:querify Option](/resources/urls#options)

==- Add a URL fragment

See the [URL Options](/resources/urls#options)

==- Add HTML attributes to the anchor tags (links)

Pass the `:anchor_string` option to the helper. It's especially useful for adding `data-turbo-*` or `data-*` Stimulus attributes.

==- Customize CSS styles

Pagy includes different formats of [stylesheets](/resources/stylesheets) for customization, as well as styled `nav` tags for `:bootstrap` and `:bulma`.

You can also override the specific helper method.

:::
==- Override th element "style" attribute

The `input_nav_js` and `limit_tag_js` use inline style attributes. You can override these rules in your stylesheet files using the `[style]` attribute selector and `!important`. Below is an example of overriding the `width` of an `input` element:

```css
.pagy input[style] {
  width: 5rem !important; /* just an useless example */
}
```
:::

==- Override pagy methods

- Identify the method file's path in the gem `lib` dir (e.g., 'pagy/...').
- Note the name of the module where it is defined (e.g., `Pagy::...`).

Copy and paste the original method in the [Pagy Initializer](/toolbox/configuration/initializer)

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

If you need assistance, ask in the [Q&A discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a).

==- Paginate an Array

Simply pass it as the collection: `pagy(:offset, my_array, **options)`

==- Paginate ActiveRecord collections

Pagy works seamlessly with `ActiveRecord` collections, but certain collections may require specific handling:

:::

==- :icon-database:&nbsp; Grouped collections

For better performance of grouped counts, you may want to use the [:count_over](/toolbox/paginators/offset#options) option

==- :icon-database:&nbsp; Decorated collections

Do it in two steps:

>>> Get the page of records without decoration

```ruby controller
@pagy, records = pagy(:offset, Post.all)
```
>>> Decorate the retrieved records.

```ruby controller
@decorated_records = records.decorate # or YourDecorator.method(records) whatever works
```

>>>

==- :icon-database:&nbsp; Custom scope/count

If the default pagy doesn't get the right count:

```ruby controller
# pass the right count to pagy (that will directly use it skipping its own `collection.count(:all)`)
@pagy, @records = pagy(:offset, custom_scope, count: custom_count) # Example implementation
```

==- :icon-database:&nbsp; Ransack results

Ransack's `result` method returns an `ActiveRecord` collection that is ready for pagination:

```ruby controller
q = Person.ransack(params[:q])
@pagy, @people = pagy(:offset, q.result)
```

==- :icon-database:&nbsp; PostgreSQL Collections

[Always ensure your collections are ordered!](/toolbox/paginators#troubleshooting)

:::

==- Paginate for generic API clients

Explore the following options:

- [:keyset paginator](/toolbox/paginators/keyset)
- [headers_hash helper](/toolbox/helpers/headers_hash)
- `:max_limit` paginator option
- `:jsonapi option` paginator option

==- Paginate for JavaScript Frameworks

You can send selected `@pagy` instance data to the client as JSON using the [data_hash](/toolbox/helpers/data_hash) helper, including pagination metadata in your JSON response.

==- Paginate search platform results

See these paginators:

- [elasticsearch_rails](/toolbox/paginators/elasticsearch_rails)
- [meilisearch](/toolbox/paginators/meilisearch)
- [searchkick](/toolbox/paginators/searchkick)
- [typesense_rails](/toolbox/paginators/typesense_rails)

==- Paginate by date

Use the [:calendar](/toolbox/paginators/calendar) paginator for pagination filtering by calendar time units (e.g., year, quarter, month, week, day).

==- Paginate multiple independent collections

When you need to paginate multiple collections in a single request, you need to explicitly differentiate the pagination objects. Here are some common methods to achieve this:

:::
==- :icon-light-bulb:&nbsp; Override the request path

<br/>

By default, Pagy generates links using the same path as the request path. To generate links pointing to a different controller or path, explicitly pass the desired `:path`. For example:

```rb

def index
  @pagy_foos, @foos = pagy(:offset, Foo.all, path: '/foos')
  @pagy_bars, @bars = pagy(:offset, Bar.all, path: '/bars')
end
```

```erb
<%== @pagy_foos.series_nav %>
<%== @pagy_bars.series_nav %>
<!-- Pagination links of `/foos?page=2` instead of `/dashboard?page=2` -->
<!-- Pagination links of `/bars?page=2` etc. -->
```

==- :icon-light-bulb:&nbsp; Use separate turbo frames actions

<br/>

If you're using [hotwire](https://hotwired.dev/) ([turbo-rails](https://github.com/hotwired/turbo-rails) being the Rails implementation), another way of maintaining independent contexts is using separate turbo frames actions. Just wrap each independent context in a `turbo_frame_tag` and ensure a matching `turbo_frame_tag` is returned:

```erb
<-- movies/index.html.erb -->

<-- movies#bad_movies -->
<%= turbo_frame_tag "bad_movies", src: bad_movies_path do %>
<%= render "movies_table", locals: {movies: @movies}%>
<%== @pagy.series_nav %>
<% end %>

<-- movies#good_movies -->
<%= turbo_frame_tag "good_movies", src: good_movies_path  do %>
<%= render "movies_table", locals: {movies: @movies}%>
<%== @pagy.series_nav %>
<% end %>
```

```rb Controller Action
def good
  @pagy, @movies = pagy(:offset, Movie.good, limit: 5)
end

def bad
  @pagy, @movies = pagy(:offset, Movie.bad, limit: 5)
end
```

Consider [Benito Serna's implementation of turbo-frames (on Rails) using search forms with the Ransack gem](https://bhserna.com/building-data-grid-with-search-rails-hotwire-ransack.html) along with a corresponding [demo app](https://github.com/bhserna/dynamic_data_grid_hotwire_ransack) for a similar implementation of the above logic.

==- :icon-light-bulb:&nbsp; Use the root_key option

<br/>

By default, pagy creates flat URLs for its links. If you need to handle multiple pagy instance in the same request, you can nest the `:page` and -if you use it- the `:limit` params by passing the `:root_key` option to the paginator:

```rb Controller Action

def index
  @pagy_stars, @stars     = pagy(:offset, Star.all, root_key: 'stars')
  @pagy_nebulae, @nebulae = pagy(:offset, Nebula.all, root_key: 'nebulae')
end
```

==- :icon-light-bulb:&nbsp; Use different page keys

<br/>

You can also paginate multiple model in the same request by simply using different `:page_key` for each instance:

```rb

def index
  @pagy_stars, @stars     = pagy(:offset, Star.all, page_key: 'pagy_stars')
  @pagy_nebulae, @nebulae = pagy(:offset, Nebula.all, page_key: 'pagy_nebulae')
end
```

:::

==- Paginate only MAX records

You may want to limit the availability of your records either for speeding up the DB queries (especially useful with [OFFSET](/guides/choose-right/#offset) paginators with big tables), or simply to avoid exposing all your data to scrapers.

The best way to ensure it, is creating a limited collection using an ActiveRecord Virtual Table:

```rb
max_records     = 10_000
collection      = Product.where(...).limit(max_records)   # Add the max_records limit to your collection
limited         = collection.from(collection, :products)  # Create a limited collection using the :products Virtual Table
@pagy, @records = pagy(:offset, limited, **options)       # Paginate the limited collection
```
!!!success
- It works with all [OFFSET](/guides/choose-right/#offset) and [KEYSET](/guides/choose-right/#keyset) paginators.
- It produces faster COUNT and OFFSET queries, limiting the table scan
- It enforces strict control over the quantity of records you expose
!!!

==- Paginate collections with metadata

When your collection is already paginated and contains count and pagination metadata, you don't need any `pagy*` controller method.

For example this is a Tmdb API search result object, but you can apply the same principle to any other type of collection metadata:

```rb
#<Tmdb::Result page=1, total_pages=23, total_results=446, results=[#<Tmdb::Movie ..>,#<Tmdb::Movie...>,...]...>
```

As you can see, it contains the pagination metadata that you can use to set up the pagination with pagy:

```ruby controller
# get the paginated collection
tobj = Tmdb::Search.movie("Harry Potter", page: params[:page])
# use its count and page to initialize the @pagy object
@pagy = Pagy::Offset.new(count: tobj.total_results, page: tobj.page, request: Pagy::Request.new(request))
# set the paginated collection records
@movies = tobj.results
```

==- Skip single page navs

Unlike other gems, Pagy does not decide for you that the nav of a single page of results must not be rendered. You may want it rendered... or maybe you don't. If you don't:

```erb
<%== @pagy.series_nav if @pagy.last > 1 %>
```

==- Maximize Performance

- Consider the paginators:
  - [:countish](/toolbox/paginators/countish)
  - [:countless](/toolbox/paginators/countless)
  - [:keyset](/toolbox/paginators/keyset)
  - [:keynav_js](/toolbox/paginators/keynav_js)
- Consider the  helpers:
  - [series_nav_js](/toolbox/helpers/series_nav_js)
  - [series_nav_js](/toolbox/helpers/input_nav_js)
- When possible
  - [Paginate only MAX records](#paginate-only-max-records)

==- Ignore Brakeman false positives warnings

Pagy outputs safe HTML, however being an agnostic pagination gem it does not use the specific `html_safe` rails helper for its output. That is noted by the [Brakeman](https://github.com/presidentbeef/brakeman) gem, that will raise a `UnescapedOutputs` warning.

Avoid the warning by adding it to the `brakeman.ignore` file. More details [here](https://github.com/ddnexus/pagy/issues/243) and [here](https://github.com/presidentbeef/brakeman/issues/1519).

==- Handle Pagy Exceptions

:::

==- :icon-stop:&nbsp; `Pagy::OptionError`

It is a subclass of `ArgumentError` that offers information to rescue invalid options. For example: with `rescue Pagy::OptionError => e` you can get access to a few readers:

- `e.pagy` the pagy object
- `e.option` the offending option symbol (e.g. `:page`)
- `e.value` the value of the offending option (e.g. `-3`)

==- :icon-stop:&nbsp; `Pagy::RangeError`

With the [OFFSET](/guides/choose-right/#offset) pagination technique, it may happen that the users/clients paginate after the end of the collection (when one or a few records got deleted) and a user went to a stale page.

By default, Pagy doesn't raise any exceptions for requesting an out-of-range page. Instead, it does not retrieve any records and serves the navs as usual, so the user can visit a different page.

Sometimes you may want to take a different action, so you can set the option `raise_range_error: true`, `rescue` it and do whatever fits your app better. For example:

```ruby controller
rescue_from Pagy::RangeError, with: :redirect_to_last_page

private

def redirect_to_last_page(exception)
  redirect_to url_for(page: exception.pagy.last), notice: "Page ##{params[:page]} is out-of-range. Showing page #{exception.pagy.last} instead."
end
```
:::

==- Test with Pagy

* Pagy has 100% test coverage.
* You only need to test pagy if you have overridden methods.

==- Using your pagination templates

!!!warning Warning!
The pagy nav helpers are not only a lot faster than templates, but accept dynamic arguments and comply with ARIA and I18n standards.

Using your own templates is possible, but it's likely just reinventing a slower wheel.
!!!

If you really need to use your own templates, you absolutely can. Notice, that since you are not using any helper, you should require the following files that provide internal method to use in the template:

```rb
require "pagy/toolbox/helpers/support/series"
require "pagy/toolbox/helpers/support/a_lambda"
```

Here is a static example that doesn't use any other helper nor dictionary file for the sake of simplicity, however, feel free to add your dynamic options and use any helper and dictionary entries as you need:

:::code source="/assets/nav.html.erb" :::

You can use it as usual: just remember to pass the `:pagy` local set to the `@pagy` object:

```erb
<%== render file: 'nav.html.erb', locals: {pagy: @pagy} %>
```

!!!
You may want to look at the actual output interactively by running:

```sh
pagy demo
```

...and point your browser to  http://127.0.0.1:8000/template
!!!

==- Use Pagy with non-rack apps

For non-rack environments that don't respond to the request method, you should pass the `:request` option to the paginator.

==- Use `pagy` outside controllers or views

The `pagy` method needs to set a few options that depend on the availability of the `self.request` method in the class/module where you included it.

For example, if you call the `pagy` method for a model (that included the `Pagy::Method`), it would almost certainly not have the `request` method available.

The simplest way to make it work is as follows:

```ruby YourModel
include Pagy::Method

def self.paginated(view, my_arg1, my_arg2, **)
  collection = ...
  view.instance_eval { pagy(:offset, collection, **) }
end
```

```ERB view
<% pagy, records = YourModel.paginated(self, my_arg1, my_arg2, **options) %>
```

==- Handle POST requests (server side)

You may need to POST a very complex search form and paginate the results. Pagy produces nav tags with GET links, so here is a simple way of handling it.

You can start the process with your regular POST request and cache the filtering data on the server. Then, using the regular GET pagination cycle, pass only the cache key as a param (which avoids sending the actual filters back and forth).

Here is a conceptual example using the `session`:

```ruby
require 'digest'

def filtered_action
  pagy_options = {}
  if params[:filter_key] # retrieve already cached filters
    filters = session[params[:filter_key]]
  else # store new filters
    filters      = params[:filters] # your filter hash
    key          = Digest::SHA1.hexdigest(filters.sort.to_json)
    session[key] = filters

    pagy_options[:querify] = ->(query_hash) { query_hash.merge!(filter_key: key) }
  end
  collection      = Product.where(**filters)
  @pagy, @records = pagy(:offset, collection, **pagy_options)
end
```

!!!success Notice: ensure a server-side storage
If you use the `session` for caching, configure it to use `ActiveRecord`, `Redis`, or any server-side storage
!!!

===

!!!question

Feel free to ask for further help via [Pagy Support](https://github.com/ddnexus/pagy/discussions/categories/q-a).

!!!
