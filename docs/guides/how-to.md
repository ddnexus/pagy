---
label: How To
order: 90
icon: tools
---

#

## How To

---

This page provides practical tips and examples to help you effectively use Pagy.

You can also [ask the Pagy AI](https://gurubase.io/g/pagy) for instant answers to questions not covered on this page.

==- Choose the right pagination technique

Check the [list of paginators](../toolbox/paginators/#paginators) or click the Pagy AI button below and ask something like: _"What are the available paginators for DBs and search platforms?"_

==- Control the items per page

- **Fixed**
  - Use the `:limit` option to set the number of items to serve with each page.
- **Requestable**
  - Use the `limit` option combined with the `:client_max_limit` option, allowing the client to request a variable `:limit` up to
    the specified `:client_max_limit`.
  - Additionally, you can use the [limit_tag_js](../toolbox/helpers/limit_tag_js) helper to provide a UI selector to the user.

```ruby
@pagy, @products = pagy(:offset, collection, limit: 10)
@pagy, @products = pagy(:offset, collection, limit: 10, client_max_limit: 1_000)
```

!!! warning ActiveRecord `limit`

The `:limit` option defined here will override any existing `limit` set in `ActiveRecord` collections.
!!!

See [Common Options](../toolbox/paginators#common-options).

==- Control the pagination bar

Pagy provides [series_nav](../toolbox/helpers/series_nav) and [series_nav_js](../toolbox/helpers/series_nav_js) helpers for
displaying a pagination bar.

You can customize the number and position of page links in the navigation bar using:

- The [:slots and :compact options](../toolbox/helpers/series_nav#options).
- Overriding the `series` method for full control over the pagination bar

==- Force the `:page`

Pagy retrieves the page from the `'page'` request query hash. To force a specific page number, pass it directly to the `pagy`
method. For example:

```ruby controller
@pagy, @records = pagy(:offset, collection, page: 3) # force page #3
```

==- Customize the dictionary

Pagy uses standard i18n dictionaries for string translations and supports overriding them.

See [I18n](../resources/i18n).

==- Customize the ARIA labels

You can customize the `aria-label` attributes of any `*nav*` helper by providing a `:aria_label` string.

See the [:aria_label](../toolbox/helpers#common-nav-options) option.

You can also replace the `pagy.aria_label.nav` strings in the dictionary, as well as the `pagy.aria_label.previous` and the
`pagy.aria_label.next`.

See [ARIA](../resources/ARIA).

==- Customize the page and limit URL keys

By default, Pagy retrieves the page from the request query hash and generates URLs using the `"page"` key, e.g., `?page=3`.

- Set `page_key: 'custom_page'` to customize URL generation, e.g., `?custom_page=3`.
- Set the `:limit_key` to customize the `limit` param the same way.

See [Common Options](../toolbox/paginators#common-options)

==- Paginate with JSON:API nested URLs

Enable `jsonapi: true`, optionally providing `:page_key` and `:limit_key`:

```ruby
# JSON:API nested query string: E.g.: ?page[number]=2&page[size]=100
@pagy, @records = pagy(:offset, collection, jsonapi: true, page_key: 'number', limit_key: 'size')
```

==- Customize the URL query

See the [:querify Option](../toolbox/paginators#common-options)

==- Add a URL fragment

Use the [:fragment](../toolbox/paginators#common-url-options) option.

==- Add HTML attributes to the anchor tags (links)

Use the [:anchor_string](../toolbox/helpers#common-options). It's especially useful for adding `data-turbo-*` or `data-*` Stimulus attributes.

==- Customize CSS styles

Pagy includes different formats of [stylesheets](../resources/stylesheets) for customization, as well as styled `nav` tags for
`:bootstrap` and `:bulma`.

You can also override the specific helper method.

==- Override CSS rules in element "style" attribute

The `input_nav_js` and `limit_tag_js` use inline style attributes. You can override these rules in your stylesheet files using the
`[style]`
attribute selector and `!important`. Below is an example of overriding the `width` of an `input` element:

```css
.pagy input[style] {
  width: 5rem !important; /* just an useless example */
}
```

==- Override pagy methods

- Identify the method file's path in the gem `lib` dir (e.g., 'pagy/...').
- Note the name of the module where it is defined (e.g., `Pagy::...`).

Copy and paste the original method in the [Pagy Initializer](../resources/initializer/)

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

- **Grouped collections**
  - For better performance of grouped counts, you may want to use the [:count_over](../toolbox/paginators/offset#options)
    option
- **Decorated collections**
  - Do it in two steps:
    1. Get the page of records without decoration
    2. Decorate the retrieved records.
  ```ruby controller
  @pagy, records     = pagy(:offset, Post.all)
  @decorated_records = records.decorate # or YourDecorator.method(records) whatever works
  ```
- **Custom scope/count**
  - If the default pagy doesn't get the right count:
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

- [:keyset paginator](../toolbox/paginators/keyset)
- [headers_hash helper](../toolbox/helpers/headers_hash)
- [:client_max_limit option](../toolbox/paginators#common-options)
- [:jsonapi option](../toolbox/paginators#common-options)

==- Paginate for Javascript Frameworks

You can send selected `@pagy` instance data to the client as JSON using the [data_hash](../toolbox/helpers/data_hash) helper,
including pagination metadata in your JSON response.

==- Paginate search platform results

See these paginators:

- [elasticsearch_rails](../toolbox/paginators/elasticsearch_rails)
- [searchkick](../toolbox/paginators/searchkick)
- [meilisearch](../toolbox/paginators/meilisearch)

==- Paginate by date

Use the [:calendar](../toolbox/paginators/calendar) paginator for pagination filtering by calendar time units (e.g., year,
quarter, month, week, day).

==- Paginate multiple independent collections

When you need to paginate multiple collections in a single request, you need to explicitly differentiate the pagination objects.
Here are some common methods to achieve this:

##### Override the request path

<br/>

By default, Pagy generates links using the same path as the request path. To generate links pointing to a different controller or
path, explicitly pass the desired `:path`. For example:

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

##### Use separate turbo frames actions

<br/>

If you're using [hotwire](https://hotwired.dev/) ([turbo-rails](https://github.com/hotwired/turbo-rails) being the Rails
implementation), another way of maintaining independent contexts is using separate turbo frames actions. Just wrap each
independent context in a `turbo_frame_tag` and ensure a matching `turbo_frame_tag` is returned:

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

##### Use different page symbols

<br/>

You can also paginate multiple model in the same request by simply using different `:page_key` for each instance:

```rb

def index # controller action
  @pagy_stars, @stars     = pagy(:offset, Star.all, page_key: 'page_stars')
  @pagy_nebulae, @nebulae = pagy(:offset, Nebula.all, page_key: 'page_nebulae')
end
```

==- Paginate only max_pages, regardless of the count

See [:max_pages](../toolbox/paginators#common-options) option.

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
@pagy = Pagy::Offset.new(count: tobj.total_results, page: tobj.page, request: Pagy::Request.new(request))
# set the paginated collection records
@movies = tobj.results
```

==- Skip single page navs

Unlike other gems, Pagy does not decide for you that the nav of a single page of results must not be rendered. You may want it
rendered... or maybe you don't. If you don't:

```erb
<%== @pagy.series_nav if @pagy.last > 1 %>
```

==- Deal with a slow collection COUNT(*)

Check out these paginators:

- [:countless](../toolbox/paginators/countless)
- [:keyset](../toolbox/paginators/keyset)
- [:keynav_js](../toolbox/paginators/keynav_js)

==- Maximize Performance

- Consider the paginators:
  - [:countless](../toolbox/paginators/countless)
  - [:keyset](../toolbox/paginators/keyset)
  - [:keynav_js](../toolbox/paginators/keynav_js)
- Consider the `series_nav_js` and `input_nav_js` helpers: they are a few orders of magnitute faster.
  - Add the `oj` gem to your gemfile

==- Ignore Brakeman UnescapedOutputs false positives warnings

Pagy outputs safe HTML, however being an agnostic pagination gem it does not use the specific `html_safe` rails helper for its
output. That is noted by the [Brakeman](https://github.com/presidentbeef/brakeman) gem, that will raise a warning.

Avoid the warning by adding it to the `brakeman.ignore` file. More details [here](https://github.com/ddnexus/pagy/issues/243)
and [here](https://github.com/presidentbeef/brakeman/issues/1519).

==- Raise Pagy::RangeError exceptions

With the OFFSET pagination technique, it may happen that the users/clients paginate after the end of the collection (when one or a
few records got deleted) and a user went to a stale page.

By default, Pagy doesn't raise any exceptions for requesting an out-of-range page. Instead, it does not retrieve any records and
serves the navs as usual, so the user can visit a different page.

Sometimes you may want to take a diffrent action, so you can set the option `raise_range_error: true`, `rescue` it and do whatever
fits your app better. For example:

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
```

...and point your browser to  http://127.0.0.1:8000/template
!!!

==- Use Pagy with non-rack apps

For non-rack environments that don't respond to the request method, you should pass
the [:request](../toolbox/paginators#common-options) option to the paginator.

==- Use `pagy` outside controllers or views

The `pagy` method needs to set a few options that depend on the availability of the `self.request` method in the class/module
where you included it.

For example, if you call the `pagy` method for a model (that included the `Pagy::Method`), it would almost certainly not have the
`request` method available.

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

You may need to POST a very complex search form and paginate the results. Pagy produces nav tags with GET links, so here is a
simple way of handling it.

You can start the process with your regular POST request and cache the filtering data on the server. Then, using the regular GET
pagination cycle, pass only the cache key as a param (which avoids sending the actual filters back and forth).

Here is a conceptual example using the `session`:

```ruby
require 'digest'

def filtered_action
  pagy_options = {}
  if params[:filter_key]  # retrieve already cached filters
    filters = session[params[:filter_key]]
  else  # store new filters
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

==- Create a new I18n Dictionary

#### 1. Find the pluralization rules for your language

- Locate the locale file you need in
  the [list of pluralizations](https://github.com/svenfuchs/rails-i18n/tree/master/rails/pluralization)
- Check the pluralization rules required in it. For example, the name of the file required is `one_other`
  for [`en.rb`](https://github.com/svenfuchs/rails-i18n/blob/master/rails/pluralization/en.rb). In Pagy, that translates to
  `'OneOther'`.
  - If you cannot find the pluralization in the link above, check
    the [Unicode pluralization rules](https://www.unicode.org/cldr/charts/45/supplemental/language_plural_rules.html).
- Confirm that pagy already defines the pluralization rules of your dictionary file by checking the file in
  the [P18n directory](https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/modules/i18n/p18n).
  - If the rules are not defined, you can either:
    - Add a new module for the pluralization (by adapting the same pluralization from the corresponding rails-i18n file) and
      include tests for it;
    - Or, create an issue requesting the addition of the pluralization entry and its tests.

#### 2. Duplicate an existing Pagy locale dictionary file and translate it into your language.

- See the [lib/locales](https://github.com/ddnexus/pagy/tree/master/gem/locales) for existing dictionaries.
- Check that the `p11n` entry points to a module in
  the [P18n directory](https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/modules/i18n/p18n).
- The mandatory pluralized entries in the dictionary file are `aria_label.nav` and `item_name`. Please provide all the necessary
  plurals for your language. For example, if your language uses the `EastSlavic` rule, you should provide the plurals for `one`,
  `few`, `many`, and `other`. If it uses
  `Other`, you should only provide a single value. Check other dictionary files for examples, and ask if you have any doubts.

Feel free to ask for help in your Pull Request.
 
==- Install Pagy pre-release version

For major versions in the make, we may push pre-release versions to rubygems. You can check their existence with: 

```bash
$ gem search pagy --pre
```

And install it with:

```ruby Gemfile (example)
gem 'pagy', '43.0.0.rc1' # Specific pre-release version
```

===
