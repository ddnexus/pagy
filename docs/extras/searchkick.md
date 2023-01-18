---
title: Searchkick
categories:
- Search
- Backend
- Extra
---

# Searchkick Extra

Paginate `Searchkick::Results` objects.

## Synopsis

## Setup

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/searchkick'
Searchkick.extend Pagy::Searchkick
```
|||

## Modes

This extra offers two ways to paginate `Searchkick::Results` objects:

+++ Active mode

!!! success Pagy searches and paginates
You use the `pagy_search` method in place of the `search` method.
!!!

### Usage

||| Model
```ruby
extend Pagy::Searchkick
```
|||

||| Controller (pagy_search)
```ruby
# single model
collection = Article.pagy_search(params[:q])
# multi models
collection = Searchkick.pagy_search(params[:q], models: [Article, Categories])
# paginate it
@pagy, @response = pagy_searchkick(collection, items: 10)
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
@results = Article.search('*', page: 1, per_page: 10, ...)
# get the pagy object out of it
@pagy = Pagy.new_from_searchkick(@results, ...)
```
|||

+++

## Files

- [searchkick.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/searchkick.rb)

## Variables

| Variable                  | Description                                     | Default        |
|:--------------------------|:------------------------------------------------|:---------------|
| `:searchkick_pagy_search` | customizable name of the pagy search method     | `:pagy_search` |
| `:searchkick_search`      | customizable name of the original search method | `:search`      |

## Methods

==- `Pagy::Searchkick.pagy_search(...)`

This method accepts the same arguments of the `search` method and you must use it in its place in active mode.

==- `Pagy.new_from_searchkick(results, vars={})`

This constructor accepts a `Searchkick::Results` as the first argument, plus the optional pagy variables. It automatically sets the `:items`, `:page` and `:count` pagy variables extracted/calculated out of it.

==- `pagy_searchkick(pagy_search_args, vars={})`

This method is similar to the generic `pagy` method, but specialized for Searchkick. (see the [pagy doc](/docs/api/backend.md#pagy-collection-vars-nil))

It expects to receive `YourModel.pagy_search(...)` result and returns the paginated response.

==- `pagy_searchkick_get_vars(array)`

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_searchkick` method. (see the [pagy_get_vars doc](/docs/api/backend.md#pagy-get-vars-collection-vars)).

===
