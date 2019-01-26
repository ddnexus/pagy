---
title: How To
---
# How To

This page contains the practical tips and examples to get the job done with Pagy. If there is something missing, or some topic that you think should be added, fixed or explained better, please open an issue.

## Quick Start

Install and require the Pagy gem:

```bash
gem install pagy
```

```ruby
require 'pagy'
```

or if you use the Bundler, add the gem in the Gemfile:

```ruby
gem 'pagy'
```

Include the backend in some controller:

```ruby
include Pagy::Backend
```

Use the `pagy` method in some action:

```ruby
@pagy, @records = pagy(Product.some_scope)
```

Include the frontend in some helper:

```ruby
include Pagy::Frontend
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav(@pagy) %>
```

or with a template:

```erb
<%== render 'pagy/nav', locals: {pagy: @pagy} %>
```

## Global Configuration

Unlike the other pagination gems, Pagy is very modular so it doesn't load nor execute unnecessary code in your app. Every feature that is not strictly needed for the basic pagination can be explicitly required in your initializer file.

Basic pagination should work out of the box for most Rack based apps (e.g. Rails) even without configuring/requiring anything, however you can tweak all its features and all the extras by loading a `pagy.rb` initializer file.

You can copy the comprehensive and annotated [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) initializer and uncomment and edit what you may need. The file contains also all the relevant documentation links.

## Environment Assumptions

- ruby >= 2.3

### Out of the box assumptions

Pagy works out of the box assuming that:

- You are using a `Rack` based framework
- The collection to paginate is an ORM collection (e.g. ActiveRecord scope)
- The controller where you include `Pagy::Backend` responds to a `params` method
- The view where you include `Pagy::Frontend` responds to a `request` method returning a `Rack::Request` instance.

### Any other scenario assumptions

Pagy can also work in any other scenario assuming that:

- If your framework doesn't have a `params` method you may need to define the `params` method or override the `pagy_get_vars` (which uses the `params` method) in your controller
- If the collection you are paginating doesn't respond to `offset` and `limit` you may need to override the `pagy_get_items` method in your controller (to get the items out of your specific collection) or use a specific extra if available (e.g. `array`, `searchkick`, ...)
- If your framework doesn't have a `request` method you may need to override the `pagy_url_for` (which uses `Rack` and `request`) in your view

**Notice**: the total overriding you may need is usually just a handful of lines at worse, and it doesn't need monkey patching or writing any sub-class or module.

## Items per page

You can control the items per page with the `items` variable. (Default `20`)

