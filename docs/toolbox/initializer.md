---
label: pagy 💚 Initializer
icon: gear
order: 100
---

#

## <span style="font-size: .65em; vertical-align: middle">💚</span> Initializer

---

You can use the initializer to configure pagy for your app.

### Inheritable Options

Pagy has an inheritable options system that allows you to set and override options at three different levels:

1. **Global level** 
    - `Pagy.options` (set in the initializer)
    - The `Pagy.options` are inherited by all paginators, instances, and methods.
2. **Paginator level** 
    - e.g.: `pagy(paginator, collection, **options)`
    - The options passed to the paginator override the `Pagy.options` and are inherited by the `@pagy` instance.
3. **Methods level** 
    - e.g.: `@pagy.series_nav(**options)`
    - The options passed to the methods override all other options.

!!!success

- **Keep options local**
  - For clarity, set options as close as possible to where they're used.
- **Widen options when needed**
  - Use higher-level options when they conveniently affect broader scopes.
!!!

### Initializer file

Download or copy the small file below and ensure it loads _(e.g., save it into the Rails `config/initializers` directory or require it)_. Read its comments for details.

[!file pagy.rb](../gem/config/pagy.rb)

:::code source="../gem/config/pagy.rb" title="pagy.rb":::
