# How To

This page contains the practical tips and examples to get the job done with pagy. If there is something missing, or some topic that you think should be added, fixed or explained better, please open an issue. 

### Quick Start

Install and require:
```bash
gem install pagy
```
```ruby
require 'pagy'
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
```HTML+ERB
<%= pagy_nav(@pagy) %>
```
or with a template:
```HTML+ERB
<%= render 'pagy/nav', locals: {pagy: @pagy} %>
```

### Paginate Any Collection

Pagy doesn't need to know anything about the kind of collection you paginate, it doesn't need to "teach" it how to paginate itself by adding code to it: pagy just needs to know its count.

With pagy you can paginate any collection, because every collection knows its count and every collection has a way to paginate itself by extracting a chunk of its items given a `offset` and a `limit` (i.e. skipping a few items from the beginning and getting a limited number from there). It does not matter if it is an `Array` or an `ActiveRecord` scope or something else: the simple mechanism is the same:

1. Create a pagy object using the `count` of the collection to paginate
2. Get the page of items from the collection using `pagy.offset` and `pagy.items`

An example with an array: 

```ruby
# paginate an array
arr = (1..1000).to_a

# Create a pagy object using the count of the collection to paginate
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
```HTML+ERB
<%= pagy_nav(@pagy) %>
```
See the [Pagy::Backend source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb) and the [Pagy::Backend API documentation](/pagy/api/backend) for more details. 

### Paginate a pre-offsetted and pre-limited collection

With the other pagination gems you cannot paginate a subset of a collection that you got using offset and limit. With Pagy it is as simple as just adding the `:outset` variable, set to the initial offset. For example:

```ruby
subset = Product.offset(100).limit(315)
@pagy, @paginated_subset = pagy(subset, outset: 100)     
```

Assuming the `:items` default of `20`, you will get the pages with the right records you are expecting. The first page from record 101 to 120 of the main collection, and the last page from 401 to 415 of the main collection. Besides the `from` and `to` attribute readers will correctly return the numbers relative to the subset that you are paginating, i.e. from 1 to 20 for the first page and from 301 to 315 for the last page.


### Items per page

You can control the items per page with the `items` variable. (Default `20`)

You can set its default in an initializer (applied to all instances). For example:
```ruby
Pagy::VARS[:items] = 25
```
You can also pass it as an instance variable to the `Pagy.new` method or to the `pagy` controller method:
```ruby
@pagy, @records = pagy(Product.some_scope, items: 30)
``` 

### Passing the page number

You don't need to explicitly pass the usual `params[:page]` page number to the `pagy` method, because it is pulled in by the `pagy_get_vars` (which is called internally byt the `pagy` mehtod). However you can force a `page` number by just passing it to the `pagy` method. For example:

```ruby
pagy(my_scope, page: 3)  
```

That will explicitly set the `:page` variable, overriding the `params[:page]` default.

__Notice__: If you need to get the page number from another param or in some different way, just override the `pagy_get_vars` method right in your controller.


### Control the page links

You can control the number and position of page links in the navigation through the `:size` variables. It is an array of 4 integers that specify which and how many page link to show.

The default is `[1,4,4,1]`, which means that you will get `1` initial page, `4` pages before the current page, `4` pages after the current page, and `1` final page

As usual you can set them as global defaults by using the `Pagy::VARS` hash or pass them directly to the `pagy` method.

The navigation links will contain the number of pages set in the variables:

`size[0]`...`size[1]` current page `size[2]`...`size[3]`

For example:

```ruby
pagy = Pagy.new count:1000, page: 10, size: [3,4,4,3] # etc
pagy.series
#=> [1, 2, 3, :gap, 6, 7, 8, 9, "10", 11, 12, 13, 14, :gap, 48, 49, 50]
```

As you can see by the result of the `series` method, you get 3 initial pages, 1 `:gap` (series interupted), 4 pages before the current page, the current `:page` (which is a string), 4 pages after the current page, another `:gap` and 3 final pages.
 
You can easily try different options (also asymmetrical) in a console by changing the `:size`: just check the `series` array to see what it contains when used in combination with different core variables.


### Using the `pagy_nav` and `pagy_nav_bootstrap` helpers

These helpers take the pagy object and returns the HTML string with the pagination links, which are wrapped in a `nav` tag and are ready to use in your view. For example:

