#

## :icon-sliders:&nbsp;&nbsp;Options Hierarchy

---

!!! This page documents the options hierarchy
The actual options are documented alongside the [paginators](../paginators) and [helpers](../helpers) that consume them.
!!!

Pagy implements a hierarchical options system working at three different levels, regardless where the option gets consumed.

### Levels

>>> Global

- For example `Pagy::OPTIONS[:limit] = 10` set in the [pagy.rb initializer](initializer).
- The `Pagy::OPTIONS` are inherited by all paginators and helpers.
- **IMPORTANT**: Freeze it after you are done in the initializer, for good safe practice.

>>> Paginator

- For example `pagy(paginator, collection, **options)`.
- The options passed to a paginator override the `Pagy::OPTIONS` for that instance.
- They are also inherited by all the helpers used by the instance.

>>> Helper

- For example `@pagy.series_nav(**options)`.
- The options passed to a helper override the options affecting its output.
- The options consumed upstream are not affected.

>>>

!!!success
- **Keep options local**
  - For clarity, set options as close to where they're consumed as possible.
- **Widen the scope when needed**
  - Use higher-level options when they conveniently affect broader scopes.
!!!
