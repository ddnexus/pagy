---
title: Elasticsearch Rails
---
# Elasticsearch Rails Extra

This extra deals with the pagination of `ElasticsearchRails` response objects either by creating a `Pagy` object out of an (already paginated) `ElasticsearchRails` object or by creating the `Pagy` and `ElasticsearchRails` objects from the backend params.

## Synopsis

See [extras](../extras.md) for general usage info.

Require the extra in the `pagy.rb` initializer:

```ruby
require 'pagy/extras/elasticsearch_rails'
```

### Passive mode

If you have an already paginated `Elasticsearch::Model::Response::Response` object, you can get the `Pagy` object out of it:

```ruby
@response = Model.search('*', from: 0, size: 10, ...)
@pagy     = Pagy.new_from_elasticsearch_rails(@response, ...)
```

### Active Mode

If you want Pagy to control the pagination, getting the page from the params, and returning both the `Pagy` and the `Elasticsearch::Model::Response::Response` objects automatically (from the backend params):

Extend your model:

```ruby
extend Pagy::ElasticsearchRails
```

In a controller use `pagy_search` in place of `search`:

```ruby
response         = Article.pagy_search(params[:q])
@pagy, @response = pagy_elasticsearch_rails(response, items: 10)
```

## Files

- [elasticsearch_rails.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/elasticsearch_rails.rb)

## Passive Mode

### Pagy.new_from_elasticsearch_rails(response, ...)

This constructor accepts an `Elasticsearch::Model::Response::Response` as the first argument, plus the usual optional variable hash. It sets the `:items`, `:page` and `:count` pagy variables extracted/calculated out of the `Elasticsearch::Model::Response::Response` object.

```ruby
@response = Model.search('*', from: 0, size: 10, ...)
@pagy     = Pagy.new_from_elasticsearch_rails(@response, ...)
```

**Notice**: you have to take care of manually manage all the params for your search, however the method extracts/calculates the `:items`, `:page` and `:count` from the response object, so you don't need to pass that again. If you prefer to manage the pagination automatically, see below.

## Active mode

### Pagy::ElasticsearchRails module

Extend your model with the `Pagy::ElasticsearchRails` micro-module:

```ruby
extend Pagy::ElasticsearchRails
```

The `Pagy::ElasticsearchRails` adds the `pagy_search` class method that you must use in place of the standard `search` method when you want to paginate the search response.

#### pagy_search(...)

This method accepts the same arguments of the `search` method and you must use it in its place. This extra uses it in order to capture the arguments, automatically merging the calculated `:from` and `:size` options before passing them to the standard `search` method internally.

### Variables

| Variable                             | Description                            | Default      |
|:-------------------------------------|:---------------------------------------|:-------------|
| `:elasticsearch_rails_search_method` | customizable name of the search method | :pagy_search |

### Methods

This extra adds the `pagy_elasticsearch_rails` method to the `Pagy::Backend` to be used when you have to paginate a `ElasticsearchRails` object. It also adds a `pagy_elasticsearch_rails_get_variables` sub-method, used for easy customization of variables by overriding.

#### pagy_elasticsearch_rails(pagy_search_args, vars = {}})

This method is similar to the generic `pagy` method, but specialized for Elasticsearch Rails. (see the [pagy doc](../api/backend.md#pagycollection-varsnil))

It expects to receive a `Model.pagy_search(...)` result as the first argument and an optional hash of variables. It returns a paginated response. 

You can use it in a couple of ways:

```ruby
@pagy, @response = pagy_elasticsearch_rails(Model.pagy_search(params[:q]), ...)
...
records = @response.records
results = @response.results

# or directly with the collection you need (e.g. records)
@pagy, @records = pagy_elasticsearch_rails(Model.pagy_search(params[:q]).records, ...)
```

### pagy_elasticsearch_rails_get_vars(array)

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_elasticsearch_rails` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).
