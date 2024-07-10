---
title: Pagy::Backend
categories:
  - Core
  - Module
  - Backend
description: This module provides the base functionality for the backend.
---

# Pagy::Backend

This module provides a _generic_ pagination method (`pagy`) that works with `ActiveRecord` out of the box. For any other
collection (e.g. `Sequel`, `Mongoid`, ...) you may need to override some sub-method
or [write your own Pagy methods](#writing-your-own-pagy-methods).

For overriding convenience, the `pagy` method calls two sub-methods that you may need to override in order to customize it for any
type of collection (e.g. different ORM types, etc.).

!!!primary `Pagy::Backend` returns `pagy` instances
Keep in mind that the whole module is basically providing a single functionality: getting a Pagy instance and the paginated items.
You could re-write the whole module as one single and simpler method specific to your need, eventually gaining a few IPS in the
process. If you seek a bit more performance you are encouraged to [write your own Pagy methods](#writing-your-own-pagy-methods).
!!!

Check also
the [array](/docs/extras/array.md), [searchkick](/docs/extras/searchkick.md), [elasticsearch_rails](/docs/extras/elasticsearch_rails.md)
and [meilisearch](/docs/extras/meilisearch.md) extras for specific backend customizations.

## Synopsis

```ruby Controller
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

All the methods in this module are prefixed with the `"pagy_"` string, to avoid any possible conflict with your own methods when
you include the module in your controller. They are also all private, so they will not be available as actions. The methods
prefixed with the `"pagy_get_"` string are sub-methods/getter methods that are intended to be overridden, not used directly.

Please, keep in mind that overriding any method is very easy with Pagy. Indeed you can do it right where you are using it: no need
of monkey-patching or perform any tricky gimmickry.

==- `pagy(collection, vars=nil)`

This is the main method of this module. It takes a collection object (e.g. a scope), and an optional hash of variables (passed to
the `Pagy.new` method) and returns the `Pagy` instance and the page of records. For example:

```ruby
@pagy, @records = pagy(Product.my_scope, some_option: 'get merged in the pagy object')
```

The built-in `pagy` method is designed to be easy to customize by overriding any of the two sub-methods that it calls internally.
You can independently change the default variables (`pagy_get_vars`) and/or the default page of items from the
collection `pagy_get_records`).

If you need to use multiple different types of collections in the same app or action, you may want to define some alternative and
self contained custom `pagy` method. (see [Writing your own Pagy methods](#writing-your-own-pagy-methods))

==- `pagy_get_vars(collection, vars)`

Sub-method called only by the `pagy` method, it returns the hash of variables used to initialize the Pagy object.

Override it if you need to add or change some variable. For example you may want to add the `:item_name` in order to customize
the output _(see [How to customize the item name](/docs/how-to.md#customize-the-item-name))_.

!!!warning Don't remove `:count` and `:page`
If you override it, remember that `:count` and `:page` are the only 2 required Pagy core variables, so be careful not to remove them from the returned hash.
!!!

See also the [How To](/docs/how-to.md) page for some usage examples.

==- `pagy_get_count(collection, vars)`

Get the count from the collection, considering also the `:count_args` variable. Override it if you need to calculate the count in some special way, or cache it. e.g. overriding [`pagy_get_count` when using mongoid](../how-to/#override-pagy_get_count-use-count_documents-with-mongoid).

==- `pagy_get_page(vars)`

Get the `page` from the param ,looking at the `:page_param` variable. See also [Customize the page_param](/docs/how-to.md#customize-the-page-param).

==- `pagy_get_records(collection, pagy)`

Sub-method called only by the `pagy` method, it returns the records belonging to the current page.

Here is its source (it works with most ORMs like `ActiveRecord`, `Sequel`, `Mongoid`, ...):

```ruby

def pagy_get_records(collection, pagy)
  collection.offset(pagy.offset).limit(pagy.items)
end
```

Override it if the extraction of the items from your collection works in a different way. For example, if you need to paginate an
array:

```ruby

def pagy_get_records(array, pagy)
  array[pagy.offset, pagy.items]
end
```

!!!info `Array` extra for Arrays
In order to paginate arrays, you may want to use the  [array extra](/docs/extras/array.md).
!!!

===

## Writing your own Pagy methods

Sometimes you may need to paginate different kinds of collections (that require different overriding) in the same controller, so
using one single `pagy` method would not be an option.

In that case you can define a number of `pagy_*` custom methods specific for each collection.

For example: here is a `pagy` method that doesn't call any sub-method, that may be enough for your needs:

```ruby Controller

def pagy_custom(collection, vars = {})
  pagy = Pagy.new(count: collection.count(*vars[:count_args]), page: params[:page], **vars)
  [pagy, collection.offset(pagy.offset).limit(pagy.items)]
end
```

You can easily write a `pagy` method for _any possible_ environment: please read how
to [Paginate Any Collection](/docs/how-to.md#paginate-any-collection) for details.

!!!success PRs Welcome
If you write some useful backend customizations,
please [let us know](https://github.com/ddnexus/pagy/discussions/categories/feature-requests) if you can submit a PR for a
specific extra or if you need any help to do it.
!!!
