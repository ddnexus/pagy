---
title: Searchkick
---
# Searchkick Extra

This extra deals with the pagination of `Searchkick::Results` objects either by creating a `Pagy` object out of an (already paginated) `Searchkick::Results` object or by creating the `Pagy` and `Searchkick::Results` objects from the backend params.

## Synopsis

See [extras](../extras.md) for general usage info.

Require the extra in the `pagy.rb` initializer:

```ruby
require 'pagy/extras/searchkick'
```

### Passive mode

If you have an already paginated `Searchkick::Results` object, you can get the `Pagy` object out of it:

```ruby
@results = Model.search('*', page: 1; per_page: 10, ...)
@pagy    = Pagy.new_from_searchkick(@results, ...)
```

### Active Mode

If you want Pagy to control the pagination, getting the page from the params, and returning both the `Pagy` and the `Searchkick::Results` objects automatically (from the backend params):

Extend your model:

```ruby
extend Pagy::Search
```

In a controller use `pagy_search` in place of `search`:

```ruby
records = Article.pagy_search(params[:q]).results
@pagy, @records = pagy_searchkick(records, items: 10)
```

## Files

This extra is composed of 1 file:

- [searchkick.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/searchkick.rb)

## Pagy.new_from_searchkick

This constructor accepts an `Searchkick::Results` as the first argument, plus the usual optional variable hash. It sets the `:items`, `:page` and `:count` pagy variables extracted/calculated out of the `Searchkick::Results` object.

```ruby
@results = Model.search('*', page: 2; per_page: 10, ...)
@pagy    = Pagy.new_from_searchkick(@results, ...)
```

**Notice**: you have to take care of managing all the params manually. If you prefer to manage the pagination automatically, see below.

## Pagy::Search

Extend your model with the `Pagy::Search` micro-moudule (see [pagy_search.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/pagy_search.rb))

```ruby
extend Pagy::Search
```

The `Pagy::Search` adds the `pagy_search` class method that you must use in place of the standard `search` method when you want to paginate the search response.

### pagy_search(term, options={})

This method accepts the same arguments of the `search` method and you must use it in its place. This extra uses it in order to capture the arguments, automatically merging the calculated `:page` and `:per_page` options before passing them to the standard `search` method internally.

## Methods

This extra adds the `pagy_searchkick` method to the `Pagy::Backend` to be used when you have to paginate a `Searchkick::Results` object. It also adds a `pagy_searchkick_get_vars` sub-method, used for easy customization of variables by overriding.

### pagy_searchkick(Model.pagy_search(...), vars={}})

This method is similar to the generic `pagy` method, but specialized for Searchkick. (see the [pagy doc](../api/backend.md#pagycollection-varsnil))

It expects to receive a `Model.pagy_search(...)` result and returns a paginated response. You can use it in a couple of ways:

```ruby
@pagy, @results = pagy_searchkick(Model.pagy_search(params[:q]), ...)
...
@records = @results.results

# or directly with the collection you need (e.g. records)
@pagy, @records = pagy_searchkick(Model.pagy_search(params[:q]).results, ...)
```

### pagy_searchkick_get_vars(array)

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_searchkick` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).
