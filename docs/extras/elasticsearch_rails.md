---
title: Elasticsearch Rails
categories: 
- Backend Extras
- Search Extras
---

# Elasticsearch Rails Extra

Paginate `ElasticsearchRails` response objects.

## Setup

See [extras](/docs/extras.md) for general usage info.

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/elasticsearch_rails'
```
|||

## Modes

This extra offers two ways to paginate `ElasticsearchRails` response objects:

+++ Active mode

!!! success
Get the paginated `Response` object from your search
!!!

### Usage

Extend your model with the `Pagy::ElasticsearchRails` micro-module:

||| Model
```ruby
extend Pagy::ElasticsearchRails
```
|||

Use the `pagy_search` method in place of the standard `search` method when you want to paginate the search response:

||| Controller
```ruby
# get the collection in one of the following ways
collection = Article.pagy_search(params[:q])
collection = Article.pagy_search(params[:q]).records
collection = Article.pagy_search(params[:q]).results
# paginate it
@pagy, @response = pagy_elasticsearch_rails(collection, items: 10)
```
|||

!!!
This mode calculates the `:from` and `:size` options and internally uses the standard `search` method.
!!!

+++ Passive mode

!!! success 
Get the `Pagy` object out of a standard `Response` object
!!!

### Usage

||| Controller
```ruby
# standard response (already paginated)
@response = Model.search('*', from: 0, size: 10, ...)
# get the pagy object out of it
@pagy = Pagy.new_from_elasticsearch_rails(@response, ...)
```
|||

The `Pagy.new_from_elasticsearch_rails(response, ...)` constructor accepts an `Elasticsearch::Model::Response::Response` as the first argument, plus the usual optional variable hash. It sets the `:items`, `:page` and `:count` pagy variables extracted/calculated out of the `Elasticsearch::Model::Response::Response` object.

!!! info
You have to take care of manually manage all the params for your search, however the method extracts/calculates the `:items`, `:page` and `:count` from the response object, so you don't need to pass that again.
!!!

+++

## Files

- [elasticsearch_rails.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/elasticsearch_rails.rb)

### Variables

| Variable                           | Description                                     | Default      |
|:-----------------------------------|:------------------------------------------------|:-------------|
| `:elasticsearch_rails_pagy_search` | customizable name of the pagy search method     | :pagy_search |
| `:elasticsearch_rails_search`      | customizable name of the original search method | :search      |

### Methods

This extra adds the `pagy_elasticsearch_rails` method to the `Pagy::Backend` to be used when you have to paginate a `ElasticsearchRails` object. It also adds a `pagy_elasticsearch_rails_get_variables` sub-method, used for easy customization of variables by overriding.

#### pagy_elasticsearch_rails(pagy_search_args, vars = \{\})

This method is similar to the generic `pagy` method, but specialized for Elasticsearch Rails (see the [pagy doc](/docs/api/backend.md#pagycollection-varsnil)).

It expects to receive a result from `Model.pagy_search(...)` as the first argument and an optional hash of variables. It returns a paginated response. 

#### pagy_elasticsearch_rails_get_vars(array)

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_elasticsearch_rails` method. (see the [pagy_get_vars doc](/docs/api/backend.md#pagy_get_varscollection-vars)).

### Pagy::ElasticsearchRails module

The `Pagy::ElasticsearchRails` adds the `pagy_search` class method that accepts the same arguments of the `search` method and you must use it in its place when you want to paginate the search response.
