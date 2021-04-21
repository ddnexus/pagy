# CHANGELOG

## Version 4.4.0

### Changes

- All the public helpers accept optional keyword arguments, for example:
  - `pagy*_nav(@pagy, pagy_id: 'my-id', link-extra: '...')`
  - `pagy*_nav_js(@pagy, pagy_id: 'my-id', link-extra: '...', steps: {...})`
  - `pagy*_combo_nav_js(@pagy, pagy_id: 'my-id', link-extra: '...')`
  - `pagy_items_selector_js(pagy, pagy_id: 'my-id', item_name: '...', i18n_key: '...')`
  - `pagy_info(@pagy, item_name: '...', i18n_key: '...')`
  - `pagy_prev_link(@pagy, text: '...', link_extra: '...')`
  - `pagy_next_link(@pagy, text: '...', link_extra: '...')`
  - passing positional arguments (besides `@pagy`) to the public helpers is deprecated and it will be supported only until pagy 5.0 (with the exception is the internal `pagy_url_for` and `pagy_link_proc` methods that will keep using positional arguments)
- Changed the argument order of `pagy_url_for(page, pagy)` to `pagy_url_for(pagy, page)` for consistency with the rest of the helpers. The legacy usage, has been deprecated and supported only until pagy 5.0.

## Version 4.3.0

### Changes

- Improved efficiency of #series algorithm
- Added new features to the trim extra
- Added rubocop compliance (additional rubocop-packaging plugin)
- Many test tasks improvements
- CI transition from Travis to Github Action

### Commits

