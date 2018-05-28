---
title: Pagy::Backend
---

# Pagy::Backend

This module provides a _generic_ pagination method (`pagy`) that works out of the box with any ORM collection (e.g. `ActiveRecord`, `Sequel`, `Mongoid`, ... collections), plus two sub-methods that you may want to override in order to customize it for any type of collection (e.g. Array, elasticsearch results, etc.) _([source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb))_

If you use also the `pagy-extras` gem, this module will get extended by a few _specific_ pagination methods, very convenient to use with _specific_ types of collections like Array, elasticsearch results, etc.

__Notice__: Currently, the only available backend extra is the [array extra](../pagy-extras/array.md), but stay tuned, because there will be more in the near future.

_(see the [pagy-extras](../pagy-extras.md) doc for more details)_


## Synopsys

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

## Methods

All the methods in this module are prefixed with the `"pagy_"` string, to avoid any possible conflict with your own methods when you include the module in your controller. They are also all private, so they will not be available as actions. The methods prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden, not used directly.

Please, keep in mind that overriding any method is very easy with pagy. Indeed you can do it right where you are using it: no need of monkey-patching or subclassing or perform any tricky gymnic.


### pagy(collection, vars=nil)

This is the main method of this module. It takes a collection object (e.g. a scope), and an optional hash of variables (passed to the `Pagy.new` method) and returns the `Pagy` instance and the page of records. For example:
```ruby
@pagy, @records = pagy(Product.my_scope, some_option: 'get merged in the pagy object')
```
The built-in `pagy` method is designed to be easy to customize by overriding any of the two sub-methods that it calls internally. You can independently change the default variables (`pagy_get_variables`) and/or the default page of items from the collection `pagy_get_items`).

If you need to use multiple different types of collections in the same app or action, you may want to define some alternative and self contained custom `pagy` method.

For example: here is a `pagy` method that doesn't call any sub-method, that may be enough for your app:
```ruby
def pagy_custom(collection, vars={})
  pagy = Pagy.new(count: collection.count, page: params[:page], **vars)
  return pagy, collection.offset(pagy.offset).limit(pagy.items)
end
```

### pagy_get_vars(collection)

Sub-method called only by the `pagy` method, it returns the hash of variables used to initialize the pagy object.

Here is its source:

```ruby
def pagy_get_vars(collection)
  { count: collection.count, page: params[:page] }
end
```
Override it if you need to add or change some variable. For example you may want to add the `:item_path` or the `:item_name` to customize the `pagy_info` output, or get the `:page` from a different param, or even cache the `count`.

_IMPORTANT_: `:count` and `:page` are the only 2 required pagy core variables, so be careful not to remove them from the returned hash.

See also the [How To](../how-to.md) wiki page for some usage example.


### pagy_get_items(collection, pagy)

Sub-method called only by the `pagy` method, it returns the page items (i.e. the records belonging to the current page).

 Here is its source (it works with most ORMs like `ActiveRecord`, `Sequel`, `Mongoid`, ...):

```ruby
def pagy_get_items(collection, pagy)
  collection.offset(pagy.offset).limit(pagy.items)
end
```
Override it if the extraction of the items from your collection works in a different way. For example, if you need to paginate an array:

```ruby
def pagy_get_items(array, pagy)
  array[pagy.offset, pagy.items]
end
```
__Notice__: in order to paginate arrays, you may want to use the `array` extra.
