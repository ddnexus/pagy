# CHANGELOG

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
