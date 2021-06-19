# CHANGELOG

## Version 4.9.0

### Changes

- added meilisearch extra
- docs fixes

### Commits

- [572ed78](http://github.com/ddnexus/pagy/commit/572ed78): updated pagy-ci.yml
- [8fe1d19](http://github.com/ddnexus/pagy/commit/8fe1d19): Fix documents for searchkick (#315)
- [744717f](http://github.com/ddnexus/pagy/commit/744717f): Meilisearch extra (#316)
- [fb65260](http://github.com/ddnexus/pagy/commit/fb65260): updated issue templates
- [1c3d283](http://github.com/ddnexus/pagy/commit/1c3d283): Added Pagy::Console links to README

## Version 4.8.1

### Changes

- fix for deprecation and test improvements

### Commits

- [0f1a7f2](http://github.com/ddnexus/pagy/commit/0f1a7f2): improved deprecation_tests (see #311)
- [7e9c9cd](http://github.com/ddnexus/pagy/commit/7e9c9cd): fix(pagy): deprecated_var is a class method (#311)

## Version 4.8.0

### Changes

- Lowered minimal ruby version requirement to 2.5+
- Simpler tests using the `rematch` gem
- Docker environment improvements

### Commits

- [b5b500a](http://github.com/ddnexus/pagy/commit/b5b500a): Merge branch 'backport-to-2.5' into dev
- [001f22f](http://github.com/ddnexus/pagy/commit/001f22f): fix for different handling of module prepend in ruby <3
- [d6d71a5](http://github.com/ddnexus/pagy/commit/d6d71a5): fix for frozen error handled differently on ruby <3
- [8a2cf76](http://github.com/ddnexus/pagy/commit/8a2cf76): replaced syntax not available in ruby 2.5
- [14b3a0c](http://github.com/ddnexus/pagy/commit/14b3a0c): lowered the minimum ruby version requirement to 2.5
- [8c76943](http://github.com/ddnexus/pagy/commit/8c76943): updated Gemfile.lock
- [934f602](http://github.com/ddnexus/pagy/commit/934f602): added comment in doc example about the inverted order of arguments in previous versions
- [acd59f5](http://github.com/ddnexus/pagy/commit/acd59f5): moved command out of default docker-compose to its own file in order to avoid error before first bundle install
- [527a14f](http://github.com/ddnexus/pagy/commit/527a14f): Gemfile update
- [842de05](http://github.com/ddnexus/pagy/commit/842de05): better tests and stricter rubocop
- [d82e95c](http://github.com/ddnexus/pagy/commit/d82e95c): Gemfile updated and used for CI
- [675f587](http://github.com/ddnexus/pagy/commit/675f587): Gemfile: added gemspec and updated rematch
- [b0a6603](http://github.com/ddnexus/pagy/commit/b0a6603): Updated to rematch 1.0 and copyright year
- [8bda6a9](http://github.com/ddnexus/pagy/commit/8bda6a9): added rematch gem and reset rematch stores
- [f62fa88](http://github.com/ddnexus/pagy/commit/f62fa88): added e2e tests to ci
- [04755aa](http://github.com/ddnexus/pagy/commit/04755aa): updated puma
- [4ec03f1](http://github.com/ddnexus/pagy/commit/4ec03f1): added HTML validation for all the helpers and styles
- [87b2f62](http://github.com/ddnexus/pagy/commit/87b2f62): refactoring e2e: replaced snapshot plugin; updated to cypress 7.3.0

## Version 4.7.1

### Changes

- Fixed a couple of HTML validity issues with uikit and materialize combo_nav_js
- Improved rematch testing
- Updated the documentation

### Commits

- [8cb4193](http://github.com/ddnexus/pagy/commit/8cb4193): fixed and simplified uikit combo nav
- [f762aca](http://github.com/ddnexus/pagy/commit/f762aca): used chip class for materialized combo nav
- [064a2b5](http://github.com/ddnexus/pagy/commit/064a2b5): rematched tests
- [2a45321](http://github.com/ddnexus/pagy/commit/2a45321): expanded the combo nav label to the whole text
- [37c65a8](http://github.com/ddnexus/pagy/commit/37c65a8): fixed and simplified materialize combo nav
- [789773b](http://github.com/ddnexus/pagy/commit/789773b): removed faulty PAGY_REMATCH variable function; added rematch_all rake task
- [eb2df6d](http://github.com/ddnexus/pagy/commit/eb2df6d): updated docs [skip ci]

## Version 4.7.0

### Changes

- Refactoring of pagy-json tags into data attributes
- Added the rematch testing system to ease maintenance of tests
- Added Ukrainian locale
- updated Gemfile and doc

### Commits

- [887c783](http://github.com/ddnexus/pagy/commit/887c783): better doc for E2E testing
- [738fd93](http://github.com/ddnexus/pagy/commit/738fd93): updated manifest
- [0110e3a](http://github.com/ddnexus/pagy/commit/0110e3a): Ukrainian locale (#310)
- [9265cd2](http://github.com/ddnexus/pagy/commit/9265cd2): extended must_rematch to other tests
- [d217965](http://github.com/ddnexus/pagy/commit/d217965): refactoring of pagy_json_tag to pagy_json_attr: from script tag to data attribute
- [57e6f91](http://github.com/ddnexus/pagy/commit/57e6f91): added rematch test to ease maintenance of tests
- [94561a0](http://github.com/ddnexus/pagy/commit/94561a0): updated puma

## Version 4.6.0

### Changes

- Added labels to all input tags for improved usability and compliance
- Fixed a few HTML typos and rendundant or illegal attributes
- Improved Sinatra app usable for experiment with pagy and providing support for ode issues
- Documentation inprovements
- Added E2E testing for all pagy helpers
- GitHub management improvements

### Commits

- [0fe2e49](http://github.com/ddnexus/pagy/commit/0fe2e49): added helpers and navbar tests for all the styles; updated docker readme
- [26b57a8](http://github.com/ddnexus/pagy/commit/26b57a8): Added fix for Cypress bug affecting the snapshots plugin, improved cypress dockerfiles; added cypress studio and basic try
- [7693b3e](http://github.com/ddnexus/pagy/commit/7693b3e): cypress: updated images; better open-cypress.yml with persistent configuration settings; added snapshots plugin
- [94e262f](http://github.com/ddnexus/pagy/commit/94e262f): added label tag to the pagy inputs
- [f5e3482](http://github.com/ddnexus/pagy/commit/f5e3482): removed redundant role="navigation" attribute from nav tags; removed illegal aria-label="pager" from semantic div
- [0467d32](http://github.com/ddnexus/pagy/commit/0467d32): fixes for html typos in semantic, foundation and materialize helpers
- [3f2c9f0](http://github.com/ddnexus/pagy/commit/3f2c9f0): doc small fixes
- [bff8c5f](http://github.com/ddnexus/pagy/commit/bff8c5f): refactoring of sinatra apps; added quick-start doc section
- [b0baaa5](http://github.com/ddnexus/pagy/commit/b0baaa5): simplified standalone_app.ru
- [5442b34](http://github.com/ddnexus/pagy/commit/5442b34): fix broken link [ci skip]
- [17b1faf](http://github.com/ddnexus/pagy/commit/17b1faf): improved issue template [ci skip]
- [f933cd7](http://github.com/ddnexus/pagy/commit/f933cd7): Added issue template and standalone_app to use as a scaffold for reproducing issues [ci skip]
- [c8e41e3](http://github.com/ddnexus/pagy/commit/c8e41e3): added superails screencast; resized thumbnails [skip ci]
- [6116c32](http://github.com/ddnexus/pagy/commit/6116c32): added a few references in the how_to doc [skip ci]

## Version 4.5.1

### Changes

- Better Pagy::Console usability

### Commits

- [4ee8bbf](http://github.com/ddnexus/pagy/commit/4ee8bbf): pagy console extracted in its own module

### Version 4.5.0

### Changes

- Added E2E infrastructure for development and testing
- Refactoring of Javascript and docker environment

### Commits

- [1b7b014](http://github.com/ddnexus/pagy/commit/1b7b014): Add: clarity, further instructions to run pagy tests [skip ci] (#304)
- [7c723ba](http://github.com/ddnexus/pagy/commit/7c723ba): added basic structure to run cypress tests and open the cypress IDE

## Version 4.4.0

### Changes

- Passing positional arguments (besides `@pagy`) to all the helpers is deprecated and it will be supported only until pagy 5.0
- All the helpers accept more optional keyword arguments, for example:
  - `pagy*_nav(@pagy, pagy_id: 'my-id', link-extra: '...')`
  - `pagy*_nav_js(@pagy, pagy_id: 'my-id', link-extra: '...', steps: {...})`
  - `pagy*_combo_nav_js(@pagy, pagy_id: 'my-id', link-extra: '...')`
  - `pagy_items_selector_js(pagy, pagy_id: 'my-id', item_name: '...', i18n_key: '...', link_extra: '...')`
  - `pagy_info(@pagy, pagy_id: 'my-id', item_name: '...', i18n_key: '...')`
  - `pagy_prev_link(@pagy, text: '...', link_extra: '...')`
  - `pagy_next_link(@pagy, text: '...', link_extra: '...')`
  - `pagy_link_proc(@pagy, link_extra: '...')`
  - `pagy_url_for(pagy, page, absolute: nil)` (notice the inverted page/pagy order with the legacy`pagy_url_for(page, pagy, url=nil)`)
- deprecated `:anchor` variable in favor of `:fragment`
- Refactoring of rake tasks, tests, items extra, javascript helpers
- Gems and documentation updates and fixes
- Added standalone extra

### Commits

- [b69a2f2](http://github.com/ddnexus/pagy/commit/b69a2f2): Merge branch 'dev'
- [9611eac](http://github.com/ddnexus/pagy/commit/9611eac): updated CHANGELOG
- [d977767](http://github.com/ddnexus/pagy/commit/d977767): better links in extras.md
- [aa83126](http://github.com/ddnexus/pagy/commit/aa83126): added standalone extra
- [e22c9c3](http://github.com/ddnexus/pagy/commit/e22c9c3): Merge branch 'args-refactoring' into dev
- [d791a04](http://github.com/ddnexus/pagy/commit/d791a04): deprecated :anchor variable in favor of :fragment
- [e91e4da](http://github.com/ddnexus/pagy/commit/e91e4da): [skip ci] update javascript documentation (#305)
- [034afe8](http://github.com/ddnexus/pagy/commit/034afe8): config/pagy.rb: moved pagy variables block at the beginning
- [bd0bb6c](http://github.com/ddnexus/pagy/commit/bd0bb6c): renamed :trim variable to the more explicit :enable_trim_extra; removed redundant tests
- [76096e7](http://github.com/ddnexus/pagy/commit/76096e7): simplified the items extra, and added its features to the array and arel extras
- [86fb20e](http://github.com/ddnexus/pagy/commit/86fb20e): fixed pagy_semantic_nav hellips
- [2382482](http://github.com/ddnexus/pagy/commit/2382482): added link_extra keyword arg to pagy_items_selector_js
- [627a0dc](http://github.com/ddnexus/pagy/commit/627a0dc): also pagy_link_proc uses keyword arguments
- [8ff2665](http://github.com/ddnexus/pagy/commit/8ff2665): completed args conversion also for pagy_url_for and pagy_metadata
- [6a8fbb4](http://github.com/ddnexus/pagy/commit/6a8fbb4): added "pagy-info" and "pagy-items-selector-js" classes to helpers output
- [ad350e1](http://github.com/ddnexus/pagy/commit/ad350e1): pagy_info wrapped into span tag, and added pagy_id keyword arg
- [2faca63](http://github.com/ddnexus/pagy/commit/2faca63): small improvement to pagy_url_for
- [2acbac6](http://github.com/ddnexus/pagy/commit/2acbac6): added "pagy-njs" class to all pagy*_nav_js helpers
- [670f5a5](http://github.com/ddnexus/pagy/commit/670f5a5): updated documentation
- [64347f8](http://github.com/ddnexus/pagy/commit/64347f8): changed the argument order from pagy_url_for(page, pagy) > pagy_url_for(pagy, page) for consistency with all the other helpers; deprecation warning and support for pagy < 5
- [393d216](http://github.com/ddnexus/pagy/commit/393d216): updated gems
- [d2891fb](http://github.com/ddnexus/pagy/commit/d2891fb): refactoring and additions of tests
- [1538f24](http://github.com/ddnexus/pagy/commit/1538f24): updated tests with keyword arguments
- [6ce0c1d](http://github.com/ddnexus/pagy/commit/6ce0c1d): helpers: deprecated positional id argument and added keyword arguments
- [9fd7930](http://github.com/ddnexus/pagy/commit/9fd7930): removed pagy_id method and added id arg to the pagy*_nav helpers
- [ec74e4f](http://github.com/ddnexus/pagy/commit/ec74e4f): removed the mandatory id arg passed to pagy_json_tag; updated tests; simplified pagy.js using previousSibling
- [3f13014](http://github.com/ddnexus/pagy/commit/3f13014): added resource post and relative link [skip ci]
- [7927f37](http://github.com/ddnexus/pagy/commit/7927f37): added manifest:check to CI for master and dev and to the default rake task
- [01f8f1c](http://github.com/ddnexus/pagy/commit/01f8f1c): refactoring of Rakefile now split in different task files

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
