# CHANGELOG

## Version 4.11.0

### Changes

- added countless_minimal feature
- added missing deprecation to countless class
- doc improvements

### Commits

- [5103ee9](http://github.com/ddnexus/pagy/commit/5103ee9): added countless_minimal feature
- [ed6bc0b](http://github.com/ddnexus/pagy/commit/ed6bc0b): added missing deprecation to countless class
- [bedb2d6](http://github.com/ddnexus/pagy/commit/bedb2d6): Fix - link directly to docs [ci-skip] (#328)
- [74aa300](http://github.com/ddnexus/pagy/commit/74aa300): Remove minor extra parenthesis in trim docs [ci-skip] (#326)
- [f8b96eb](http://github.com/ddnexus/pagy/commit/f8b96eb): docs - add links directly to docs page [ci-skip] (#324)

## Version 4.10.2

### Changes

- improve the customization of url when using the trim extra
- better tailwind rules
- doc fixes and improvements

### Commits

- [9e7fd48](http://github.com/ddnexus/pagy/commit/9e7fd48): improve the customization of url when using the trim extra (closes #325)
- [0d48b5f](http://github.com/ddnexus/pagy/commit/0d48b5f): better handling of extra docker-compose run files
- [f5ed8f6](http://github.com/ddnexus/pagy/commit/f5ed8f6): added note about the possible workaround for bundler/inline bug
- [2715660](http://github.com/ddnexus/pagy/commit/2715660): doc fixes
- [7187101](http://github.com/ddnexus/pagy/commit/7187101): Javascript doc improvements
- [24b7e78](http://github.com/ddnexus/pagy/commit/24b7e78): release workflow refactoring
- [20d1d8e](http://github.com/ddnexus/pagy/commit/20d1d8e): chore: add github action - publish & tag versions (#322)
- [922fd7f](http://github.com/ddnexus/pagy/commit/922fd7f): better tailwind rules
- [28983e6](http://github.com/ddnexus/pagy/commit/28983e6): added doc for using Searchkick.pagy_search (closes #319)

## Version 4.10.1

### Changes

- fixes for meilisearch extra

### Commits

- [ec748c2](http://github.com/ddnexus/pagy/commit/ec748c2): Fixes for Meilisearch extra (#318)

## Version 4.10.0

### Changes

- added arabic locale

### Commits

- [9bc548e](http://github.com/ddnexus/pagy/commit/9bc548e): added missing keys for Arabic (#317) (closes #295)
- [1b95674](http://github.com/ddnexus/pagy/commit/1b95674): Add arabic locale, pluralization and tests; alpha ordered tests

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
- Fixed a few HTML typos and redundant or illegal attributes
- Improved Sinatra app usable for experiment with pagy and providing support for ode issues
- Documentation improvements
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
- Fixed error in searchkick extra with ruby 3
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

## Version 3.11.0

### Changes

- added Swahili localization

### Commits

- [fbc322f](http://github.com/ddnexus/pagy/commit/fbc322f): Add Swahili (sw) to pagy (#276)
- [ebbac6b](http://github.com/ddnexus/pagy/commit/ebbac6b): Fix: broken links (#272) [ci-skip]
- [2178436](http://github.com/ddnexus/pagy/commit/2178436): restored file removed by mistake

## Version 3.10.0

### Changes

- added Czeck localization

### Commits

- [316183f](http://github.com/ddnexus/pagy/commit/316183f): minor adjustments to p11n.rb; removed local file
- [2e7fa1b](http://github.com/ddnexus/pagy/commit/2e7fa1b): Update with 'cs' (#269)added lambda for 'west_slavic' and 'hash for 'cs' language
- [70760c6](http://github.com/ddnexus/pagy/commit/70760c6): Czech localization (#268)

## Version 3.9.0

### Changes

- added link tags helpers to support extra

### Commits

- [a66491b](http://github.com/ddnexus/pagy/commit/a66491b): added link tags helpers to support extra
- [2ef08a9](http://github.com/ddnexus/pagy/commit/2ef08a9): @pagy_locale explicitly initialized to avoid warning
- [261c6a1](http://github.com/ddnexus/pagy/commit/261c6a1): reorganized gemfiles for travis, removed jruby 9.2 tests and added CAVEATS and removed redundant ||=nil
- [619d7d1](http://github.com/ddnexus/pagy/commit/619d7d1): updated gems
- [fc861d8](http://github.com/ddnexus/pagy/commit/fc861d8): added .gitattributes to fix github linguist [ci-skip]
- [287b94f](http://github.com/ddnexus/pagy/commit/287b94f): added Raul Palacio screencast link to README
- [52c65a3](http://github.com/ddnexus/pagy/commit/52c65a3): added "Contributions" section in the README
- [f09a80a](http://github.com/ddnexus/pagy/commit/f09a80a): Add tutorial link to readme (#259)
- [86bf3dc](http://github.com/ddnexus/pagy/commit/86bf3dc): Fix: typo [ci-skip] (#257)
- [bd3bcc7](http://github.com/ddnexus/pagy/commit/bd3bcc7): Update copyright notice to 2020 (#256) [ci-skip]
- [01e4a14](http://github.com/ddnexus/pagy/commit/01e4a14): [ci-skip] Add note re: html safe helpers (#254)Fixes discussion noted in: #6
- [1d812be](http://github.com/ddnexus/pagy/commit/1d812be): doc improvements [ci-skip]

## Version 3.8.3

### Changes

- Portuguese translation
- Fixes and documentation improvements

### Commits

- [f64a1d6](http://github.com/ddnexus/pagy/commit/f64a1d6): added pagy reference to jetbrains link
- [8a4596f](http://github.com/ddnexus/pagy/commit/8a4596f): Add translation for Portuguese (#250) [ci-skip]
- [515de9b](http://github.com/ddnexus/pagy/commit/515de9b): Adds parentheses (#249) [ci-skip]
- [734f30c](http://github.com/ddnexus/pagy/commit/734f30c): added basic sinatra app
- [c7aa44d](http://github.com/ddnexus/pagy/commit/c7aa44d): updated gems
- [62bd4ac](http://github.com/ddnexus/pagy/commit/62bd4ac): added tailwind extra styles
- [c2e8eef](http://github.com/ddnexus/pagy/commit/c2e8eef): added "Customizing CSS styles" how to section
- [614a3e1](http://github.com/ddnexus/pagy/commit/614a3e1): fix for extra "-js" in "pagy-combo-nav-js"
- [8673ca4](http://github.com/ddnexus/pagy/commit/8673ca4): a couple of how_to additions

## Version 3.8.2

### Changes

- Fixes, improvements and gems updates

### Commits

- [a1a7962](http://github.com/ddnexus/pagy/commit/a1a7962): gems update
- [0a70110](http://github.com/ddnexus/pagy/commit/0a70110): item_name can be overridden by passing an already pluralized string to pagy_info
- [28913d6](http://github.com/ddnexus/pagy/commit/28913d6): Use proper attributes for "previous" links (#244)

## Version 3.8.1

### Changes

- Various fixes ad gems update

### Commits

- [1aa1fa7](http://github.com/ddnexus/pagy/commit/1aa1fa7): gems update
- [289d38a](http://github.com/ddnexus/pagy/commit/289d38a): added conditional definition of pagy_t_with_i18n to avoid ruby 2.7 "last argument as keyword parameters" deprecation warning (closes #241)
- [d571719](http://github.com/ddnexus/pagy/commit/d571719): added raw_response method check for pagy_elasticsearch_rails (#234)
- [7a09bb9](http://github.com/ddnexus/pagy/commit/7a09bb9): fix typo in documentation
- [d7a9f7a](http://github.com/ddnexus/pagy/commit/d7a9f7a): Fixes boundary character escaping in regex in js trim function (#239)
- [3561885](http://github.com/ddnexus/pagy/commit/3561885): gems update

## Version 3.8.0

### Changes

- Khmer translation
- Added support for elasticsearch < 6
- Documentation fixes

### Commits

- [bba1bca](http://github.com/ddnexus/pagy/commit/bba1bca): used ternary conditional
- [a9cee7d](http://github.com/ddnexus/pagy/commit/a9cee7d): Support ES5 on elasticsearch rails (#234)
- [d58a39d](http://github.com/ddnexus/pagy/commit/d58a39d): Khmer translation for pagy (#235)
- [7ced96c](http://github.com/ddnexus/pagy/commit/7ced96c): fix for missing suffix fr method reference in doc
- [73600be](http://github.com/ddnexus/pagy/commit/73600be): improved consistency in searchkick and elasticsearch_rails documentation examples (#231)

## Version 3.7.5

### Changes

- Danish translation
- Re-enabled legacy jruby travis config
- Added ruby 2.7 travis testing and rubocop config

### Commits

- [721d01f](http://github.com/ddnexus/pagy/commit/721d01f): more documentation fixes and improvements
- [246fca7](http://github.com/ddnexus/pagy/commit/246fca7): Danish translation for Pagy (#232)
- [e57215f](http://github.com/ddnexus/pagy/commit/e57215f): added ruby 2.7 travis testing and rubocop target version
- [280164a](http://github.com/ddnexus/pagy/commit/280164a): re-enabled travis testing for old jruby (travis fixed the jruby images issue)

## Version 3.7.4

### Changes

- Locales normalization and deprecations
- Bundle update

### Commits

- [c424466](http://github.com/ddnexus/pagy/commit/c424466): Merge branch 'locales-normalization' into dev
- [032615c](http://github.com/ddnexus/pagy/commit/032615c): added Pagy::I18n deprecation tests
- [ebd6151](http://github.com/ddnexus/pagy/commit/ebd6151): added deprecation remapping
- [e1bd70c](http://github.com/ddnexus/pagy/commit/e1bd70c): renamed pt-br -> pt-BR
- [a77dfcf](http://github.com/ddnexus/pagy/commit/a77dfcf): fix for sv and sv-SE pluralization
- [6a31db6](http://github.com/ddnexus/pagy/commit/6a31db6): Swedish locale: add sv-SE, rename se -> sv (#226)
- [00bd312](http://github.com/ddnexus/pagy/commit/00bd312): bundle update (closes #208, closes #223, closes #224)
- [133da16](http://github.com/ddnexus/pagy/commit/133da16): Add tutorial link (#222) [ci skip]

## Version 3.7.3

### Commits

- [a2b915e](http://github.com/ddnexus/pagy/commit/a2b915e): reorganization of Javascript documentation
- [fead55c](http://github.com/ddnexus/pagy/commit/fead55c): Remove duplicated pagination class for Bootstrap (#212)

## Version 3.7.2

### Changes

- fix for numeric headers in the headers extra

### Commits

- [6a93b97](http://github.com/ddnexus/pagy/commit/6a93b97): headers must be strings (closes #211)

## Version 3.7.1

### Changes

- fix for arel count

### Commits

- [cbe4a97](http://github.com/ddnexus/pagy/commit/cbe4a97): Type cast pagy_arel_count value to integer (#207)
- [973f4fe](http://github.com/ddnexus/pagy/commit/973f4fe): updated link [ci skip]

## Version 3.7.0

### Changes

- updated French and Spanish translations
- added Italian translation
- internal renaming `Pagy::Frontend::MARK` > `Pagy::PAGE_PLACEHOLDER`

### Commits

- [434912b](http://github.com/ddnexus/pagy/commit/434912b): updated rubyzip gem
- [b627e55](http://github.com/ddnexus/pagy/commit/b627e55): add italian translation (#202)
- [3341dcc](http://github.com/ddnexus/pagy/commit/3341dcc): created ITEMS_PLACEHOLDER constant
- [7775155](http://github.com/ddnexus/pagy/commit/7775155): replaced Pagy::Frontend::MARK with Pagy::PAGE_PLACEHOLDER (MARK is still defined for backward compatibility)
- [439676e](http://github.com/ddnexus/pagy/commit/439676e): Fixed previous translation for Spanish (#199)
- [ee1b1f0](http://github.com/ddnexus/pagy/commit/ee1b1f0): Update fr.yml (#195)
- [8b6f81f](http://github.com/ddnexus/pagy/commit/8b6f81f): added pagy-cursor link in README
- [c290dca](http://github.com/ddnexus/pagy/commit/c290dca): update incorrect tutorial link (#198)
- [77c045d](http://github.com/ddnexus/pagy/commit/77c045d): add: tutorial link in ReadMe - complex search forms (#194)
- [846eece](http://github.com/ddnexus/pagy/commit/846eece): fix in README.md
- [224748a](http://github.com/ddnexus/pagy/commit/224748a): fix for resurrected-by-mistake line in README

## Version 3.6.0

### Changes

- added arel extra
- updated Gemfile for development environment
- docs fixes and improvements

### Commits

- [af0f189](http://github.com/ddnexus/pagy/commit/af0f189): updated minitest and minitest-reporter gems and removed deprecation
- [6a62de5](http://github.com/ddnexus/pagy/commit/6a62de5): updated Gemfile
- [4856782](http://github.com/ddnexus/pagy/commit/4856782): Arel Extra (#189)
- [2a2d9b0](http://github.com/ddnexus/pagy/commit/2a2d9b0): Revert "Added digital-climate-strike banner"This reverts commit 07f7d9256ef9b1cef1c1eaf6da56ebb03daa19d5.
- [b5c2809](http://github.com/ddnexus/pagy/commit/b5c2809): docs fixes
- [f8e4f42](http://github.com/ddnexus/pagy/commit/f8e4f42): replaced markdown file link for documentation link in extras
- [6a5c271](http://github.com/ddnexus/pagy/commit/6a5c271): updated github-pages gem
- [60d243c](http://github.com/ddnexus/pagy/commit/60d243c): small doc improvement [ci skip]
- [2feb451](http://github.com/ddnexus/pagy/commit/2feb451): docs changes
- [07f7d92](http://github.com/ddnexus/pagy/commit/07f7d92): Added digital-climate-strike banner
- [281da85](http://github.com/ddnexus/pagy/commit/281da85): update grammar (#187)
- [739f032](http://github.com/ddnexus/pagy/commit/739f032): Update how-to: Correct to require header for API (#188)

## Version 3.5.1

### Changes

- added support for elasticsearch 7

### Commits

- [ca736cc](http://github.com/ddnexus/pagy/commit/ca736cc): Adding elasticsearch7 support (#185) Fixes #184
- [13b7314](http://github.com/ddnexus/pagy/commit/13b7314): correct typos in docs and initializer (#186) [ci skip]
- [9734ed6](http://github.com/ddnexus/pagy/commit/9734ed6): Docs style changes [ci skip]
- [fb8bcf4](http://github.com/ddnexus/pagy/commit/fb8bcf4): doc fix for missing :partial key in rendering example (closes #180)
- [7160a18](http://github.com/ddnexus/pagy/commit/7160a18): Minor docs changes [ci skip]

## Version 3.5.0

### Changes

- Added Korean locale
- Added Catalan locale
- Added metadata extra
- Docs fixes and improvements

### Commits

- [2813973](http://github.com/ddnexus/pagy/commit/2813973): Docs:
  - added detailed Quick Start steps (closes #176, closes #177)
  - added specific sections for API clients and javascript frameworks
- [43349a8](http://github.com/ddnexus/pagy/commit/43349a8): added metadata extra
- [261e6e6](http://github.com/ddnexus/pagy/commit/261e6e6): Add Catalan localization (#178)
- [30ed505](http://github.com/ddnexus/pagy/commit/30ed505): temporarily removed jruby 1.7 and 9.0 rvm from travis - waiting travis to fix their rvms or suggest some work around [see issue](https://travis-ci.community/t/jruby-1-7-and-9-0-fail/4703)
- [2863c55](http://github.com/ddnexus/pagy/commit/2863c55): added minitest-reporters gem
- [0b42e5c](http://github.com/ddnexus/pagy/commit/0b42e5c): Add translation ko.yml for korean (#172)
- [da3fc37](http://github.com/ddnexus/pagy/commit/da3fc37): minor doc fixes [ci skip]

## Version 3.4.1

### Changes

- Improvements for searchkick extra
- Added javascript Pagy.version

### Commits

- [0ac5c27](http://github.com/ddnexus/pagy/commit/0ac5c27): refactoring of pagy_search and its usage in order to allow optional term argument for searchkick (#169)
- [389755b](http://github.com/ddnexus/pagy/commit/389755b): small docs editing [ci skip]

## Version 3.4.0

### Changes

- Added UIkit nav, nav_js and combo_js helpers and templates.

### Commits

- [1eb25ec](http://github.com/ddnexus/pagy/commit/1eb25ec): Implement UIkit pagination (#164)

## Version 3.3.2

### Changes

- Fix for #163
- Javascript improvements

### Commits

- [aff8cbb](http://github.com/ddnexus/pagy/commit/aff8cbb): better handling of resize listeners; added render function to the pagy element
- [c699fe5](http://github.com/ddnexus/pagy/commit/c699fe5): fix for javascript/turbolink nav.render firing when element not found (#163)

## Version 3.3.1

### Changes

Namespacing of all exceptions, still backward compatible with legacy rescues

### Commits

- [530cb24](http://github.com/ddnexus/pagy/commit/530cb24): all the exceptions are namespaced and can return more information for easier rescue of special cases

## Version 3.3.0

### Changes

- Added Bulgarian locale

### Commits

- [2c56428](http://github.com/ddnexus/pagy/commit/2c56428): added pluralization comment to bg.yml dictionary
- [7111cec](http://github.com/ddnexus/pagy/commit/7111cec): Bulgarian language yml file. (#162)
- [a46f6b5](http://github.com/ddnexus/pagy/commit/a46f6b5): improved suggestion for headers usage

## Version 3.2.1

### Commits

- [b403a35](http://github.com/ddnexus/pagy/commit/b403a35): improved trim regex: simpler, safer and more tested
- [bd3be09](http://github.com/ddnexus/pagy/commit/bd3be09): normalized aliasing with alias_method
- [3c60d9b](http://github.com/ddnexus/pagy/commit/3c60d9b): minor doc fixes
- [9aa1bea](http://github.com/ddnexus/pagy/commit/9aa1bea): fix for missing "partial" in examples for template usage (#160)
- [405b4d2](http://github.com/ddnexus/pagy/commit/405b4d2): reorganization and renaming of test helpers
- [459edaa](http://github.com/ddnexus/pagy/commit/459edaa): improved notes about preventing crawlers to follow look-alike links
- [01c73d3](http://github.com/ddnexus/pagy/commit/01c73d3): added search box to docs

## Version 3.2.0

### Commits

- [2341a83](http://github.com/ddnexus/pagy/commit/2341a83): docs fixes and additions
- [96ad00f](http://github.com/ddnexus/pagy/commit/96ad00f): extended trim extra support to all the *_js helpers:
  - refactored trim extra
  - simplified MARK strings
  - use of RegExp patterns in pagy.js
  - added and improved tests

## Version 3.1.0

### Commits

- [1732dee](http://github.com/ddnexus/pagy/commit/1732dee): refactoring of marker and hidden links in *_js helpers:
  - MARKER renamed to MARK is simpler, static and hardcoded in pagy.js as well
  - removed hidden links to bogus urls that were triggering crawlers to follow (#158)
  - pagy_items_selector now works also with trim and in combination with other *nav_js helpers
  - updated tests
- [aa140e1](http://github.com/ddnexus/pagy/commit/aa140e1): doc improvement
- [d0e4ba6](http://github.com/ddnexus/pagy/commit/d0e4ba6): a few fixes and doc improvements
- [c1ddbd9](http://github.com/ddnexus/pagy/commit/c1ddbd9): Fix typo in docs example (#156)
- [e0b2a2b](http://github.com/ddnexus/pagy/commit/e0b2a2b): removed duplication in LEGACY_CHANGELOG
- [ecb6822](http://github.com/ddnexus/pagy/commit/ecb6822): fix typo in README

## Version 3.0.0

### Breaking Changes

#### Refactoring of i18n

- The `zh-cn` and `zh-hk` were named incorrectly. They have been properly renamed as `zh-CN` and `zh-HK`. If you used them, you should update the `Pagy::I18n.load` statement.
- Removed the plural keys inconsistent with the locale: now the dictionary files are 100% compatible with the I18n gem. If you use custom dictionaries, you should update their entries.
- The `:item_path` variable has been renamed as `:i18n_key`: you should search and replace it.

#### Renamed nav helper methods and files

The javascript-powered helpers (`pagy*_responsive_nav`, `pagy*_compact_nav` and `items_selector`) have been renamed in order to be simpler and more descriptive of their arguments, features and requirements. They have been improved internally, but you need only to search and replace because their usage has not been changed.

#### Bootstrap Extra

| v2.0+                                          | v3.0+                            |
|:-----------------------------------------------|:---------------------------------|
| `pagy_bootstrap_responsive_nav` `:breakpoints` | `pagy_bootstrap_nav_js` `:steps` |
| `pagy_bootstrap_compact_nav`                   | `pagy_bootstrap_combo_nav_js`    |

#### Bulma Extra

| v2.0+                                      | v3.0+                        |
|:-------------------------------------------|:-----------------------------|
| `pagy_bulma_responsive_nav` `:breakpoints` | `pagy_bulma_nav_js` `:steps` |
| `pagy_bulma_compact_nav`                   | `pagy_bulma_combo_nav_js`    |

#### Foundation Extra

| v2.0+                                           | v3.0+                             |
|:------------------------------------------------|:----------------------------------|
| `pagy_foundation_responsive_nav` `:breakpoints` | `pagy_foundation_nav_js` `:steps` |
| `pagy_foundation_compact_nav`                   | `pagy_foundation_combo_nav_js`    |

#### Materialize Extra

| v2.0+                                            | v3.0+                              |
|:-------------------------------------------------|:-----------------------------------|
| `pagy_materialize_responsive_nav` `:breakpoints` | `pagy_materialize_nav_js` `:steps` |
| `pagy_materialize_compact_nav`                   | `pagy_materialize_combo_nav_js`    |

#### Plain > Navs Extra

| v2.0+                                      | v3.0+                        |
|:-------------------------------------------|:-----------------------------|
| `pagy_plain_nav` (`pagy_nav` alias)        | - removed -                  |
| `pagy_plain_responsive_nav` `:breakpoints` | `pagy_nav_js` `:steps`       |
| `pagy_plain_compact_nav`                   | `pagy_combo_nav_js`          |
| `require "pagy/extras/plain"`              | `require "pagy/extras/navs"` |

#### Semantic Extra

| v2.0+                                         | v3.0+                           |
|:----------------------------------------------|:--------------------------------|
| `pagy_semantic_responsive_nav` `:breakpoints` | `pagy_semantic_nav_js` `:steps` |
| `pagy_semantic_compact_nav`                   | `pagy_semantic_combo_nav_js`    |

#### Renamed Pagy::VARS

`Pagy::Vars[:breakpoints]` has been renamed as `Pagy::VARS[:steps]`

#### Renamed items_selector

`items_selector` has been renamed as `items_selector_js`. It is also possible to use the `i18n_key` variable to customize the item name.

#### Renamed classes and params in helpers

**Notice**: You can skip the following sections if you did not override any nav helper.

#### CSS nav classes

The `nav` CSS classes follow the same renaming rules of the helper methods:

| v2.0+                             | v3.0+                           |
|:----------------------------------|:--------------------------------|
| `pagy-bootstrap-responsive-nav`   | `pagy-bootstrap-nav-js`         |
| `pagy-bootstrap-compact-nav`      | `pagy-bootstrap-combo-nav-js`   |
| `pagy-bulma-responsive-nav`       | `pagy-bulma-nav-js`             |
| `pagy-bulma-compact-nav`          | `pagy-bulma-combo-nav-js`       |
| `pagy-foundation-responsive-nav`  | `pagy-foundation-nav-js`        |
| `pagy-foundation-compact-nav`     | `pagy-foundation-combo-nav-js`  |
| `pagy-materialize-responsive-nav` | `pagy-materialize-nav-js`       |
| `pagy-materialize-compact-nav`    | `pagy-materialize-combo-nav-js` |
| `pagy-plain-responsive-nav`       | `pagy-nav-js`                   |
| `pagy-plain-compact-nav`          | `pagy-combo-nav-js`             |
| `pagy-semantic-responsive-nav`    | `pagy-semantic-nav-js`          |
| `pagy-semantic-compact-nav`       | `pagy-semantic-combo-nav-js`    |

#### CSS JSON tag classes

Renamed first param passed to the `pagy_json_tag`:

| v2.0+         | v3.0+             |
|:--------------|:------------------|
| `:responsive` | `:nav`            |
| `:compact`    | `:combo_nav`      |
| `:items`      | `:items_selector` |

#### Javascript functions

| v2.0+             | v3.0+                 |
|:------------------|:----------------------|
| `Pagy.responsive` | `Pagy.nav`            |
| `Pagy.compact`    | `Pagy.combo_nav`      |
| `Pagy.items`      | `Pagy.items_selector` |

#### Dropped marginal methods

Dropped `pagy_serialized`, `pagy_apply_init_tag` and `PagyInit` javascript namespace. They were too basic to be useful as support for javascript powered custom component.

### Commits

- [df3ebf2](http://github.com/ddnexus/pagy/commit/df3ebf2): updated performance assets for v3
- [260e7d4](http://github.com/ddnexus/pagy/commit/260e7d4): refactoring of i18n:
  - I18n gem compliant (removed plural keys inconsistent with the locale)
  - added tests for all the pluralization procs
  - simplified and normalized Pagy dictionary file
  - renamed :items_Path to :collection_key
  - added :collection_key lookup for the items_selector_js helper
- [8ebb1ab](http://github.com/ddnexus/pagy/commit/8ebb1ab): refactoring of test coverage:
  - replaced SingleCov with SimpleCov for CodeCov integration
  - simplified Travis setup
  - separate controls of RuboCop, SimpleCov, Oj and CodeCov with dedicated ENV variables
  - completed coverage at 100%
- [ae3e4bc](http://github.com/ddnexus/pagy/commit/ae3e4bc): removed overridden method and undefined instance variable warnings
- [aa1aad9](http://github.com/ddnexus/pagy/commit/aa1aad9): renamed multi_series > sequels and relative js arguments and variables; renamed :sizes > :steps; updated nav test cases
- [901f779](http://github.com/ddnexus/pagy/commit/901f779): compact > combo and other changes
- [f7425a5](http://github.com/ddnexus/pagy/commit/f7425a5): renamed assets according to helper names; reordered and improved nav docs
- [ad100eb](http://github.com/ddnexus/pagy/commit/ad100eb): renamed plain extra to navs; removed the "plain_" qualifier for the helpers
- [54f4a7e](http://github.com/ddnexus/pagy/commit/54f4a7e): updated docs and comments
- [25470dd](http://github.com/ddnexus/pagy/commit/25470dd): renamed items_selector > items_selector_js
- [d4be9dd](http://github.com/ddnexus/pagy/commit/d4be9dd): replaced responsive with nav_js; reordered methods and test normalization
- [ec7d754](http://github.com/ddnexus/pagy/commit/ec7d754): removed warning for locales zh-cn and zh-hk, and properly renamed as zh-CN and zh-HK
- [2548557](http://github.com/ddnexus/pagy/commit/2548557): simplified support extra (dropped pagy_serialized and pagy_apply_init_tag)
- [f82b2e7](http://github.com/ddnexus/pagy/commit/f82b2e7): fix typo
- [704a4df](http://github.com/ddnexus/pagy/commit/704a4df): add french translation (#154)
- [2f67dfa](http://github.com/ddnexus/pagy/commit/2f67dfa): UPDATE pagy locales id (#151)
- [15732da](http://github.com/ddnexus/pagy/commit/15732da): fix for broken migration link (#150)

---

For older versions, check the [LEGACY CHANGELOG](https://github.com/ddnexus/pagy/blob/master/LEGACY_CHANGELOG.md).