- [80cef45](http://github.com/ddnexus/pagy/commit/80cef45): updated Gemfile
- [3cc464b](http://github.com/ddnexus/pagy/commit/3cc464b): added coverage_summary at the end of the default task; added possibility of creating a coverage report
- [0424b71](http://github.com/ddnexus/pagy/commit/0424b71): docs and comment additions/fixes [skip ci]
- [b6115e7](http://github.com/ddnexus/pagy/commit/b6115e7): Added explicit pagy.manifest to comply with rubocop-packaging (see also #297)
- [ef1980e](http://github.com/ddnexus/pagy/commit/ef1980e): refactoring of CI from Travis to Github Actions
- [9fb1195](http://github.com/ddnexus/pagy/commit/9fb1195): more verbose condition
- [fe565eb](http://github.com/ddnexus/pagy/commit/fe565eb): removed RUN_RUBOCOP
- [60be542](http://github.com/ddnexus/pagy/commit/60be542): fix missing codecov formatter/circular reference problem
- [8c4ccfc](http://github.com/ddnexus/pagy/commit/8c4ccfc): rubocop: added rubocop-packaging plugin; expanded inclusion of files
- [487eb70](http://github.com/ddnexus/pagy/commit/487eb70): small code normalization
- [3ea2d27](http://github.com/ddnexus/pagy/commit/3ea2d27): codecov gets already required in travis on ruby 3.0 (but not locally)
- [e17d294](http://github.com/ddnexus/pagy/commit/e17d294): improved series algorithm efficiency (now up to ~5x faster and ~2.3x lighter than the previous one)
- [1051e6d](http://github.com/ddnexus/pagy/commit/1051e6d): trim feature: added :trim variable to opt-out to trim even with the trim extra loaded, or invert the logic to out-in by setting Pagy::VARS[:trim] to false
- [ece4daa](http://github.com/ddnexus/pagy/commit/ece4daa): minor code restyling
- [0e3a09d](http://github.com/ddnexus/pagy/commit/0e3a09d): added :ide_development bundle group; small README changes
- [5e6f749](http://github.com/ddnexus/pagy/commit/5e6f749): simpler test tasks
- [e5ee4e7](http://github.com/ddnexus/pagy/commit/e5ee4e7): CI: Remove Bundler 1.x workaround (#296)The "github" source now has that form, already.

## Version 4.2.0

### Changes

- Fix for `Pagy::Frontend::I18n` conflicting with rthe `I18n` gem namespace after inclusion and safer renaming of other modules
- Fix the simplecov setup reporting less coverage than what's actually covered
- Updated Tailwind styles
- Included the test dir in the coverage check, refactoring and additions of tests
- Big code restyling following ruby 3.0 syntax and cops; tried to make the code simpler, more readable and verbose with almost negligible performance loss.

### Commits

- [a62ae94](http://github.com/ddnexus/pagy/commit/a62ae94): Updated README
- [9efb908](http://github.com/ddnexus/pagy/commit/9efb908): removed ENABLE_OJ from tests and travis config
- [dede255](http://github.com/ddnexus/pagy/commit/dede255): removed RUN_SIMPLECOV option
- [fc614bd](http://github.com/ddnexus/pagy/commit/fc614bd): fix/refactoring for simplecov setup reporting less coverage than what's actually covered
- [5e6ecf1](http://github.com/ddnexus/pagy/commit/5e6ecf1): refactoring of Rakefile
- [aea25a1](http://github.com/ddnexus/pagy/commit/aea25a1): code-restyling: test
- [cb67353](http://github.com/ddnexus/pagy/commit/cb67353): code-restyling: extras
- [b2dc35a](http://github.com/ddnexus/pagy/commit/b2dc35a): code-restyling: locales, config
- [b638764](http://github.com/ddnexus/pagy/commit/b638764): code-restyling: root files and Pagy Core
- [aac54aa](http://github.com/ddnexus/pagy/commit/aac54aa): Renaming prepended modules with more specific and safe naming convention (see Issue #290 PR #293)
- [3eef450](http://github.com/ddnexus/pagy/commit/3eef450): Simpler test for I18n namespace conflict
- [b2aaa01](http://github.com/ddnexus/pagy/commit/b2aaa01): README: fix typo (#289) [ci-skip]
- [3a9e70f](http://github.com/ddnexus/pagy/commit/3a9e70f): Fix extra i18n namespacing (#293)* Add a test that looks at i18n working in Modules included (fixes #290)
- [8cd25d2](http://github.com/ddnexus/pagy/commit/8cd25d2): renamed docker > pagy-on-docker
- [a8060b1](http://github.com/ddnexus/pagy/commit/a8060b1): fixed doc typos
- [f0e0d41](http://github.com/ddnexus/pagy/commit/f0e0d41): removed require for minitest/reporters
- [c178c6f](http://github.com/ddnexus/pagy/commit/c178c6f): docker README fixes [ci-skip]
- [ac988fd](http://github.com/ddnexus/pagy/commit/ac988fd): docs fixes
- [4d20d34](http://github.com/ddnexus/pagy/commit/4d20d34): Update Tailwind styles (#285)
- [9a14400](http://github.com/ddnexus/pagy/commit/9a14400): Small README addition [ci-skip]
- [9b40cdd](http://github.com/ddnexus/pagy/commit/9b40cdd): Update frontend.md (#284) [ci-skip]
- [2bbf204](http://github.com/ddnexus/pagy/commit/2bbf204): added Mike Rogers' screencast [ci-skip]
- [b24b86d](http://github.com/ddnexus/pagy/commit/b24b86d): Added note for brakeman false positive warnings (closes #243) [ci-skip]
- [df3c8d6](http://github.com/ddnexus/pagy/commit/df3c8d6): small syntax normalization
- [618d226](http://github.com/ddnexus/pagy/commit/618d226): docker README fix [ci-skip]

## Version 4.1.0

### Changes

- added Bosnian, Croatian and Serbian locales

### Commits

- [8da0e06](http://github.com/ddnexus/pagy/commit/8da0e06): Add Serbian locale (#283)
- [dcfc659](http://github.com/ddnexus/pagy/commit/dcfc659): Add locales for Bosnian and Croatian language (#281)

## Version 4.0.0

### Breaking Changes

- renamed `Pagy::Search` as `Pagy::Searchkick` or `Pagy::ElasticsearchRails`

### Changes

- Dropped support for all jruby versions and ruby version <3.0 (use pagy 3.x instead)
- Dropped deprecation for old/renamed locales
- Fixed error in searchkik extra with ruby 3
- Various refactorings taking advantage of the dropped support for old ruby versions

### Commits

- [4d48d33](http://github.com/ddnexus/pagy/commit/4d48d33): refactoring of pagy_json_tag
- [745e68f](http://github.com/ddnexus/pagy/commit/745e68f): minor fixes for docker
- [296f060](http://github.com/ddnexus/pagy/commit/296f060): added pagy_search name customization to elasticsearch extras
- [98a5254](http://github.com/ddnexus/pagy/commit/98a5254): refactoring of the elasticsearch_rails extra matching the actual params of the search method
- [6966fe3](http://github.com/ddnexus/pagy/commit/6966fe3): refactoring of elasticsearch extras
- [aecb565](http://github.com/ddnexus/pagy/commit/aecb565): normalization of i18n naming
- [b3f78b8](http://github.com/ddnexus/pagy/commit/b3f78b8): refactoring of items extra using module prepend instead alias method chaining and module_eval; refactoring of tests (countless was masking failures of elasticsearch extras)
- [8ec7893](http://github.com/ddnexus/pagy/commit/8ec7893): refactoring of trim extra using module prepend instead alias method chaining
- [05d9e92](http://github.com/ddnexus/pagy/commit/05d9e92): used ruby 3.0 syntax
- [f1d89a5](http://github.com/ddnexus/pagy/commit/f1d89a5): refactoring of I18n extra using module prepend instead alias method chaining
- [df8607e](http://github.com/ddnexus/pagy/commit/df8607e): refactoring of overflow extra using module prepend instead alias method chaining
- [c361293](http://github.com/ddnexus/pagy/commit/c361293): Gemfile: uncommented performance group
- [66e29d1](http://github.com/ddnexus/pagy/commit/66e29d1): fixes for the docker README
- [2a343ce](http://github.com/ddnexus/pagy/commit/2a343ce): added README note about versions
- [dadd2f1](http://github.com/ddnexus/pagy/commit/dadd2f1): ruby 3.0 syntax
- [ce1d7ec](http://github.com/ddnexus/pagy/commit/ce1d7ec): removed legacy I18n compatibility
- [6751412](http://github.com/ddnexus/pagy/commit/6751412): added a few env variables in order to control the verbosity of tests; added test for negative page number
- [3eac56b](http://github.com/ddnexus/pagy/commit/3eac56b): removed unused Hash additional methods
- [24ab5c6](http://github.com/ddnexus/pagy/commit/24ab5c6): simpler travis setup
- [ba100dc](http://github.com/ddnexus/pagy/commit/ba100dc): updated documentation
- [5d53043](http://github.com/ddnexus/pagy/commit/5d53043): emptied CHANGELOG and dropped LEGACY_CHANGELOG
- [33c467a](http://github.com/ddnexus/pagy/commit/33c467a): removed MARK constant
- [49040fb](http://github.com/ddnexus/pagy/commit/49040fb): removed EMPTY constant used for legacy compatibility with frozen_string_literal
- [b826f61](http://github.com/ddnexus/pagy/commit/b826f61): updated rubocop and fixed offending lines
- [f075337](http://github.com/ddnexus/pagy/commit/f075337): removed deprecated locales
- [a70881a](http://github.com/ddnexus/pagy/commit/a70881a): updated version to 4.0.0
- [4676788](http://github.com/ddnexus/pagy/commit/4676788): updated docker environment for pagy 4
- [4a85efe](http://github.com/ddnexus/pagy/commit/4a85efe): updated gemfile and gemspec for pagy 4
- [fcaab88](http://github.com/ddnexus/pagy/commit/fcaab88): updated gemfile and gemspec
- [467b985](http://github.com/ddnexus/pagy/commit/467b985): added docker development environment
