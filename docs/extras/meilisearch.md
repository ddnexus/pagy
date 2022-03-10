---
title: Meilisearch
---
# Meilisearch Extra

This extra deals with the pagination of `Meilisearch` results either by creating a `Pagy` object out of an (already paginated) `Meilisearch` results or by creating the `Pagy` and `Meilisearch` results from the backend params.

## Synopsis

See [extras](../extras.md) for general usage info.

Require the extra in the `pagy.rb` initializer:

```ruby
require 'pagy/extras/meilisearch'
```

### Passive mode

If you have an already paginated `Meilisearch` results, you can get the `Pagy` object out of it:

```ruby
@results = Model.ms_search(nil, offset: 10, limit: 10, ...)
@pagy    = Pagy.new_from_meilisearch(@results, ...)
```

### Active Mode

If you want Pagy to control the pagination, getting the page from the params, and returning both the `Pagy` and the Meilisearch results automatically (from the backend params):

Extend your model:

```ruby
extend Pagy::Meilisearch
ActiveRecord_Relation.include Pagy::Meilisearch  # <--- (optional) if you use `includes` makes it work as expected
```

In a controller use `pagy_search` in place of `search`:

```ruby
results         = Article.pagy_search(params[:q])
@pagy, @results = pagy_meilisearch(results, items: 10)
```

## Files

- [meilisearch.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/meilisearch.rb)

## Pasive mode

### Pagy.new_from_meilisearch

This constructor accepts a Meilisearch as the first argument, plus the usual optional variable hash. It sets the `:items`, `:page` and `:count` pagy variables extracted/calculated out of the Meilisearch object.

```ruby
@results = Model.ms_search(nil, offset: 10, limit: 10, ...)
@pagy    = Pagy.new_from_meilisearch(@results, ...)
```

**Notice**: you have to take care of manually manage all the params for your search, however the method extracts the `:items`, `:page` and `:count` from the results object, so you don't need to pass that again. If you prefer to manage the pagination automatically, see below.

## Active Mode

### Pagy::Meilisearch module

Extend your model with the `Pagy::Meilisearch` micro-module:

```ruby
extend Pagy::Meilisearch
```

The `Pagy::Meilisearch` adds the `pagy_search` class method that you must use in place of the standard `search` method when you want to paginate the search response.

### pagy_search(...)

This method accepts the same arguments of the `search` method and you must use it in its place. This extra uses it in order to capture the arguments, automatically merging the calculated `:offset` and `:limit` options before passing them to the standard `search` method internally.

### Variables

| Variable                   | Description                                     | Default        |
|:---------------------------|:------------------------------------------------|:---------------|
| `:meilisearch_pagy_search` | customizable name of the pagy search method     | `:pagy_search` | 
| `:meilisearch_search`      | customizable name of the original search method | `:search`      | 

## Methods

This extra adds the `pagy_meilisearch` method to the `Pagy::Backend` to be used when you have to paginate a Meilisearch object. It also adds a `pagy_meilisearch_get_vars` sub-method, used for easy customization of variables by overriding.

### pagy_meilisearch(Model.pagy_search(...), vars={}})

This method is similar to the generic `pagy` method, but specialized for Meilisearch. (see the [pagy doc](../api/backend.md#pagycollection-varsnil))

It expects to receive a `Model.pagy_search(...)` result and returns a paginated response. You can use it in a couple of ways:

```ruby
@pagy, @results = pagy_meilisearch(Model.pagy_search(params[:q]), ...)
...
@records = @results.results

# or directly with the collection you need (e.g. records)
@pagy, @records = pagy_meilisearch(Model.pagy_search(params[:q]).results, ...)
```

### pagy_meilisearch_get_vars(array)

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_meilisearch` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).
