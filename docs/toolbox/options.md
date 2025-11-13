---
label: "Options ✳"
icon: sliders
order: 70
---

#

## Options Hierarchy

---

!!! This page documents the options system

The actual options are documented alongside the [paginators](paginators) and [helpers](helpers) that use them.
!!!

Pagy has a top-down hierarchical options system that allows you to set and override options at different levels.

#### Global level

- For example `Pagy.options[:limit] = 10`.
- Set in the [pagy.rb initializer](../resources/initializer).
- The `Pagy.options` are inherited by all paginators and helpers.
- You can set all kinds of options at the global level, no matter which is the destination downstream (i.e., paginator or helper).

#### Paginator level

- For example `pagy(paginator, collection, **options)`.
- The options passed to a paginator override the `Pagy.options` set upstream for that instance. 

#### Helper level

- For example `@pagy.series_nav(**options)`.
- The options passed to a helper override all the upstream options for its output.
- The otions consumed upstream are not affected.

!!!success

- **Keep options local**
  - For clarity, set options as close as possible to where they're consumed.
- **Widen the scope when needed**
  - Use higher-level options when they conveniently affect broader scopes.
!!!
