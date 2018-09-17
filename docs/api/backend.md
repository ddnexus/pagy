---
title: Pagy::Backend
---
# Pagy::Backend

This module _(see [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb))_ provides a _generic_ pagination method (`pagy`) that works with `ActiveRecord` out of the box. For any other collection (e.g. `Sequel`, `Mongoid`, `Elasticsearch`, ...) you may need to override some sub-method or [write your own Pagy methods](#writing-your-own-pagy-methods).

For overriding convenience, the `pagy` method calls two sub-methods that you may need to override in order to customize it for any type of collection (e.g. different ORM types, Array, elasticsearch results, etc.).

**Notice**: Keep in mind that the whole module is basically providing a single functionality: getting a Pagy instance and the paginated items. You could re-write the whole module as one single and simpler method specific to your need, eventually gaining a few IPS in the process. If you seek a bit more performance you are encouraged to [write your own Pagy methods](#writing-your-own-pagy-methods).

Check also the [array extra](../extras/array.md) and [searchkick extra](../extras/searchkick.md) for specific backend customizations.

## Synopsys

```ruby
# in some controller
include Pagy::Backend

# optional overriding of some sub-method
def pagy_get_vars(collection, vars)
  #...
end

# use it in some action
def index
  @pagy, @records = pagy(Product.some_scope, some_option: 'some option for this instance')
end
```

## Methods

All the methods in this module are prefixed with the `"pagy_"` string, to avoid any possible conflict with your own methods when you include the module in your controller. They are also all private, so they will not be available as actions. The methods prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden, not used directly.

Please, keep in mind that overriding any method is very easy with Pagy. Indeed you can do it right where you are using it: no need of monkey-patching or perform any tricky gymnic.

### pagy(collection, vars=nil)

This is the main method of this module. It takes a collection object (e.g. a scope), and an optional hash of variables (passed to the `Pagy.new` method) and returns the `Pagy` instance and the page of records. For example:

```ruby
@pagy, @records = pagy(Product.my_scope, some_option: 'get merged in the pagy object')
```

The built-in `pagy` method is designed to be easy to customize by overriding any of the two sub-methods that it calls internally. You can independently change the default variables (`pagy_get_vars`) and/or the default page of items from the collection `pagy_get_items`).

If you need to use multiple different types of collections in the same app or action, you may want to define some alternative and self contained custom `pagy` method. (see [Writing your own Pagy methods](#writing-your-own-pagy-methods))

### pagy_get_vars(collection, vars)

Sub-method called only by the `pagy` method, it returns the hash of variables used to initialize the Pagy object.

Override it if you need to add or change some variable. For example you may want to add the `:item_path` or the `:item_name` to customize the `pagy_info` output, or even cache the `count`.

_IMPORTANT_: `:count` and `:page` are the only 2 required Pagy core variables, so be careful not to remove them from the returned hash.

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

**Notice**: in order to paginate arrays, you may want to use the  [array extra](../extras/array.md).

## Writing your own Pagy methods

Sometimes you may need to paginate different kinds of collections (that require different overriding) in the same controller, so using one single `pagy` method would not be an option.

In that case you can define a number of `pagy_*` custom methods specific for each collection.

For example: here is a `pagy` method that doesn't call any sub-method, that may be enough for your needs:

```ruby
def pagy_custom(collection, vars={})
  pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
  return pagy, collection.offset(pagy.offset).limit(pagy.items)
end
```

You can easily write a `pagy` method for _any possible_ environment: please read how to [Paginate Any Collection](../how-to.md#paginate-any-collection) for details.

**IMPORTANT**: If you write some useful backend customization, please [let us know](https://gitter.im/ruby-pagy/Lobby) if you can submit a PR for a specific extra or if you need any help to do it.
