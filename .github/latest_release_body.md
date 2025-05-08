<!-- whats_new_start -->

<a href="https://ddnexus.github.io/pagy/sandbox/playground/#demo-app">
  <img src="https://github.com/ddnexus/pagy/raw/dev/assets/images/try-it.svg" width="130">
</a><br><br>

## Version 43.0.0 (leap)

We needed a leap version to unequivocally segnaling that it's not just a major version: it's a complete redesign of the legacy
code at all levels, usage and API included.

**Why 43?** Because it's exactly one step beyond _"The answer to the ultimate question of life, the Universe, and everything."_ 😉

#### Improvements

- **New [Keynav](https://ddnexus.github.io/pagy/toolbox/paginators/keynav_js) Pagination**
  - The pagy-exclusive technique using the fastest [keyset](https://ddnexus.github.io/pagy/toolbox/paginators/keyset) pagination alongside all frontend helpers.
- **New interactive dev-tools**
  - New [PagyWand](https://ddnexus.github.io/pagy/resources/stylesheets/#pagy-wand) to integrate the pagy CSS with your app's themes.
  - New **Pagy AI** available inside docs and your own app.
- **Intelligent automation**
  - [Configuration](https://ddnexus.github.io/pagy/resources/initializer/) requirements reduced by 99%.
  - Simplified [JavaScript](https://ddnexus.github.io/pagy/resources/javascript) setup.
  - Automatic [I18n](https://ddnexus.github.io/pagy/resources/i18n) loading.
- **[Simpler API](https://github.com/ddnexus/pagy#examples)**
  - You solely need the [pagy](https://ddnexus.github.io/pagy/toolbox/paginators) method and the [@pagy](https://ddnexus.github.io/pagy/toolbox/helpers) instance to paginate any collection and
    use any navigation tag and helper.
  - Methods are autoloaded only if used and consume no memory otherwise.
  - Methods have narrower scopes and can be [overridden](https://ddnexus.github.io/pagy/guides/how-to#override-pagy-methods) without deep knowledge.
- **New [documentation](https://ddnexus.github.io/pagy/guides/quick-start)**
  - Very concise, straightforward, easy to navigate and understand.

Take a look at the [Examples](https://github.com/ddnexus/pagy#examples) for a quick overview.
<!-- whats_new_end -->

### Changes in 43.0.0

<!-- changes_start -->
- **The Countless pagination remembers the last page**
  - Pagination navs now allow jumping forward after navigating back a few pages.
- **Javascript refactoring**
  - The new `Pagy.sync_javascript` function used in the `pagy.js` initializer, avoids complicated configurations.
  - Added the plain `pagy.js` and relative source map files.
- **I18n refactoring**
  - No setup required: the locales and their pluralization are autoloaded when your app uses them.
  - The locale files are easier to override with `Pagy::I18n.pathnames << my_dictionaries`.
- **HTML and CSS refactoring**
  - Stylesheets are now based on CSS properties and calculations, for easer customizstion.
  - The new PagyWand interactive tool generates the CSS Override for your custom styles and provides live feedback right in your
    app.
- **Playground apps**
  - Better usability and styles
- **Boostrap and Bulma**
  - Fixed a few style glitches.
<!-- changes_end -->

[CHANGELOG](https://ddnexus.github.io/pagy/changelog)
