---
title: API
---
# API

The public API of Pagy is composed by 3 groups of modules:

## Core modules

The low level structure needed for standard usage. It's composed of just one class and two modules:

- The [Pagy](api/pagy.md) core class that implements the pagination logic
- The [Pagy::Backend](api/backend.md) module to include in your controllers
- The [Pagy::Frontend](api/frontend.md) module to include in your helpers

## Support modules/classes

These modules/classes provide support for special environments or features that go beyond the standard usage:

- The [Pagy::Calendar](api/calendar.md) subclass that that paginates the collection by calendar units (year, month, week or day) used by the [calendar](extras/calendar.md) extra. (It saves one count query per request).
- The [Pagy::Countless](api/countless.md) subclass that provides the pagination without a count used by the [countless](extras/countless.md) extra. (It saves one count query per request).
- The [Pagy::Console](api/console.md) module that provides easy interaction with pagy in the IRB/rails console
- The [Pagy::I18n](api/i18n.md) module that provides multi-language translation of the pagy strings

## Extras

Pagy provides also a growing number of optional extensions/extras that can handle special features, collections or environments. See the [extras](extras.md) doc for the full list.
