# CHANGELOG

## Version 2.1.3

### Changes

- added Swedish locale

### Commits

- [f0dcac6](http://github.com/ddnexus/pagy/commit/f0dcac6): docs update
- [9dc8c05](http://github.com/ddnexus/pagy/commit/9dc8c05): removed tap from Pagy#series
- [e237ea6](http://github.com/ddnexus/pagy/commit/e237ea6): add translation for Swedish (#145)
- [7d71699](http://github.com/ddnexus/pagy/commit/7d71699): lighter README and a few docs improvements
- [f25b5f5](http://github.com/ddnexus/pagy/commit/f25b5f5): updated support extra examples with pagy_countess
- [6fa1d03](http://github.com/ddnexus/pagy/commit/6fa1d03): comments and docs updates
- [9f057e6](http://github.com/ddnexus/pagy/commit/9f057e6): small improvement for the headers extra doc
- [2c53e76](http://github.com/ddnexus/pagy/commit/2c53e76): a few docs changes for the migration guide
- [2a90e6a](http://github.com/ddnexus/pagy/commit/2a90e6a): stop following the GitFlow conventions (extra comlexity for no advantage for this project; too many merge commits; history difficult to follow)
- [198883c](http://github.com/ddnexus/pagy/commit/198883c): Fix legacy changelog url (#144)


## Version 2.1.2

### Changes

- Added "Current-Page" header to headers extra

### Commits

- [016b377](http://github.com/ddnexus/pagy/commit/016b377): added Current-Page default header to headers extra
- [4086181](http://github.com/ddnexus/pagy/commit/4086181): fix compilant > compliant typos in docs
- [5d6edf6](http://github.com/ddnexus/pagy/commit/5d6edf6): reconciliation between test strings

## Version 2.1.1

### Changes

- Fix for multiple pagy get wrong url (#143)
- Better documentation for responsive breakpoints (#140)

### Commits

- [e9f467a](http://github.com/ddnexus/pagy/commit/e9f467a): fix for pagy_url_for not working with multiple pagy in the same request (#143)
- [75329b4](http://github.com/ddnexus/pagy/commit/75329b4): better configuration example and documentation for responsive breakpoints (#140)

## Version 2.1.0

### Changes

- Added headers extra
- Added support for overflow :last_page to searchkick and elasticsearch_rails extras
- Added zh-hk locale
- Better docs

### Commits

- [4e83993](http://github.com/ddnexus/pagy/commit/4e83993): updated docs
- [8bd19d6](http://github.com/ddnexus/pagy/commit/8bd19d6): added headers extra (#141)
- [9a26b04](http://github.com/ddnexus/pagy/commit/9a26b04): added support for overflow :last_page to searchkick and elasticsearch_rails extras (#138)
- [c5524fc](http://github.com/ddnexus/pagy/commit/c5524fc): Add zh-hk language yml file (#139)
- [6d5841b](http://github.com/ddnexus/pagy/commit/6d5841b): update travis setup
- [5bd7c0a](http://github.com/ddnexus/pagy/commit/5bd7c0a): updated docs notes for the searchkick and elasticsearch_rails extras
- [0ca5539](http://github.com/ddnexus/pagy/commit/0ca5539): updated comments in config/pagy.rb (#138)

## Version 2.0.1

### Changes

- Fix for missing require in config/pagy.rb and fix for pt-br translation typos
- docs fixes and improvements

### Commits

- [4e7b30f](http://github.com/ddnexus/pagy/commit/4e7b30f): update Repository Info section in README
- [835e8d2](http://github.com/ddnexus/pagy/commit/835e8d2): Fix for missing require in config/pagy.rb and fix for pt-br translation typos (#134)
- [8cdffa1](http://github.com/ddnexus/pagy/commit/8cdffa1): updated consumption chart in README
- [91aa417](http://github.com/ddnexus/pagy/commit/91aa417): replaced efficiency table with resource-consumption chart; other minor fixes
- [964ab24](http://github.com/ddnexus/pagy/commit/964ab24): fix for wrong params in searchkick synopsis example
- [71baf56](http://github.com/ddnexus/pagy/commit/71baf56): added paginate-responder link to the HTTP header in the How to doc (#132)
- [05e218c](http://github.com/ddnexus/pagy/commit/05e218c): fix for indents in searchkick doc
- [7061086](http://github.com/ddnexus/pagy/commit/7061086): added README comments for the docs/update branch
- [b93259c](http://github.com/ddnexus/pagy/commit/b93259c): fix typos in searchkick readme (#129)
- [4156121](http://github.com/ddnexus/pagy/commit/4156121): added how-to for custom count for custom scopes (#130); other minor adjustments
- [4c7b50a](http://github.com/ddnexus/pagy/commit/4c7b50a): docs fixes and additions (#128)

## Version 2.0.0

### Breaking Changes

#### Renamed methods and files (already deprecated)

The following methods have been renamed. You only need to search and replace, because the funtionality has not been changed.

#### Bootstrap Extra

| Legacy Name                     | New Name                        |
|:--------------------------------|:--------------------------------|
| `pagy_nav_bootstrap`            | `pagy_bootstrap_nav`            |
| `pagy_nav_compact_bootstrap`    | `pagy_bootstrap_compact_nav`    |
| `pagy_nav_responsive_bootstrap` | `pagy_bootstrap_responsive_nav` |

#### Bulma Extra

| Legacy Name                 | New Name                    |
|:----------------------------|:----------------------------|
| `pagy_nav_bulma`            | `pagy_bulma_nav`            |
| `pagy_nav_compact_bulma`    | `pagy_bulma_compact_nav`    |
| `pagy_nav_responsive_bulma` | `pagy_bulma_responsive_nav` |

#### Foundation Extra

| Legacy Name                      | New Name                         |
|:---------------------------------|:---------------------------------|
| `pagy_nav_foundation`            | `pagy_foundation_nav`            |
| `pagy_nav_compact_foundation`    | `pagy_foundation_compact_nav`    |
| `pagy_nav_responsive_foundation` | `pagy_foundation_responsive_nav` |

#### Materialize Extra

| Legacy Name                       | New Name                          |
|:----------------------------------|:----------------------------------|
| `pagy_nav_materialize`            | `pagy_materialize_nav`            |
| `pagy_nav_compact_materialize`    | `pagy_materialize_compact_nav`    |
| `pagy_nav_responsive_materialize` | `pagy_materialize_responsive_nav` |

#### Navs Extra

| Legacy Name                  | New Name                            |
|:-----------------------------|:------------------------------------|
|                              | `pagy_plain_nav` (`pagy_nav` alias) |
| `pagy_nav_compact`           | `pagy_plain_compact_nav`            |
| `pagy_nav_responsive`        | `pagy_plain_responsive_nav`         |
| `require "pagy/extras/navs"` | `require "pagy/extras/plain"`       |

#### Semantic Extra

| Legacy Name                    | New Name                       |
|:-------------------------------|:-------------------------------|
| `pagy_nav_semantic`            | `pagy_semantic_nav`            |
| `pagy_nav_compact_semantic`    | `pagy_semantic_compact_nav`    |
| `pagy_nav_responsive_semantic` | `pagy_semantic_responsive_nav` |

#### Renamed classes and params in helpers

**Notice**: You can skip this section if you did not override any nav helper.

#### CSS nav classes

The `nav` CSS classes follow the same renaming rules of the helper methods. For example:

`pagy-nav-responsive-bootstrap` is now `pagy-bootstrap-responsive-nav`

#### CSS JSON tag classes

All the JSON tag classes are now `pagy-json`, and the qualifier of the json (e.g. `compact`, `responsive`, ...) is now passed as the first argument in the array content. For example:

`<script type="application/json" class="pagy-responsive-json">["#{id}", ...`

is now

`<script type="application/json" class="pagy-json">["responsive", "#{id}", ...`

However the tags have been refactored to use the shared `pagy_json_tag` helper. For example:

`script = pagy_json_tag(:responsive, id, tags,  responsive[:widths], responsive[:series])`

#### Pagy I18n

- The `Pagy::Frontend::I18N` is now `Pagy::I18n`
- The `Pagy::I18n.load` method accepts params in different format: see the [doc](https://ddnexus.github.io/pagy/api/frontend#i18n)

#### Searchkick Extra

- The `searchkick` extra has been refactored and its methods work in a different way: see the [doc](https://ddnexus.github.io/pagy/extras/searchkick)

#### Elasticsearch Rails Extra

- The `elasticsearch_rails` extra has been refactored and its methods work in a different way: see the [doc](https://ddnexus.github.io/pagy/extras/elasticsearch_rails)

#### Pagy Initializer

The pagy initializer has changed: please replace/update it: [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb)

### Commits

- [a03ff0b](http://github.com/ddnexus/pagy/commit/a03ff0b): updated README and docs
- [7bb34e3](http://github.com/ddnexus/pagy/commit/7bb34e3): refactoring of searchkick extra
- [22afe14](http://github.com/ddnexus/pagy/commit/22afe14): refactoring of elasticsearch_rails extra
- [fc608e9](http://github.com/ddnexus/pagy/commit/fc608e9): setup for ruby 1.9+ and jruby 1.7+
- [7948394](http://github.com/ddnexus/pagy/commit/7948394): updated magic comments
- [d8ce15f](http://github.com/ddnexus/pagy/commit/d8ce15f): updated Gemfile
- [8ad362d](http://github.com/ddnexus/pagy/commit/8ad362d): conditional SingleCov
- [14a7c30](http://github.com/ddnexus/pagy/commit/14a7c30): small change in pagy_bootstrap_compact_nav style
- [8550b67](http://github.com/ddnexus/pagy/commit/8550b67): removed fork from tests
- [532743d](http://github.com/ddnexus/pagy/commit/532743d): simpler overflow module structure (backward compatible)
- [9c1212b](http://github.com/ddnexus/pagy/commit/9c1212b): i18n refactoring:
    - added multi-language
    - simpler I18N format
    - faster pagy_t method
- [1f3c86f](http://github.com/ddnexus/pagy/commit/1f3c86f): fixed warnings and a few backward incompatible statements
- [a6a9371](http://github.com/ddnexus/pagy/commit/a6a9371): replaced +'...' syntax with EMPTY + '...' syntax for backward compatibility
- [32984a3](http://github.com/ddnexus/pagy/commit/32984a3): removed empty string assignation (simpler and more efficient)
- [e61b1e6](http://github.com/ddnexus/pagy/commit/e61b1e6): Removed deprecations:
    - remove deprecation of method extras and extra CSS class in navs in modules
    - remove deprecated method from `extras/shared`
    - remove extra CSS class in tests and templates
    - remove the extras/navs.rb and DEPRECATIONS.md files
    - remove support for overridden legacy helper in `pagy.js`
    - add a note in the GoRails section in the README
- [ca18374](http://github.com/ddnexus/pagy/commit/ca18374): Cache gemset for faster Travis builds (#126)
- [71a3e5f](http://github.com/ddnexus/pagy/commit/71a3e5f): Always return the same object as Pagy.root (#125)* Update copyright notice to 2019 (#121)

---

For older versions, check the [LEGACY CHANGELOG](https://github.com/ddnexus/pagy/blob/master/LEGACY_CHANGELOG.md).
