---
title: Pagy::Countless
---
# Pagy::Countless

This is a `Pagy` [subclass](https://github.com/ddnexus/pagy/blob/master/lib/pagy/countless.rb) that provides pagination without the need of any `:count`. That may be especially useful in the following scenarios:

 - slow `COUNT(*)` query - result of large tables or poorly optimized DBs
 - large collections of items where the count is missing or irrelevant
 - minimalistic UI, infinite scrolling, APIs that don't benefit from a nav-bar
 - when the full nav-bar is not a requirement and/or performance is more desirable

This class is providing support for extras that don't need the full set of pagination support or need to avoid the `:count` variable (e.g. the [countless](../extras/countless.md) extra). You should not need to use it directly because it is required and used internally.

## Caveats

In this class the `:count` variable is always `nil`, hence some feature that depends on it may have limited or no support:

### Features with limited support

#### Nav bar

The nav bar links after the current page cannot be fully displayed because a couple of items of the `:size` array depends on the `count`, so they have some limitations.

 Regardless the actual `:size` value:

- `vars[:size][2]` is capped at 1 (we know only if the next page exists)
- `vars[:size][3]` is set to 0 (we don't know the total pages)

A few examples:

- `[1,4,4,1]` would be treated like `[ 1,4,1,0]`
- `[1,4,3,4]` would be treated like `[ 1,4,1,0]`
- `[1,4,0,0]` would be treated like `[ 1,4,0,0]`

The `series` method reflects on the above.

#### :overflow variable

The available values for the `:overflow` variable are `:empty_page` and `:exception`, missing the `:last_page` (which is not known in case of an exception).

### Features without support

The `pagy_info` and all the `*_combo_nav_js` helpers that use the total `count` are not supported.

## How countless pagination works

Instead of basing all the internal calculations on the `:count` variable (passed with the constructor), this class uses the number of actually retrieved items to deduce the pagination variables.

The retrieved items number can be passed in a second step to the `finalize` method, which allows pagy to determine if there is a `next` page, or if the current page is the `last` page, or if the current request should raise a `Pagy::OverflowError` exception.
          
Retrieving these variables may be useful to supply a UI as complete as possible, when used with classic helpers, and can be skipped when it's not needed (like for navless pagination, infinite-scroll, etc.). See the [countless.rb extra](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb) for more details.

## Methods

The construction of the final `Pagy::Countless` object is split into 2 steps: the regular `initialize` method and the `finalize` method, which will use the retrieved items number to calculate the rest of the pagination integers.

### Pagy::Countless.new(vars)

The initial constructor takes the usual hash of variables, calculating only the requested `items` and the `offset`, useful to query the page of items.

### finalize(fetched)

The actual calculation of all the internal variables for the pagination is calculated using the number of `fetched` items. The method returns the finalized instance object.
