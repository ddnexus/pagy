---
title: Keyset For UI
categories:
  - Backend
  - Extra
---

# Keyset For UI Extra

Paginate with the [Pagy Keyset For UI](/docs/api/keyset_for_ui) pagination technique, supporting `pagy_*nav`
and other Frontend helpers.

!!!warning Experimental: the API might change in minor versions
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Overview

This is a wrapper around the [Pagy::Keyset::Augmented API](/docs/api/keyset_for_ui.md). Please refer to the following resources:

[!ref Keyset For UI: Documentation](/docs/api/keyset_for_ui.md)

[!ref Keyset Pagination: Concepts and Overview](/docs/api/keyset.md)

This extra adds a `pagy_keyset_for_ui` constructor method that can be used in your controllers, and provides the automatic setting
of the variables from the request `params`.

## Synopsis

This section integrates the [Keyset Extra Synopsis](/docs/extras/keyset.md)

```ruby Controller (action)
# Basic defaults (uses the session object as the cache)
@pagy, @records = pagy_keyset_for_ui(set)

# Other variables
@pagy, @records = pagy_keyset_for_ui(set, **vars)
```

## Methods

=== `pagy_keyset_for_ui(set, **vars)`

This method is similar to the `pagy` (for offset pagination) method. It returns the `pagy` object and the array of `records`
pulled from the DB.

===
