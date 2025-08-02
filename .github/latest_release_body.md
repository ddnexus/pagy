<!-- whats_new_start -->

<a href="https://ddnexus.github.io/pagy-pre/sandbox/playground/#demo-app">
  <img src="https://github.com/ddnexus/pagy/raw/dev/assets/images/try-it.svg" width="130">
</a><br><br>

## Version 43.0.0.rc*

We needed a leap version to unequivocally signaling that it's not just a major version: it's a complete redesign of the legacy
code at all levels, usage and API included.

**Why 43?** Because it's exactly one step beyond _"The answer to the ultimate question of life, the Universe, and everything."_ 😉

#### Improvements

This version introduces several enhancements, such as new pagination techniques like Keynav and improved automation and
configuration processes, reducing setup requirements by 99%. The update also includes a simpler API and new interactive
development tools, making it a comprehensive upgrade from previous versions.

- **New [Keynav](https://ddnexus.github.io/pagy-pre/toolbox/paginators/keynav_js) Pagination**
  - The pagy-exclusive technique using the fastest [keyset](https://ddnexus.github.io/pagy-pre/toolbox/paginators/keyset)
    pagination alongside all frontend helpers.
- **New interactive dev-tools**
  - New [PagyWand](https://ddnexus.github.io/pagy-pre/resources/stylesheets/#pagy-wand) to integrate the pagy CSS with your app's
    themes.
  - New **Pagy AI** available inside docs and your own app.
- **Intelligent automation**
  - [Configuration](https://ddnexus.github.io/pagy-pre/resources/initializer/) requirements reduced by 99%.
  - Simplified [JavaScript](https://ddnexus.github.io/pagy-pre/resources/javascript) setup.
  - Automatic [I18n](https://ddnexus.github.io/pagy-pre/resources/i18n) loading.
- **[Simpler API](https://github.com/ddnexus/pagy#examples)**
  - You solely need the [pagy](https://ddnexus.github.io/pagy-pre/toolbox/paginators) method and
    the [@pagy](https://ddnexus.github.io/pagy-pre/toolbox/helpers) instance to paginate any collection and use any navigation tag
    and helper.
  - Methods are autoloaded only if used, and consume no memory otherwise.
  - Methods have narrower scopes and can be [overridden](https://ddnexus.github.io/pagy-pre/guides/how-to#override-pagy-methods)
    without deep knowledge.
- **New [documentation](https://ddnexus.github.io/pagy-pre/guides/quick-start)**
  - Very concise, straightforward, and easy to navigate and understand.

### Upgrade to 43

https://ddnexus.github.io/pagy-pre/guides/upgrade-guide/

<!-- whats_new_end -->

### Changes in 43.0.0.rc2

<!-- changes_start -->
- Version 43.0.0.rc2
- Update aria translation for Tamil (ta) locale (#788)
- Add Slovak localization (from 6aa3774d)
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
