---
title: Jsonapi
categories:
  - Feature
  - Backend
  - Extra
---

# Jsonapi Extra

Implements the [JSON:API](https://jsonapi.org) specifications for pagination.

When enabled, the query params used in the pagy URLs are nested under the `page` param, as specified by
the [Query Parameter Family](https://jsonapi.org/format/#query-parameters-families)
e.g. `https://example.com/products?page[number]=2&page[size]=30`.

## Synopsis

### Default usage

```ruby pagy.rb (initializer)
require 'pagy/extras/jsonapi' # works without further configuration
```

```ruby Controller
# enabled by default
@pagy, @records = pagy(collection)
# you can disable it explicitly for specific requests
@pagy, @records = pagy(collection, jsonapi: false)
```

### Custom usage

```ruby pagy.rb (initializer)
# optionally require other jsonapi-useful extras
require 'pagy/extras/items'
# jsonapi must be required AFTER other extras
require 'pagy/extras/jsonapi'
# optionally disable it by default (opt-in)
Pagy::DEFAULT[:jsonapi] = false               # default true
```

```ruby Controller
# disabled by default by the above Pagy::DEFAULT[:jsonapi] = false
@pagy, @records = pagy(collection)
# explicitly enable it for specific requests
@pagy, @records = pagy(collection, jsonapi: true)
# optional/custom setup
@pagy, @records = pagy(collection, jsonapi:      true,    # enable the jsonapi specifications
                                   items_extra:  true,    # enable the items extra
                                   page_param:   :number, # use page[number] param name instead of page[page]
                                   items_params: :size)   # use page[size] param name instead of page[items]
# get the links URL hash
links_hash = pagy_jsonapi_links(@pagy)
#=> {first: 'https://example.com/products?page[number]=1&page[size]=50&...',
#    last: 'https://example.com/products?page[number]=32&page[size]=50&...',
#    prev: 'https://example.com/products?page[number]=31&page[size]=50&...',
#    next: 'https://example.com/products?page[number]=33&page[size]=50&...'}
```

## Files

- [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/jsonapi.rb)

## Variables

| Variable   | Description                   | Default |
|:-----------|:------------------------------|:--------|
| `:jsonapi` | Enable or disable the feature | `true`  |

You can use the `:jsonapi` variable to opt-out of the feature even when the extra is required.

## Interaction with other features/extras

This extra just nests the `:page` and `:items` params under the JSON:API reserved `:page` param. You may want to customize
the `:page_param` and the `:items` params as shown in the [Synopsis](#synopsis).

You may also want to use it with the [items extra](/docs/extras/items.md) in order to allow the client to request a specific
number of items per page and capping it to a max number.

It works also with the [countless](countless.md), [searchkick](searchkick.md), [elasticsearch_rails](elasticsearch_rails.md)
and [meilisearch](/docs/extras/meilisearch.md) extras.

It does not make sense (and doesn't work) with the [Calendar](countless.md) extra.

## Methods

The `jsonapi` extra adds the `pagy_jsonapi_links` helper to the `Pagy::Backend` module.

=== `pagy_jsonapi_links(pagy, **opts)`

This helper provides the JSON:API [links for pagination](https://jsonapi.org/format/#fetching-pagination) as a hash
of `first`, `last`, `prev`, `next` paths. You can pass the option `asbsolute: true` to get an absolute URL instead.