You can set its default in the `pagy.rb` initializer _(see [Configuration](#global-configuration)_. For example:

```ruby
Pagy::VARS[:items] = 25
```

You can also pass it as an instance variable to the `Pagy.new` method or to the `pagy` controller method:

```ruby
@pagy, @records = pagy(Product.some_scope, items: 30)
```

If you want to allow the client to request a custom number of items per page - useful with APIs or highly user-customizable apps - take a look at the [items extra](extras/items.md). It manages the number of items per page requested with the params, and offers a ready to use selector UI.

## Controlling the page links

You can control the number and position of the page links in the navigation through the `:size` variable. It is an array of 4 integers that specify which and how many page links to show.

The default is `[1,4,4,1]`, which means that you will get `1` initial page, `4` pages before the current page, `4` pages after the current page, and `1` final page.

As usual you can set the `:size` variable as a global default by using the `Pagy::VARS` hash or pass it directly to the `pagy` method.

The navigation links will contain the number of pages set in the variables:

`size[0]`...`size[1]` current page `size[2]`...`size[3]`

For example:

```ruby
pagy = Pagy.new count:1000, page: 10, size: [3,4,4,3] # etc
pagy.series
#=> [1, 2, 3, :gap, 6, 7, 8, 9, "10", 11, 12, 13, 14, :gap, 48, 49, 50]
```

As you can see by the result of the `series` method, you get 3 initial pages, 1 `:gap` (series interrupted), 4 pages before the current page, the current `:page` (which is a string), 4 pages after the current page, another `:gap` and 3 final pages.

You can easily try different options (also asymmetrical) in a console by changing the `:size`. Just check the `series` array to see what it contains when used in combination with different core variables.

### Skipping the page links

If you want to skip the generation of the page links, just set the `:size` variable to an empty array:

For example:

```ruby
pagy = Pagy.new count:1000, size: [] # etc
pagy.series
#=> []
```

## Passing the page number

You don't need to explicitly pass the page number to the `pagy` method, because it is pulled in by the `pagy_get_vars` (which is called internally by the `pagy` method). However you can force a `page` number by just passing it to the `pagy` method. For example:

```ruby
@pagy, @records = pagy(my_scope, page: 3)
```

That will explicitly set the `:page` variable, overriding the default behavior (which usually pulls the page number from the `params[:page]`).

## Customizing the page param

Pagy uses the `:page_param` variable to determine the param it should get the page number from and create the URL for. Its default is set as `Pagy::VARS[:page_param] = :page`, hence it will get the page number from the `params[:page]` and will create page URLs like `./?page=3` by default.

You may want to customize that, for example to make it more readable in your language, or because you need to paginate different collections in the same action. Depending on the scope of the customization, you have a couple of options:

1. `Pagy::VARS[:page_param] = :custom_param` will be used as the global default
2. `pagy(scope, page_param: :custom_param)` or `Pagy.new(count:100, page_param: :custom_param)` will be used for a single instance (overriding the global default)

You can also override the `pagy_get_vars` if you need some special way to get the page number.

## Customizing the link attributes

If you need to customize some HTML attribute of the page links, you may not need to override the `pagy_nav*` helper. It might be enough to pass some extra attribute string with the `:link_extra` variable. For example:

```ruby
# for all the Pagy instance
Pagy::VARS[:link_extra] = 'data-remote="true" class="my-class"'

# for a single Pagy instance (if you use the Pagy::Backend#pagy method)
@pagy, @records = pagy(my_scope, link_extra: 'data-remote="true" class="my-class"')

# or directly to the constructor
pagy = Pagy.new(count: 1000, link_extra: 'data-remote="true" class="my-class"')
```

**IMPORTANT**: For performance reasons, the `:link_extra` variable must be a string formatted as a valid HTML attribute/value pairs. That string will get inserted verbatim in the HTML of the link. _(see more advanced details in the [pagy_link_proc documentation](api/frontend.md#pagy_link_procpagy-link_extra))_

## Customizing the params

You may need to massage the params embedded in the URLs of the page links. You can do so by redefining the `pagy_get_params` sub-method in your helper. It will receive the `params` hash complete with the `:page` param and it should return a possibly modified version of it.

An example using `except` and `merge!`:

```ruby
def pagy_get_params(params)
  params.except(:anything, :not, :useful).merge!(something: 'more useful')
end
```

You can also use the `:param` and : `:anchor` non core variables to add arbitrary params to the URLs of the pages. For example:

```ruby
@pagy, @records = pagy(some_scope, params: {custom: 'param'}, anchor: '#your-anchor')
```

**IMPORTANT**: For performance reasons the `:anchor` string must include the `#`.

## Customizing the URL

When you need somethig more radical with the URL than just massaging the params, you should override the `pagy_url_for` right in your helper. The following are a couple of scenarios that would need that.

### Enabling fancy-routes

The following is a Rails-specific alternative that supports fancy-routes (e.g. `get 'your_route(/:page)' ...` that produce paths like `your_route/23` instead of `your_route?page=23`):

```ruby
def pagy_url_for(page, pagy)
  params = request.query_parameters.merge(:only_path => true, pagy.vars[:page_param] => page )
  url_for(params)
end
```

Notice that this overridden method is quite slower than the original because it passes through the rails helpers. However that gets mitigated by the internal usage of `pagy_link_proc` which calls the method only once even in the presence of many pages.

#### POST with page links

You may need to POST a very complex search form that would generate an URL potentially too long to be handled by a browser, and your page links may need to use POST and not GET. In that case you can try this simple solution:

```ruby
def pagy_url_for(page, _)
  page
end
```

That would produce links that look like e.g. `<a href="2">2</a>`. Then you can attach a javascript "click" event on the page links. When triggered, the `href` content (i.e. the page number) should get copied to a hidden `"page"` input and the form should be posted.

## Paginate Any Collection

Pagy doesn't need to know anything about the kind of collection you paginate. It can paginate any collection, because every collection knows its count and has a way to extract a chunk of items given an `offset` and a `limit`. It does not matter if it is an `Array` or an `ActiveRecord` scope or something else: the simple mechanism is the same:

1. Create a Pagy object using the count of the collection to paginate
2. Get the page of items from the collection using `pagy.offset` and `pagy.items`

An example with an array:

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

```ruby
@pagy, @records = pagy(Product.some_scope)
```

Then of course, regardless the kind of collection, you can render the navigation links in your view:

```erb
<%== pagy_nav(@pagy) %>
```

See the [Pagy::Backend source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb) and the [Pagy::Backend API documentation](api/backend.md) for more details.

## Paginate an Array

You have many ways to paginate an array with Pagy:

1. Implementing the above _how-to_ (probably not the most convenient way, besides being a good example)
2. Using the `pagy` method and overriding `pagy_get_items` _(see [pagy_get_items](api/backend.md#pagy_get_itemscollection-pagy)_
3. Using `pagy_array` offered by the `array` extra _(see [array extra](extras/array.md))_

## Paginate a pre-offsetted and pre-limited collection

With the other pagination gems you cannot paginate a subset of a collection that you got using `offset` and `limit`. With Pagy it is as simple as just adding the `:outset` variable, set to the initial offset. For example:

```ruby
subset = Product.offset(100).limit(315)
@pagy, @paginated_subset = pagy(subset, outset: 100)
```

Assuming the `:items` default of `20`, you will get the pages with the right records you are expecting. The first page from record 101 to 120 of the main collection, and the last page from 401 to 415 of the main collection. Besides the `from` and `to` attribute readers will correctly return the numbers relative to the subset that you are paginating, i.e. from 1 to 20 for the first page and from 301 to 315 for the last page.

## Paginate non-ActiveRecord collections

The `pagy_get_vars` method works out of the box with `ActiveRecord` collections; for other collections (e.g. `mongoid`, etc.) you may need to override it in your controller, usually by simply removing the `:all` argument passed to `count`:

```ruby
#count = collection.count(:all) 
count = collection.count
```

## Using the pagy_nav* helpers

These helpers take the Pagy object and return the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

```erb
<%== pagy_nav(@pagy) %>
```

**Notice**: the [extras](extras.md) add a few other helpers that you can use the same way, in order to get added features (e.g. bootstrap compatibility, responsiveness, compact layouts, etc.)

| Extra                                | Helpers                                                                                   |
| ------------------------------------ | ----------------------------------------------------------------------------------------- |
| [bootstrap](extras/bootstrap.md)     | `pagy_bootstrap_nav`, `pagy_bootstrap_compact_nav`, `pagy_bootstrap_responsive_nav`       |
| [bulma](extras/bulma.md)             | `pagy_bulma_nav`, `pagy_bulma_compact_nav`, `pagy_bulma_responsive_nav`                   |
| [foundation](extras/foundation.md)   | `pagy_foundation_nav`, `pagy_foundation_compact_nav`, `pagy_foundation_responsive_nav`    |
| [materialize](extras/materialize.md) | `pagy_materialize_nav`, `pagy_materialize_compact_nav`, `pagy_materialize_responsive_nav` |
| [plain](extras/plain.md)             | `pagy_plain_nav`, `pagy_plain_compact_nav`, `pagy_plain_responsive_nav`                   |
| [semantic](extras/semantic.md)       | `pagy_semantic_nav`, `pagy_semantic_compact_nav`, `pagy_semantic_responsive_nav`          |

Helpers are the preferred choice (over templates) for their performance. If you need to override a `pagy_nav*` helper you can copy and paste it in your helper and edit it there. It is a simple concatenation of strings with a very simple logic.

 Depending on the level of your overriding, you may want to read the [Pagy::Frontend API documentation](api/frontend.md) for complete control over your helpers.

## Skipping single page navs

Unlike other gems, Pagy does not decide for you that the nav of a single page of results must not be rendered. You may want it rendered... or maybe you don't. If you don't... wrap it in a condition and use the `pagy_nav*` only if `@pagy.pages > 1` is true. For example:

```erb
<%== pagy_nav(@pagy) if @pagy.pages > 1 %>
```

## Skipping page=1 param

By default Pagy generates all the page links including the `page` param. If you want to remove the `page=1` param from the first page link, just require the [trim extra](extras/trim.md).

## Using Templates

The `pagy_nav*` helpers are optimized for speed, and they are really fast. On the other hand editing a template might be easier when you have to customize the rendering, however every template system adds some inevitable overhead and it will be about 30-70% slower than using the related helper. That will still be dozens of times faster than the other gems, but... you should choose wisely.

Pagy provides the replacement templates for the `pagy_nav`, `pagy_bootstrap_nav`, `pagy_bulma_nav` and the `pagy_foundation_nav` helpers (available with the relative extras) in 3 flavors: `erb`, `haml` and `slim`.

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

If you need to try/compare an unmodified built-in template, you can render it right from the Pagy gem with:

```erb
<%== render file: Pagy.root.join('templates', 'nav.html.erb'), locals: {pagy: @pagy} %>
<%== render file: Pagy.root.join('templates', 'bootstrap_nav.html.erb'), locals: {pagy: @pagy} %>
```

You may want to read also the [Pagy::Frontend API documentation](api/frontend.md) for complete control over your templates.

## Dealing with a slow collection COUNT(*)

Every pagination gem needs the collection count in order to calculate _all_ the other variables involved in the pagination. If you use a storage system like any SQL DB, there is no way to paginate and provide a full nav system without executing an extra query to get the collection count. That is usually not a problem if your DB is well organized and maintained, but that may not be always the case.

Sometimes you may have to deal with some not very efficient legacy apps/DBs that you cannot totally control. In that case the extra count query may affect the performance of the app quite badly.

You have 2 possible solutions in order to improve the performance.

### Caching the count

Depending on the nature of the app, a possible cheap solution would be caching the count of the collection, and Pagy makes that really simple.

Pagy gets the collection count through its `pagy_get_vars` method, so you can override it in your controller. Here is an example using the rails cache:

```ruby
# in your controller: override the pagy_get_vars method so it will call your cache_count method
def pagy_get_vars(collection, vars)
  vars[:count] ||= cache_count(collection)
  vars[:page]  ||= params[ vars[:page_param] || Pagy::VARS[:page_param] ]
  vars
end

# add Rails.cache wrapper around the count call
def cache_count(collection)
  cache_key = "pagy-#{collection.model.name}:#{collection.to_sql}"
  Rails.cache.fetch(cache_key, expires_in: 20 * 60) do
   collection.count(:all)
  end
end

# in your model: reset the cache when the model changes (you may omit the callbacks if your DB is static)
after_create  { Rails.cache.delete_matched /^pagy-#{self.class.name}:/}
after_destroy { Rails.cache.delete_matched /^pagy-#{self.class.name}:/}
```

That may work very well with static (or almost static) DBs, where there is not much writing and mostly reading. Less so with more DB writing, and probably not particularly useful with a DB in constant change.

### Avoiding the count

When the count caching is not an option, you may want to use the [countless extra](extras/countless.md), which totally avoid the need for a count query, still providing an acceptable subset of the full pagination features.

## Adding HTTP headers

The HTTP pagination headers may be useful for APIs, but they are currently out of scope for Pagy. However there are a couple of gems that support Pagy and do that for you in a quite automatic way.

Please, take a look at:

- [api-pagination](https://github.com/davidcelis/api-pagination)
- [pager-api](https://github.com/IcaliaLabs/pager-api)

## Using the pagy_info helper

The page info that you get by using the `pagy_info` helper (e.g. "Displaying items __476-500__ of __1000__ in total") is composed by 2 strings stored in the `pagy.yml` locale file:

- the text of the sentence: located at the i18n paths `"pagy.info.single_page"` and `"pagy.info.multiple_pages"` (depending on how many pages compose the pagination)
- the generic item/model name: located at the i18n path`"pagy.info.item_name"`

While the text part can be always static, you may want the item/model name to be the actual model name, i.e. not just "items" but actually something like "Products" or something specific.

You can do so by setting the `:item_path` variable to the path to lookup in the dictionary file, in one of the following 2 ways:

1. by overriding the `pagy_get_vars` method in your controller (valid for all the Pagy instances) adding the `:item_path`. For example (with ActiveRecord):
    ```ruby
    def pagy_get_vars(collection, vars)
      { count:     collection.count(:all),
        page:      params[vars[:page_param]||Pagy::VARS[:page_param]],
        item_path: "activerecord.models.#{collection.model_name.i18n_key}" }.merge!(vars)
    end
    ```

2. by passing the variable to the Pagy object, either using the `Pagy::VARS` hash or `Pagy.new` method or `pagy` controller method:
    ```ruby
    # all the Pagy instances will have the default
    Pagy::VARS[:item_path] = 'activerecord.models.product'

    # or single Pagy instance
    @pagy, @record = pagy(my_scope, item_path: 'activerecord.models.product' )
    ```

**Notice**: The variables passed to a Pagy object have the precedence over the variables returned by the `pagy_get_vars`. The fastest way is passing a literal string to the `pagy` method, the most convenient way is using `pagy_get_vars`.

## Handling Pagy::OverflowError exceptions

Pass an overflowing `:page` number and Pagy will raise a `Pagy::OverflowError` exception.

This often happens because users/clients paginate over the end of the record set or records go deleted and a user went to a stale page.

You can handle the exception by using the [overflow extra](extras/overflow.md) which provides easy and ready to use solutions for a few common cases, or you can rescue the exception manually and do whatever fits better.

Here are a few options for manually handling the error in apps:

- Do nothing and let the page render a 500
- Rescue and render a 404
- Rescue and redirect to the last known page (Notice: the [overflow extra](extras/overflow.md) provides the same behavior without redirecting)

   ```ruby
   # in a controller
   rescue_from Pagy::OverflowError, with: :redirect_to_last_page

   private

   def redirect_to_last_page(e)
     redirect_to url_for(page: e.pagy.last), notice: "Page ##{params[:page]} is overflowing. Showing page #{e.pagy.last} instead."
   end
   ```
