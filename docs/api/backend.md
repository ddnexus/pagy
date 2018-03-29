## Pagy::Backend

The only scope of this module is encapsulating a couple of verbose statements in one single slick `pagy` method, that returns the pagy instance and the page of records from the collection. _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb))_

Including this module in your controller allows you to have a predefined `pagy` method plus a couple of sub-methods (i.e. getter methods called only by the predefined method), which are handy if you need to override some specific aspect of the predefined `pagy` method.

You can also write your own `pagy` method in your controller without including this module: it's just a couple of lines. For example, the following may be enough for your app:
```ruby
def pagy(collection, vars={})
  pagy = Pagy.new(count: collection.count, page: params[:page], _vars)
  return pagy, collection.offset(pagy.offset).limit(pagy.items)
end
```

### Synopsys

```ruby
# typically in your controller
include Pagy::Backend

# optional overriding of some sub-method (e.g. get the page number from the :seite param)
def pagy_get_vars(collection)
  { count: collection.count, page: params[:seite] } 
end

# use it in some action
def index
  @pagy, @records = pagy(Product.some_scope, some_option: 'some option for this instance')
end
 
```

### Methods

All the methods in this module are prefixed with the `"pagy_"` string, to avoid any possible conflict with your own methods when you include the module in your controller. They are also all private, so they will not be available as actions. The methods prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden, not used directly.

Please, keep in mind that overriding any method is very easy with pagy. Indeed you can do it right where you are using it: no need of monkey-patching or subclassing or perform any tricky gymnic.


### pagy(collection, vars=nil)

This is the main method of this module. It takes a collection object (e.g. a scope), and an optional hash of variables (passed to the `Pagy.new` method) and returns the `Pagy` instance and the page of records. For example:
```ruby
@pagy, @records = pagy(Product.my_scope, some_option: 'get merged in the pagy object')
```
Internally it calls the following sub-methods, in order to get the arguments needed to initialize the `Pagy` instance and to paginate the collection.


#### pagy_get_vars(collection)

Sub-method called by the `pagy` method, it returns the hash of variables used to initialize the pagy object.

Here is its source:

```ruby
def pagy_get_vars(collection)
  { count: collection.count, page: params[:page] }
end
```
Override it if you need to add or change some variable. For example you may want to add the `:item_path` or the `:item_name` to customize the `pagy_info` output, or get the `:page` from a different param, or even cache the `count`. 

See also the [How To](/pagy/how-to) wiki page for some usage example.


#### pagy_get_items(collection, pagy)

Sub-method called by the `pagy` method, it returns the page items (i.e. the records belonging to the current page).
 
 Here is its source (it works with most ORMs like `ActiveRecord`, `Sequel`, `Mongoid`, ...):
 
 ```ruby
 def pagy_get_items(collection, pagy)
   collection.offset(pagy.offset).limit(pagy.items)
 end
 ```
 Override it if the extraction of the items from your collection works in a different way.
