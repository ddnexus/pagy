---
label: "Pagy.✳ Configurators"
icon: gear
order: 100
---

#

## Pagy.<span style="font-size: .65em; vertical-align: middle">✳</span> Configurators

---

Pagy provides a few class methods to handle general configuration at different levels.

### Configurators

==- Pagy.options

The options at the Pagy's global level. See [Inheritable options](#inheritable-options)

==- Pagy.sync_javascript

This method makes the Pagy JavaScript files available to apps with a builder (e.g., esbuild, Webpack, jsbundling-rails, etc.). See [JavaScript](../resources/javascript/#2-make-the-file-available-to-your-app) and the [Initializer File](#initializer-file) below for details.

==- Pagy::I18n.pathnames

This method allows the overriding of the `Pagy::I18n` Lookup. See [Customizing Dictionaries](../resources/i18n/#customizing-dictionaries) and the [Initializer File](#initializer-file) below for details.

==- Pagy.translate_with_the_slower_i18n_gem!

This method allows translating pagy with the `i18n` gem instead of its faster `Pagy::I18n.translate` method. See [I18n](../resources/i18n/#using-the-i18n-gem) for details.

==- Pagy::Calendar.localize_with_rails_i18n_gem

This method allows the Calendar Localization for non-en locales.  See the [Calendar localization](paginators/calendar/#localization) and the [Initializer File](#initializer-file) below for details.

===


### Inheritable Options

Pagy has an inheritable options system that allows you to set and override options at three different levels:

1. **Global level**
- `Pagy.options` (set in the initializer)
- The `Pagy.options` are inherited by all paginators, instances, and helpers.
2. **Paginator level**
- e.g.: `pagy(paginator, collection, **options)`
- The options passed to the paginator override the `Pagy.options` and are inherited by the `@pagy` instance.
3. **Helper level**
- e.g.: `@pagy.series_nav(**options)`
- The options passed to the istance helper methods override all other options.

!!!success

- **Keep options local**
  - For clarity, set options as close as possible to where they're needed/used.
- **Widen options when needed**
  - Use higher-level options when they conveniently affect broader scopes.
!!!

### Initializer file

Download or copy the small file below and ensure it loads _(e.g., save it into the Rails `config/initializers` directory or require it)_. Read its comments for details.

[!file pagy.rb](../gem/config/pagy.rb)

:::code source="../gem/config/pagy.rb" title="pagy.rb":::
