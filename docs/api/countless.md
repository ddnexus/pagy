---
title: Pagy::Countless
category:
  - Feature
  - Class
---

# Pagy::Countless

This is a `Pagy` subclass that provides pagination without the need of any `:count`.

That may be especially useful in the following scenarios:

- slow `COUNT(*)` query - result of large tables or poorly optimized DBs
- large collections of records where the count is missing or irrelevant
- minimalistic UI, infinite scrolling, APIs that don't benefit from a nav-bar
- when the full nav-bar is not a requirement and/or performance is more desirable

This class provides support for extras that don't need the full set of pagination support or need to avoid the `:count` variable (
e.g. the [countless extra](/docs/extras/countless.md)). The class API is documented here, however you should not need to use this
class directly because it is required and used internally by the extra.

## Caveats

In this class the `:count` variable is always `nil`, hence some feature that depends on it may have limited or no support:

### Features with limited support

#### Nav bar

The nav bar links after the current page cannot be fully displayed because they depends on the `count`.

Regardless the actual `:size` value we know only if the next page exists and we don't know the total pages

The `series` method reflects on the above.

#### :overflow variable

The available values for the `:overflow` variable are `:empty_page` and `:exception`, missing the `:last_page` (which is not known
in case of an exception).

### Features without support

The `pagy_info` and all the `*_combo_nav_js` helpers that use the total `count` are not supported.

## How countless pagination works

Instead of basing all the internal calculations on the `:count` variable (passed with the constructor), this class uses the number
of actually fetched records to derive the pagination variables.

The size of the fetched records can be passed in a second step to the `finalize` method, which allows pagy to determine if there is
a `next` page, or if the current page is the `last` page, or if the current request should raise a `Pagy::OverflowError`
exception.

Retrieving these variables may be useful to supply a UI as complete as possible, when used with classic helpers, and can be
skipped when it's not needed (like for navless pagination, infinite-scroll, etc.). See
the [countless extra](/docs/extras/countless.md) for more details.

## Methods

The construction of the final `Pagy::Countless` object is split into 2 steps: the regular `initialize` method and the `finalize`
method, which will use the fetched size to calculate the rest of the pagination integers.

==- `Pagy::Countless.new(**vars)`

The initial constructor takes the usual hash of variables, calculating only the requested `limit` and the `offset`, needed to
query the page of records.

==- `finalize(fetched_size)`

The actual calculation of all the internal variables for the pagination is calculated using the fetched size. The
method returns the finalized instance object.

===
