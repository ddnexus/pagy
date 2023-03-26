---
title: How To
order: 1
icon: tools-24
---

# How To

This page contains the practical tips and examples to get the job done with Pagy. If there is something missing, or some topic that you think should be added, fixed or explained better, please open an issue.

## Control the items per page

You can control the items per page with the `items` variable. (Default `20`)

You can set its default in the `pagy.rb` initializer (see [How to configure pagy](/quick-start.md#configure)). For example:
 
||| pagy.rb (initializer)
```ruby
Pagy::DEFAULT[:items] = 25
```
|||

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

You can control the number and position of the page links in the navigation through the `:size` variable. It is an array of 4 integers that specify which and how many page links to show.

The default is `[1,4,4,1]`, which means that you will get `1` initial page, `4` pages before the current page, `4` pages after the current page, and `1` final page.

As usual you can set the `:size` variable as a global default by using the `Pagy::DEFAULT` hash or pass it directly to the `pagy` method.

The navigation links will contain the number of pages set in the variables:

`size[0]`...`size[1]` current page `size[2]`...`size[3]` - e.g.:

```ruby
pagy = Pagy.new count:1000, page: 10, size: [3,4,4,3] # etc
pagy.series
#=> [1, 2, 3, :gap, 6, 7, 8, 9, "10", 11, 12, 13, 14, :gap, 48, 49, 50]
```

As you can see by the result of the `series` method, you get 3 initial pages, 1 `:gap` (series interrupted), 4 pages before the current page, the current `:page` (which is a string), 4 pages after the current page, another `:gap` and 3 final pages.

You can easily try different options (also asymmetrical) in a console by changing the `:size`. Just check the `series` array to see what it contains when used in combination with different core variables.

### Skip the page links

If you want to skip the generation of the page links, just set the `:size` variable to an empty array:

```ruby
pagy = Pagy.new count:1000, size: [] # etc
pagy.series
#=> []
```

### Customize the series

If changing the `:size` is not enough for your requirements (e.g. if you need to add intermediate segments or midpoints in place of gaps) you should override the `series` method. See more details and examples [here](https://github.com/ddnexus/pagy/issues/245).

## Pass the page number

You don't need to explicitly pass the page number to the `pagy` method, because it is pulled in by the `pagy_get_vars` (which is called internally by the `pagy` method). However you can force a `page` number by just passing it to the `pagy` method. For example:

||| controller
```ruby
@pagy, @records = pagy(my_scope, page: 3) # force page #3
```
|||

That will explicitly set the `:page` variable, overriding the default behavior (which usually pulls the page number from the `params[:page]`).

## Customize the dictionary

Pagy composes its output strings using standard i18n dictionaries. That can be used to change the language and customize your specific app. 

<details>

<summary>Default en dictionary</summary>

```yaml
# English default 118n dictionary
en:
  pagy:

    item_name:
      one: "item"
      other: "items"

    nav:
      prev: "&lsaquo;&nbsp;Prev"
      next: "Next&nbsp;&rsaquo;"
      gap: "&hellip;"

    info:
      no_items: "No %{item_name} found"
      single_page: "Displaying <b>%{count}</b> %{item_name}"
      multiple_pages: "Displaying %{item_name} <b>%{from}-%{to}</b> of <b>%{count}</b> in total"

    combo_nav_js: "<label>Page %{page_input} of %{pages}</label>"

    items_selector_js: "<label>Show %{items_input} %{item_name} per page</label>"
``` 
</details>
<br>

If you are ok with the default supported locale dictionaries just refer to [Pagy::I18n](api/i18n.md).

If you want to customize the translations or some specific output, you should edit the relevant entries in the pagy dictionary.

If you explicitly use the [i18n extra](extras/i18n.md), override the pagy target entries in your own custom dictionary (refer to the I18n official documentation).

If you don't use the above extra (faster default) you can copy and edit the dictionary files that your app uses and configure pagy to use them.

||| pagy.rb (initializer)
```ruby
# load the "en" and "de" locale defined in the custom files at :filepath:
Pagy::I18n.load({ locale: 'de', filepath: 'path/to/my-custom-de.yml' }, 
                { locale: 'en', filepath: 'path/to/my-custom-en.yml' })
```
|||


### Example of custom dictionary

You may want to customize the output of a few entries, leaving the other entries in place:

||| path/to/my-custom-en.yml (dictionary)
```yaml
# English custom 118n dictionary
en:
  pagy:

    item_name:
      one: "item"
      other: "items"

    nav:
      prev: "&lsaquo;"         # customized
      next: "&rsaquo;"         # customized
      gap: "&hellip;"

    info:
      no_items: "0 of 0"                            # customized
      single_page: "%{count} of %{count}"           # customized
      multiple_pages: "%{from}-%{to} of %{count}"   # customized

    combo_nav_js: "<label>Page %{page_input} of %{pages}</label>"

    items_selector_js: "<label>Show %{items_input} %{item_name} per page</label>"
```
|||

## Customize the page param

Pagy uses the `:page_param` variable to determine the param it should get the page number from and create the URL for. Its default is set as `Pagy::DEFAULT[:page_param] = :page`, hence it will get the page number from the `params[:page]` and will create page URLs like `./?page=3` by default.

You may want to customize that, for example to make it more readable in your language, or because you need to paginate different collections in the same action. Depending on the scope of the customization, you have a couple of options:

1. `Pagy::DEFAULT[:page_param] = :custom_param` will be used as the global default
2. `pagy(scope, page_param: :custom_param)` or `Pagy.new(count:100, page_param: :custom_param)` will be used for a single instance (overriding the global default)

You can also override the `pagy_get_vars` if you need some special way to get the page number.

## Customize the link attributes

If you need to customize some HTML attribute of the page links, you may not need to override the `pagy_nav*` helper. It might be enough to pass some extra attribute string with the `:link_extra` variable. For example:

```ruby
# for all the Pagy instances
Pagy::DEFAULT[:link_extra] = 'data-remote="true" class="my-class"'

# for a single Pagy instance (if you use the Pagy::Backend#pagy method)
@pagy, @records = pagy(my_scope, link_extra: 'data-remote="true" class="my-class"')

# or directly to the constructor
pagy = Pagy.new(count: 1000, link_extra: 'data-remote="true" class="my-class"')

# or from a view: e.g.:
<%== pagy_bootstrap_nav(@pagy, link_extra: 'data-action="hello#world"') %> 
```

!!!primary `link_extra`: must be valid HTML
For performance reasons, the `:link_extra` variable must be a string formatted as a valid HTML attribute/value pairs. That string will get inserted verbatim in the HTML of the link. _(see more advanced details in the [pagy_link_proc documentation](api/frontend.md#pagy-link-proc-pagy-link-extra))_
!!!

## Customize the params

When you need to add some custom param or alter the params embedded in the URLs of the page links, you can set the variable `:params` to a `Hash` of params to add to the URL, or a `Proc` that can edit/add/delete the request params.

If it is a `Proc` it will receive the **key-stringified** `params` hash complete with the `page` param and it should return a possibly modified version of it.

An example using `except` and `merge!`:

||| controller
```ruby
@pagy, @records = pagy(collection, params: ->(params){ params.except('not_useful').merge!('custom' => 'useful') })
```
|||

You can also use the `:fragment` variable to add a fragment the URLs of the pages: 

||| controller
```ruby
@pagy, @records = pagy(collection, fragment: '#your-fragment')
```
|||

!!!primary 
For performance reasons the `:fragment` string must include the `"#"`.
!!!

## Customize the URL

When you need something more radical with the URL than just massaging the params, you should override the `pagy_url_for` right in your helper.

!!!warning Override `pagy_trim` if using Trim Extra
If you are also using the [trim extra](extras/trim.md) you should also override the [pagy_trim](extras/trim#pagy-trim-pagy-link) method or the `Pagy.trim` javascript function.
!!!

The following are a couple of examples.

### Enable fancy-routes

The following is a Rails-specific alternative that supports fancy-routes (e.g. `get 'your_route(/:page)' ...` that produce paths like `your_route/23` instead of `your_route?page=23`):

||| controller
```ruby
def pagy_url_for(pagy, page, absolute: false, html_escaped: false)  # it was (page, pagy) in previous versions
  params = request.query_parameters.merge(pagy.vars[:page_param] => page, only_path: !absolute )
  html_escaped ? url_for(params).gsub('&', '&amp;') : url_for(params)
end
```
|||

!!!warning Performance affected!
The above overridden method is quite slower than the original because it passes through the rails helpers. However that gets mitigated by the internal usage of `pagy_link_proc` which calls the method only once even in the presence of many pages.
!!!

#### POST with page links

You may need to POST a very complex search form that would generate an URL potentially too long to be handled by a browser, and your page links may need to use POST and not GET. In that case you can try this simple solution:

||| controller
```ruby
def pagy_url_for(_pagy, page, **_) # it was (page, pagy) in previous versions
  page
end
```
|||

That would produce links that look like e.g. `<a href="2">2</a>`. Then you can attach a javascript "click" event on the page links. When triggered, the `href` content (i.e. the page number) should get copied to a hidden `"page"` input and the form should be posted.

For a broader tutorial about this topic see [Handling Pagination When POSTing Complex Search Forms](https://benkoshy.github.io/2019/10/09/paginating-search-results-with-a-post-request.html) by Ben Koshy.

## Customize the item name

The `pagy_info` and the `pagy_items_selector_js` helpers use the "item"/"items" generic name in their output. You can change that by editing the values of the `"pagy.item_name"` i18n key in the [dictionary files](https://github.com/ddnexus/pagy/blob/master/lib/locales) that your app is using.

Besides you can also (dynamically) set the `:i18n_key` variable to let Pagy know where to lookup the item name in some dictionary file (instead of looking it up in the default `"pagy.item_name"` key).

You have a few ways to do that:

1. you can override the `pagy_get_vars` method in your controller, adding the dynamically set `:i18n_key`. For example with ActiveRecord (mostly useful with the [i18n extra](extras/i18n.md) or if you copy over the AR keys into the pagy dictionary):

||| controller
```ruby
def pagy_get_vars(collection, vars)
  { count: ...,
    page: ...,
    i18n_key: "activerecord.models.#{collection.model_name.i18n_key}" }.merge!(vars)
end
```
|||

2. you can set the `:i18n_key` variable, either globally using the `Pagy::DEFAULT` hash or per instance with the `Pagy.new` method or with the `pagy` controller method:

||| initializer (pagy.rb)
```ruby
# all the Pagy instances will have the default
Pagy::DEFAULT[:i18n_key] = 'activerecord.models.product'

# or single Pagy instance
@pagy, @record = pagy(my_scope, i18n_key: 'activerecord.models.product' )
```
|||

   or passing it as an optional keyword argument to the helper:

||| View
```erb
<%== pagy_info(@pagy, i18n_key: 'activerecord.models.product') %>
<%== pagy_items_selector_js(@pagy, i18n_key: 'activerecord.models.product') %>
```
|||

3. you can override entirely the `:item_name` by passing an already pluralized string directly to the helper call:

||| View
```erb
<%== pagy_info(@pagy, item_name: 'Product'.pluralize(@pagy.count)) %>
<%== pagy_items_selector_js(@pagy, item_name: 'Product'.pluralize(@pagy.count)) %>
```
|||

!!!warning Parameters have precedence
The variables passed to a Pagy object have the precedence over the variables returned by the `pagy_get_vars`. The fastest way to set the `i18n_key` is passing a literal string to the `pagy` method, the most convenient way is using `pagy_get_vars`, the most flexible way is passing a pluralized string to the helper.
!!!

## Customize CSS styles

Pagy provides a few frontend extras for [bootstrap](extras/bootstrap.md), [bulma](extras/bulma.md), [foundation](extras/foundation.md), [materialize](extras/materialize.md), [semantic](extras/semantic.md), [tailwind](https://tailwindcss.com) and [uikit](extras/uikit.md) that come with a decent styling provided by their framework.

If you need to further customize the provided styles, you don't necessary need to override the helpers/templates. Here are a few alternatives:

- define the CSS styles to apply to the pagy CSS classes
- if sass/scss is available: extend the pagy CSS classes with some framework defined class, using the `@extend` sass/scss directive
- use the jQuery `addClass` method
- use a couple of lines of plain javascript

## Override pagy methods

You include the pagy modules in your controllers and helpers, so if you want to override any of them, you can redefine them right in your code, where you included them.

You can read more details in the nice [How to Override pagy methods only in specific circumstances](https://benkoshy.github.io/2020/02/01/overriding-pagy-methods.html) mini-post by Ben Koshy.

Also, consider that you can use `prepend` if you need to do it globally:

```ruby
module MyOverridingModule
  def pagy_any_method
  ...
    super
    ...
  end
end
Pagy::Backend.prepend MyOverridingModule
# or
Pagy::Frontend.prepend MyOverridingModule
```

## Paginate an Array

Please, use the [array](extras/array.md) extra.

## Paginate ActiveRecord collections

Pagy works out of the box with `ActiveRecord` collections. See also the [arel extra](http://ddnexus.github.io/pagy/extras/arel) for better performance of grouped ActiveRecord collections.

### Paginate a decorated collection

Do it in 2 steps: first get the page of records without decoration, and then apply the decoration to it. For example:

||| controller
```ruby
@pagy, records = pagy(Post.all)
@decorated_records = records.decorate   # or YourDecorator.method(records) whatever works
```
|||

### Custom count for custom scopes

Your scope might become complex and the default pagy `collection.count(:all)` may not get the actual count. In that case you can get the right count with some custom statement, and pass it to `pagy`:

||| controller
```ruby
custom_scope = ...
custom_count = ...
@pagy, @records = pagy(custom_scope, count: custom_count)
```
|||

!!!primary Internal `count` skipped
Pagy will efficiently skip its internal count query and will just use the passed `:count` variable
!!!

### Paginate a grouped collection

For better performance of grouped ActiveRecord collection counts, you may want to take a look at the [arel extra](http://ddnexus.github.io/pagy/extras/arel).

## Paginate for API clients

When your app is a service that doesn't need to serve any UI, but provides an API to some sort of client, you can serve the pagination metadata as HTTP headers added to your response.

In that case you don't need the `Pagy::Frontend` nor any frontend extra. You should only require the [headers extra](extras/headers.md) and use its helpers to add the headers to your responses.

## Paginate for Javascript Frameworks

If your app uses ruby as pure backend and some javascript frameworks as the frontend (e.g. Vue.js, react.js, ...), then you may want to generate the whole pagination UI directly in javascript (with your own code or using some available javascript module).

In that case you don't need the `Pagy::Frontend` nor any frontend extra. You should only require the [metadata extra](extras/metadata.md) and pass the pagination metadata in your JSON response.

## Paginate Ransack results

Ransack `result` returns an `ActiveRecord` collection, which can be paginated out of the box. For example:

||| controller
```ruby
@q = Person.ransack(params[:q])
@pagy, @people = pagy(@q.result)
```
|||

## Paginate search framework results

Pagy has a few of extras for gems returning search results:

- [elasticsearch_rails](extras/elasticsearch_rails.md)
- [searchkick](extras/searchkick.md)
- [meilisearch](extras/meilisearch.md)

## Paginate by id instead of offset

With particular requirements/environment an id-based pagination might work better than a classical offset-based pagination,
You can use an interesting approach proposed [here](https://github.com/ddnexus/pagy/discussions/435#discussioncomment-4577136).


## Paginate by date instead of a fixed number of items

Use the [calendar extra](extras/calendar.md) that adds pagination filtering by calendar time unit (year, quarter, month, week, day).

## Paginate multiple independent collections

By default pagy tries to derive parameters and variables from the request and the collection, so you don't have to explicitly pass it to the `pagy*` method. That is very handy, but assumes you are paginating a single collection per request.

When you need to paginate multiple collections in a single request, you need to explicitly differentiate the pagination objects.

### Pass the request path

By default pagy generates its links reusing the same `request_path` of the request, however if you want to generate links pointing to a different controller/path, you should explicitly pass the targeted `:request_path`. For example:

+++ Good
!!!success Request Path Passed In:
```rb
# dashboard_controller
def index
  @pagy_foos, @foos = pagy(Foo.all,  request_path: '/foos')
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

### Separate turbo frames actions

If you're using [hotwire](https://hotwired.dev/) ([turbo-rails](https://github.com/hotwired/turbo-rails) being the Rails implementation), another way of maintaining independent contexts is using separate turbo frames actions. Just wrap each independent context in a `turbo_frame_tag` and ensure a matching `turbo_frame_tag` is returned:

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

Consider [Benito Serna's implementation of turbo-frames (on Rails) using search forms with the Ransack gem](https://bhserna.com/building-data-grid-with-search-rails-hotwire-ransack.html) along with a corresponding [demo app](https://github.com/bhserna/dynamic_data_grid_hotwire_ransack) for a similar implementation of the above logic.

### Using different page_param(s)

You can also paginate [multiple model in the same request](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy/) by simply using multiple `:page_param`:

```rb
def index # controller action
  @pagy_stars, @stars     = pagy(Star.all, page_param: :page_stars)
  @pagy_nebulae, @nebulae = pagy(Nebula.all, page_param: :page_nebulae)
end
```

## Wrap existing pagination with pagy_calendar

You can easily wrap your existing pagination with the `pagy_calendar` method. Here are a few examples adding `:year` and `:month` to different existing statements.

||| controller
```ruby
# pagy without calendar
@pagy, @record = pagy(collection, any_vars: value, ...)
# wrapped with pagy_calendar
@calendar, @pagy, @records = pagy_calendar(collection, year: {...},
                                           month: {...},
                                           pagy: { any_vars: value, ... } )

# any other backend constructors (e.g. pagy_searchkick)
@pagy, @record = pagy_searchkick(pagy_search_args, any_vars: value, ...)
# wrapped with pagy_calendar
@calendar, @pagy, @records = pagy_calendar(pagy_search_args, year: {...},
                                           month: {...},
                                           pagy: { backend: :pagy_searchkick,
                                                   any_vars: value, ...} )
```
|||

Then follow the [calendar extra documentation](extras/calendar.md) for more details.

## Paginate pre-offset and pre-limited collections

With the other pagination gems you cannot paginate a subset of a collection that you got using `offset` and `limit`. With Pagy it is as simple as just adding the `:outset` variable, set to the initial offset. For example:

||| controller
```ruby
subset = Product.offset(100).limit(315)
@pagy, @paginated_subset = pagy(subset, outset: 100)
```
|||

Assuming the `:items` default of `20`, you will get the pages with the right records you are expecting. The first page from record 101 to 120 of the main collection, and the last page from 401 to 415 of the main collection. Besides the `from` and `to` attribute readers will correctly return the numbers relative to the subset that you are paginating, i.e. from 1 to 20 for the first page and from 301 to 315 for the last page.

## Paginate non-ActiveRecord collections

The `pagy_get_vars` method works out of the box with `ActiveRecord` collections; for other collections (e.g. `mongoid`, etc.) you may need to override it in your controller, usually by simply removing the `:all` argument passed to the `count` method:

||| override
```ruby
def pagy_get_vars  # copy from lib/pagy/backend
  # replace collection.count(:all) with collection.count 
end
```
|||

## Paginate collections with metadata

When your collection is already paginated and contains count and pagination metadata, you don't need any `pagy*` controller method. For example this is a Tmdb API search result object, but you can apply the same principle to any other type of collection metadata:

```rb
#<Tmdb::Result page=1, total_pages=23, total_results=446, results=[#<Tmdb::Movie ..>,#<Tmdb::Movie...>,...]...>
```

As you can see it contains the pagination metadata that you can use to setup the pagination with pagy:

||| controller
```ruby
# get the paginated collection
tobj = Tmdb::Search.movie("Harry Potter", page: params[:page])
# use its count and page to initialize the @pagy object
@pagy = Pagy.new(count: tobj.total_results, page: tobj.page)
# set the paginated collection records
@movies = tobj.results
```
|||

## Paginate Any Collection

Pagy doesn't need to know anything about the kind of collection you paginate. It can paginate any collection, because every collection knows its count and has a way to extract a chunk of items given a start/offset and a per-page/limit. It does not matter if it is an `Array` or an `ActiveRecord` scope or something else: the simple mechanism is the same:

1. Create a Pagy object using the count of the collection to paginate
2. Get the page of items from the collection using the start/offset and the per-page/limit (`pagy.offset` and `pagy.items`)

Here is an example with an array. (Please, notice that this is only a convenient example, but you should use the [array](extras/array.md) extra to paginate arrays).

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

||| controller
```ruby
@pagy, @products = pagy(Product.some_scope)
```
|||

Then of course, regardless the kind of collection, you can render the navigation links in your view:

||| view
```erb
<%== pagy_nav(@pagy) %>
```
|||

See the [Pagy::Backend source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb) and the [Pagy::Backend API documentation](api/backend.md) for more details.

## Use the pagy_nav* helpers

These helpers take the Pagy object and return the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

||| view
```erb
<%== pagy_nav(@pagy) %>
```
|||

!!!primary Extras Provide Added Functionality
the [extras](/categories/extra) add a few other helpers that you can use the same way, in order to get added features (e.g. bootstrap compatibility, responsiveness, compact layouts, etc.)
!!!

| Extra                                | Helpers                                                                            |
|:-------------------------------------|:-----------------------------------------------------------------------------------|
| [bootstrap](extras/bootstrap.md)     | `pagy_bootstrap_nav`, `pagy_bootstrap_nav_js`, `pagy_bootstrap_combo_nav_js`       |
| [bulma](extras/bulma.md)             | `pagy_bulma_nav`, `pagy_bulma_nav_js`, `pagy_bulma_combo_nav_js`                   |
| [foundation](extras/foundation.md)   | `pagy_foundation_nav`, `pagy_foundation_nav_js`, `pagy_foundation_combo_nav_js`    |
| [materialize](extras/materialize.md) | `pagy_materialize_nav`, `pagy_materialize_nav_js`, `pagy_materialize_combo_nav_js` |
| [navs](extras/navs.md)               | `pagy_nav_js`, `pagy_combo_nav_js`                                                 |
| [semantic](extras/semantic.md)       | `pagy_semantic_nav`, `pagy_semantic_nav_js`, `pagy_semantic_combo_nav_js`          |
| [uikit](extras/uikit.md)             | `pagy_uikit_nav`, `pagy_uikit_nav_js`, `pagy_uikit_combo_nav_js`                   |

Helpers are the preferred choice (over templates) for their performance. If you need to override a `pagy_nav*` helper you can copy and paste it in your helper and edit it there. It is a simple concatenation of strings with a very simple logic.

Depending on the level of your overriding, you may want to read the [Pagy::Frontend API documentation](api/frontend.md) for complete control over your helpers.

## Skip single page navs

Unlike other gems, Pagy does not decide for you that the nav of a single page of results must not be rendered. You may want it rendered... or maybe you don't. If you don't... wrap it in a condition and use the `pagy_nav*` only if `@pagy.pages > 1` is true. For example:

```erb
<%== pagy_nav(@pagy) if @pagy.pages > 1 %>
```

## Skip page=1 param

By default Pagy generates all the page links including the `page` param. If you want to remove the `page=1` param from the first page link, just require the [trim extra](extras/trim.md).

## Use Templates

The `pagy_nav*` helpers are optimized for speed, and they are really fast. On the other hand editing a template might be easier when you have to customize the rendering, however every template system adds some inevitable overhead and it will be about 30-70% slower than using the related helper. That will still be dozens of times faster than the other gems, but... you should choose wisely.

Pagy provides the replacement templates for the `pagy_nav`, `pagy_bootstrap_nav`, `pagy_bulma_nav`, `pagy_foundation_nav`, and the `pagy_uikit_nav` helpers (available with the relative extras) in 3 flavors: `erb`, `haml` and `slim`.

They produce exactly the same output of the helpers, but since they are slower, using them wouldn't make any sense unless you need to change something. In that case customize a copy in your app, then use it as any other template: just remember to pass the `:pagy` local set to the `@pagy` object. Here are the links to the sources to copy:

- `pagy`
  - [nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav.html.erb)
  - [nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav.html.haml)
  - [nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav.html.slim)
- `bootstrap`
  - [bootstrap_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.erb)
  - [bootstrap_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.haml)
  - [bootstrap_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.slim)
- `bulma`
  - [bulma_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.erb)
  - [bulma_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.haml)
  - [bulma_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.slim)
- `foundation`
  - [foundation_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.erb)
  - [foundation_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.haml)
  - [foundation_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/foundation_nav.html.slim)
- `uikit`
  - [uikit_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit_nav.html.erb)
  - [uikit_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit_nav.html.haml)
  - [uikit_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/uikit_nav.html.slim)

If you need to try/compare an unmodified built-in template, you can render it right from the Pagy gem with:

```erb
<%== render file: Pagy.root.join('templates', 'nav.html.erb'), 
            locals: {pagy: @pagy} %>

<%== render file: Pagy.root.join('templates', 'bootstrap_nav.html.erb'), 
            locals: {pagy: @pagy} %>
```

You may want to read also the [Pagy::Frontend API documentation](api/frontend.md) for complete control over your templates.

## Deal with a slow collection COUNT(*)

Every pagination gem needs the collection count in order to calculate _all_ the other variables involved in the pagination. If you use a storage system like any SQL DB, there is no way to paginate and provide a full nav system without executing an extra query to get the collection count. That is usually not a problem if your DB is well organized and maintained, but that may not be always the case.

Sometimes you may have to deal with some not very efficient legacy apps/DBs that you cannot totally control. In that case the extra count query may affect the performance of the app quite badly.

You have 2 possible solutions in order to improve the performance.

### Cache the count

Depending on the nature of the app, a possible cheap solution would be caching the count of the collection, and Pagy makes that really simple.

Pagy gets the collection count through its `pagy_get_vars` method, so you can override it in your controller. Here is an example using the rails cache:

||| controller
```ruby
# override the pagy_get_vars method so it will call your cache_count method
def pagy_get_vars(collection, vars)
  vars[:count] ||= cache_count(collection)
  vars[:page]  ||= params[ vars[:page_param] || Pagy::DEFAULT[:page_param] ]
  vars
end

# add Rails.cache wrapper around the count call
def cache_count(collection)
  cache_key = "pagy-#{collection.model.name}:#{collection.to_sql}"
  Rails.cache.fetch(cache_key, expires_in: 20 * 60) do
    collection.count(:all)
  end
end
```
|||

||| model
```ruby
# reset the cache when the model changes (you may omit the callbacks if your DB is static)
after_create  { Rails.cache.delete_matched /^pagy-#{self.class.name}:/}
after_destroy { Rails.cache.delete_matched /^pagy-#{self.class.name}:/}
```
|||

That may work very well with static (or almost static) DBs, where there is not much writing and mostly reading. Less so with more DB writing, and probably not particularly useful with a DB in constant change.

### Avoid the count

When the count caching is not an option, you may want to use the [countless extra](extras/countless.md), which totally avoid the need for a count query, still providing an acceptable subset of the full pagination features.

## Use AJAX

You can trigger ajax render in rails by [customizing the link attributes](#customize-the-link-attributes).

See also [Using AJAX](api/javascript/ajax.md#using-ajax).

## Maximize Performance

Here are some tips that will help choosing the best way to use Pagy, depending on your requirements and environment.

### Consider the nav_js

If you need the classic pagination bar with links and info, then you have a couple of choices, depending on your environment:

- Add the `oj` gem to your gemfile and use any `pagy*_nav_js` helper _(see [Javascript](api/javascript.md))_. That uses client side rendering and it is faster and lighter than using any `pagy*_nav` helper _(40x faster, 36x lighter and 1,410x more efficient than Kaminari)_. _Notice: the `oj` gem is not a requirement but helps the performance when it is available._

### Consider the combo navs

If you don't have strict requirements but still need to give the user total feedback and control on the page to display, then consider the `pagy*_combo_nav_js` helpers. They are faster and lighter, and even more when the `oj` gem is available. That gives you the best performance with nav info and UI _(48x faster, 48x lighter and 2,270x more efficient than Kaminari)_ also saving real estate.

### Consider the countless extra

If your requirements allow to use the `countless` extra (minimal or automatic UI) you can save one query per page, and drastically boost the efficiency eliminating the nav info and almost all the UI. Take a look at the examples in the [support extra](extras/support.md).

### Consider the Arel extra and/or the fast_page gem

You can improve the performance for [grouped collections](#paginate-a-grouped-collection) with the [arel extra](http://ddnexus.github.io/pagy/extras/arel), and queries on big data with [fast_page](https://github.com/planetscale/fast_page#pagy).

## Ignore Brakeman UnescapedOutputs false positives warnings

Pagy output html safe HTML, however, being an agnostic pagination gem it does not use the specific `html_safe` rails helper on its output. That is noted by the [Brakeman](https://github.com/presidentbeef/brakeman) gem, that will raise a warning.

You can avoid the warning adding it to the `brakeman.ignore` file. More details [here](https://github.com/ddnexus/pagy/issues/243) and [here](https://github.com/presidentbeef/brakeman/issues/1519).

## Handle Pagy::OverflowError exceptions

Pass an overflowing `:page` number and Pagy will raise a `Pagy::OverflowError` exception.

This often happens because users/clients paginate over the end of the record set or records go deleted and a user went to a stale page.

You can handle the exception by using the [overflow extra](extras/overflow.md) which provides easy and ready to use solutions for a few common cases, or you can rescue the exception manually and do whatever fits better.

Here are a few options for manually handling the error in apps:

- Do nothing and let the page render a 500
- Rescue and render a 404
- Rescue and redirect to the last known page (Notice: the [overflow extra](extras/overflow.md) provides the same behavior without redirecting)

||| controller
```ruby
rescue_from Pagy::OverflowError, with: :redirect_to_last_page

private

def redirect_to_last_page(exception)
 redirect_to url_for(page: exception.pagy.last), notice: "Page ##{params[:page]} is overflowing. Showing page #{exception.pagy.last} instead."
end
```
|||

!!!warning Rescue from `Pagy::OverflowError` first
All Pagy exceptions are subclasses of `ArgumentError`, so if you need to `rescue_from ArgumentError, ...` along with `rescue_from Pagy::OverflowError, ...` then the `Pagy::OverflowError` line should go BEFORE the `ArgumentError` line or it will never get rescued.
!!!
