---
title: Elasticsearch Rails
categories: 
- Search
- Backend
- Extras
---

# Elasticsearch Rails Extra

Paginate `ElasticsearchRails` response objects.

## Setup

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/elasticsearch_rails'
```
|||

## Modes

This extra offers two ways to paginate `ElasticsearchRails` response objects.

+++ Active mode

!!! success Pagy searches and paginates
You use the `pagy_search` method in place of the `search` method.
!!!

### Usage

||| Model
```ruby
extend Pagy::ElasticsearchRails
```
|||

||| Controller (pagy_search)
```ruby
# get the collection in one of the following ways
collection = Article.pagy_search(params[:q])
collection = Article.pagy_search(params[:q]).records
collection = Article.pagy_search(params[:q]).results
# paginate it
@pagy, @response = pagy_elasticsearch_rails(collection, items: 10)
```
|||

+++ Passive mode

!!! success You search and paginate
Pagy creates its object out of your result.
!!!

### Usage

||| Controller (search)
```ruby
# standard response (already paginated)
@response = Article.search('*', from: 0, size: 10, ...)
# get the pagy object out of it
@pagy = Pagy.new_from_elasticsearch_rails(@response, ...)
```
|||

+++

## Files

- [elasticsearch_rails.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/elasticsearch_rails.rb)

## Variables

| Variable                           | Description                                     | Default      |
|:-----------------------------------|:------------------------------------------------|:-------------|
| `:elasticsearch_rails_pagy_search` | customizable name of the pagy search method     | :pagy_search |
| `:elasticsearch_rails_search`      | customizable name of the original search method | :search      |

## Methods

==- `Pagy::ElasticsearchRails.pagy_search(...)`

This method accepts the same arguments of the `search` method and you must use it in its place in active mode.

==- `Pagy.new_from_elasticsearch_rails(response, vars={})`

This constructor accepts an `Elasticsearch::Model::Response::Response`, plus the optional pagy variables. It automatically sets the `:items`, `:page` and `:count` pagy variables extracted/calculated out of it.

==- `pagy_elasticsearch_rails(pagy_search_args, vars={})`

This method is similar to the generic `pagy` method, but specialized for Elasticsearch Rails (see the [pagy doc](/docs/api/backend.md#pagy-collection-vars-nil)).

It expects to receive `YourModel.pagy_search(...)` result and returns the paginated response. 

==- `pagy_elasticsearch_rails_get_vars(array)`

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_elasticsearch_rails` method. (see the [pagy_get_vars doc](/docs/api/backend.md#pagy-get-vars-collection-vars)).

===
