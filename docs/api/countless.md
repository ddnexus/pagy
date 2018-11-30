---
title: Pagy::Countless
---
# Pagy::Countless

This is a `Pagy` [subclass](https://github.com/ddnexus/pagy/blob/master/lib/pagy/countless.rb) that provides pagination without the need of any `:count`. That may be especially useful for slow `COUNT(*)` query - result of large tables or poorly optimized DBs - or whenever you don't need the full set of pagination features.

This class is providing support for extras that don't need the full set of pagination support or need to avoid the `:count` variable (e.g. the [countless extra](../extras/countless.md)). You should not need to use it directly because it is required and used internally.

## Caveats

In this class the `:count` variable is always `nil`, hence some feature that depends on it can have limited or no support:

### Features with limited support

#### :size variable and series method

A couple if items of the `:size` array have some limitation. Regardless the actual `:size` value:

- `vars[:size][2]` is capped at 1
- `vars[:size][3]` is set to 0

A few examples:

- `[1,4,4,1]` would be treated like `[ 1,4,1,0]`
- `[1,4,3,4]` would be treated like `[ 1,4,1,0]`
- `[1,4,0,0]` would be treated like `[ 1,4,0,0]`

The `series` method reflects on the above.

#### :overflow variable

The available values for the `:overflow` variable are `:empty_page` and `:exception`, missing `:last_page`

### Features witout support

The `pagy_info` and all the `pagy_plain_compact_nav*` helpers are not supported.

## How countless pagination works

Instead of basing all the internal calculations on the `:count` variable (passed with the constructor), this class uses the number of actually retrieved items for the page (passed in a second step with the `finalize` method), in order to deduce if there is a `next` page, or if the current page is the `last` page, or if the current request should raise a `Pagy::OverflowError` exception.

The trick is retrieving `items + 1`, and using the resulting number to calculate the variables, while eventually removing the extra item from the result. (see the [countless.rb extra](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb))

## Methods

The construction of the `Pagy::Countless` object is splitted into 2 steps: the regular `initialize` method and the `finalize` method, which will use the retrieved items number to calculate the rest of the pagination integers.

### Pagy::Countless.new(vars)

The initial constructor takes the usual hash of variables, calculating only the requested `items` and the `offset`, useful to query the page of items.

### finalize(items)

The actual calculation of all the internal variables for the pagination is calculated using the `items` number argument. The method returns the finalized instance object.
