# CHANGELOG

## Version 3.3.2

### Changes

- Fix for #163
- Javascript improvements

### Commits

- [aff8cbb](http://github.com/ddnexus/pagy/commit/aff8cbb): better handling of resize listeners; added render funcition to the pagy element
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

#### Javascript funcions

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
    - renamed :items_Path to :colletion_key
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