```HTML+ERB
<%= pagy_nav(@pagy) %>
```
Helpers are the preferred choice (over templates) for their performance. If you need to override a `pagy_nav*` helper you can copy and paste it in your helper end edit it there. It is a simple concatenation of strings with a very simple logic.
 
 Depending on the level of your override, you may want to read the [Pagy::Frontend API documentation](/pagy/api/frontend) for complete control over your helpers.

### Customizing the link attributes

If you need to customize some HTML attribute of the page links, you may not need to override the `pagy_nav*` helper. It might be enough to pass some extra attribute string with the `:link_extra` variable. For example:

```ruby
# for all the pagy instance
Pagy::VARS[:link_extra] = 'data-remote="true" class="my-class"'

# for a single pagy instance (if you use the Pagy::Backend#pagy method)
@pagy, @records = pagy(my_scope, link_extra: 'data-remote="true" class="my-class"')

# or directly to the constructor
pagy = Pagy.new(count: 1000, link_extra: 'data-remote="true" class="my-class"')
```
**IMPORTANT**: For performance reasons, the `:link_extra` variable must be a string formatted as a valid HTML attribute/value pairs. That string will get inserted verbatim in the HTML of the link. _(see more advanced details in the [pagy_link_proc documentation](/pagy/api/frontend#pagy_link_procpagy-link_extra))_

### Cutomizing the params

You may need to massage the params embedded in the URLs of the page links. You can do so by redefining the `pagy_get_params` sub-method in your helper. It will receive the `params` hash complete with the `"page"` param and it should return a possibly modified version of it. 

An example using `except` and `merge!`:

```ruby
def pagy_get_params(params)
  params.except(:anything, :not, :useful).merge!(something: 'more useful')
end
```

### Customizing the URL

When you need somethig more radical with the URL than just massaging the params, you should override the `pagy_url_for` right in your helper. The following are a couple of scenarios that would need that.

#### Enabling fancy-routes
    
The following is a Rails-specific alternative that supports fancy-routes (e.g. `get 'your_route[/:page]' ...` that produce paths like `your_route/23` instead of `your_route?page=23`):

```ruby
def pagy_url_for(n)
  params = request.query_parameters.merge(only_path: true, page: n)
  url_for(params)
end
```

Notice that this overridden method is quite slower than the original because it passes through the rails helpers. However that gets mitigated by the internal usage of `pagy_link_proc` which calls the method only once even in presence of many pages.

#### POST with page links

You may need to POST a very complex search form that would generate an URL potentially too long to be handled by a browser, and your page links may need to use POST and not GET. In that case you can try this simple solution:

```ruby
def pagy_url_for(n)
  n
end
```
That would produce links that look like e.g. `<a href="2">2</a>`. Then you can attach a javascript "click" event on the page links. When triggered, the `href` content (i.e. the page number) should get copied to a hidden `"page"` input and the form should be posted.

### Using Templates

The `pagy_nav*` helpers are optimized for speed, and they are really fast. On the other hand editing a template might be easier when you have to customize the rendering, however every template system adds some inevitable overhead and it will be about 40-80% slower than using the related helper, so choose wisely.

Pagy provides the replacement templates for the `pagy_nav` and the `pagy_nav_bootstrap` helpers in 3 flavors: `erb`, `haml` and `slim`. 

They produce exactly the same output of the helpers, but they are slower, so use them only if you need to change something. In that case customize a copy in your app, then use it as any other template: just remember to pass the `:pagy` local set to the `@pagy` object. Here are the links to the sources to copy:

- [nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav.html.erb)
- [nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav.html.haml)
- [nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav.html.slim)
- [nav_bootstrap.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bootstrap.html.erb)
- [nav_bootstrap.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bootstrap.html.haml)
- [nav_bootstrap.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bootstrap.html.slim)

If you need to try/compare an unmodified built-in template, you can render it right from the pagy gem with:

```HTML-ERB
<%= render file: Pagy.root.join('templates', 'nav.html.erb'), locals: {pagy: @pagy} %>
```
You may want to read also the [Pagy::Frontend API documentation](/pagy/api/frontend) for complete control over your templates.


### Caching the collecion count

Every pagination gem needs the collection count in order to calculate all the other variables involvd in the pagination. If you use a storage system like any SQL DB, there is no way to paginate and provide a full nav system without executing an extra query to get the collection count. That is usually not a problem if your DB is well organized and maintained, but that may not be always the case. 

Sometimes you may have to deal with some not very efficient legacy apps/DBs that you cannot totally control. In that case the extra count query may affect the performance of the app quite badly. 

Depending on the nature of the app, a possible cheap solution would be caching the count of the collection, and Pagy makes that really simple. 

Pagy gets the collection count through its `pagy_get_vars` method, so you can override it in your controller. Here is an example using the rails cache:

```ruby
# in your controller: override the pagy_get_vars method so it will call your cache_count method
def pagy_get_vars(collection)
  {count: cache_count(collection), page: params[:page]}
end

# add Rails.cache wrapper around the count call
def cache_count(collection)
  cache_key = "pagy-#{collection.model.name}:#{collection.to_sql}"
  Rails.cache.fetch(cache_key, expires_in: 20 * 60) do
   collection.count
  end
end

# in your model: reset the cache when the model changes (you may omit the callbacks if your DB is static)
after_create  { Rails.cache.delete_matched /^pagy-#{self.class.name}:/}
after_destroy { Rails.cache.delete_matched /^pagy-#{self.class.name}:/}
```
That may work very well with static (or almost static) DBs, where there is not much writing and mostly reading. Less so with more DB writing, and probably not particularly useful with a DB in constant change.

### Using I18n

Pagy is I18n ready. That means that all the UI strings that pagy uses are stored in a dictionaray YAML file, ready to be customized and/or translated/pluralized. The YAML file is available at `Pagy.root.join('locales', 'pagy.yml')` 

It contains a few entries used in the the UI by helpers and templates through the `pagy_t` method (eqivalent to the `I18n.t` or rails `t` helper). For more details, please take a look at the [pagy.yml file](https://github.com/ddnexus/pagy/blob/master/lib/locales/pagy.yml) and read the [pagy_t API documentation](/pagy/api/frontend#pagy_tpath-vars)

### Using the pagy_info helper

The page info that you get by using the `pagy_info` helper (e.g. "Displaying items <b>476-500</b> of <b>1000</b> in total") is composed by 2 strings: 

- the text of the sentence: available in the `pagy.yml` locale file at the i18n paths `"pagy.info.single_page"` and `"pagy.info.multiple_pages"` (depending on how many pages compose the pagination)
- the generic item/model name: available at the i18n path`"pagy.info.item_name"`

While the text part can be always static, you may want the item/model name to be the actual model name, i.e. not just "items" but actually something like "Products" or something specific.

You can do so by setting the `:item_path` variable to the path to lookup in the dictionary file, in one of the following 2 ways:

1. by overriding the `pagy_get_vars` method in your controller (valid for all the pagy instances) adding the `:item_path`. For example (with ActiveRecord):
    ```ruby
    def pagy_get_vars(collection)
      {count: collection.count, page: params[:page], item_path: "activerecord.models.#{collection.model_name.i18n_key}" }
    end
    ```

2. by passing the variable to the pagy object, either using the `Pagy::VARS` hash or `Pagy.new` method or `pagy` controller method:
    ```ruby
    # all pagy instance will have the default
    Pagy::VARS[:item_path] = 'activerecord.models.product'
 
    # or single pagy instance
    @pagy, @record = pagy(my_scope, item_path: 'activerecord.models.product' )
    ```
    
__Notice__: The variables passed to a pagy object have the precedence over the variables returned by the `pagy_get_vars`. The fastest way is passing a literal string to the `pagy` method, the most convenient way is using `pagy_get_vars`.
__Notice__: The variables passed to a pagy object have the precedence over the variables returned by the `pagy_get_vars`. The fastest way is passing a literal string to the `pagy` method, the most convenient way is using `pagy_get_vars`.

### Handling Pagy::OutOfRangeError exception

Pass an out of range `:page` number and pagy will raise a `Pagy::OutOfRangeError` exception, which you can rescue from and do what you think fits. You can rescue from the exception and render a not found page, or render a specific page number, or whatever. For example:

```ruby
# in a controller
rescue_from Pagy::OutOfRangeError, :with => :redirect_to_page_20

private

def redirect_to_page_20
  redirect_to url_for(page: 20), notice: %(Page ##{params[:page]} is out of range. Showing page #20 instead.)
end
```
