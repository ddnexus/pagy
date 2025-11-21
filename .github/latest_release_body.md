### Changes in 43.1.1

<!-- changes_start -->
- Makes keynav pagination compatible with nested params:
  - Improve the URL composing and unescaping
  - Adds the keynav+root_key.ru showcase app
- Simplify the request code and arguments
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)

<!-- whats_new_start -->

<a href="https://ddnexus.github.io/pagy/sandbox/playground/#demo-app">
  <img src="https://github.com/ddnexus/pagy/raw/dev/assets/images/try-it.svg" width="130">
</a><br><br>

## Version 43

We needed a leap version to unequivocally signaling that it's not just a major version: it's a complete redesign of the legacy
code at all levels, usage and API included.

**Why 43?** Because it's exactly one step beyond _"The answer to the ultimate question of life, the Universe, and everything."_ 😉

#### Improvements

This version introduces several enhancements, such as new pagination techniques like Keynav and improved automation and
configuration processes, reducing setup requirements by 99%. The update also includes a simpler API and new interactive
development tools, making it a comprehensive upgrade from previous versions.

- **New [Keynav](https://ddnexus.github.io/pagy/toolbox/paginators/keynav_js) Pagination**
  - The pagy-exclusive technique using the fastest [keyset](https://ddnexus.github.io/pagy/toolbox/paginators/keyset)
    pagination alongside all frontend helpers.
- **New interactive dev-tools**
  - New [PagyWand](https://ddnexus.github.io/pagy/resources/stylesheets/#pagy-wand) to integrate the pagy CSS with your app's
    themes.
  - New **Pagy AI** available inside docs and your own app.
- **Intelligent automation**
  - [Configuration](https://ddnexus.github.io/pagy/resources/initializer/) requirements reduced by 99%.
  - Simplified [JavaScript](https://ddnexus.github.io/pagy/resources/javascript) setup.
  - Automatic [I18n](https://ddnexus.github.io/pagy/resources/i18n) loading.
- **[Simpler API](https://github.com/ddnexus/pagy#examples)**
  - You solely need the [pagy](https://ddnexus.github.io/pagy/toolbox/paginators) method and
    the [@pagy](https://ddnexus.github.io/pagy/toolbox/helpers) instance to paginate any collection and use any navigation tag
    and helper.
  - Methods are autoloaded only if used, and consume no memory otherwise.
  - Methods have narrower scopes and can be [overridden](https://ddnexus.github.io/pagy/guides/how-to#override-pagy-methods)
    without deep knowledge.
- **New [documentation](https://ddnexus.github.io/pagy/guides/quick-start)**
  - Very concise, straightforward, and easy to navigate and understand.

### Upgrade to 43

See the [Upgrade Guide](https://ddnexus.github.io/pagy/guides/upgrade-guide/)

<!-- whats_new_end -->
