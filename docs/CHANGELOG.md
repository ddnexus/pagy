---
icon: versions
---

# CHANGELOG

## Release Policy

Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/), and introduces BREAKING CHANGES only for MAJOR versions.

We release any new version (MAJOR, MINOR, PATCH) as soon as it is ready for release, regardless of any time constraint, frequency
or duration.

We rarely deprecate elements (releasing a new MAJOR version is just simpler and more efficient). However, when we do, you can
expect the old/deprecated functionality to be supported ONLY during the current MAJOR version.

## Recommended Version Constraint

Given a version number `MAJOR.MINOR.PATCH` (e.g. `43.2.8`):

The `gem 'pagy', '~> 43.0'` Gemfile entry (without the PATCH number) ensures that the `bundle update` command will update pagy to
the most recent version WITHOUT BREAKING CHANGES.

Increment the MAJOR version in your Gemfile ONLY when you are ready to handle the BREAKING CHANGES.

## Breaking Changes

Follow the [Upgrade to 43 Guide](guides/upgrade-guide).

If you upgrade from version `< 9.0.0` see the following:

- [Breaking changes in version 9.0.0](CHANGELOG_LEGACY#version-900)
- [Breaking changes in version 8.0.0](CHANGELOG_LEGACY#version-800)
- [Breaking changes in version 7.0.0](CHANGELOG_LEGACY#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY#version-100)

> [!TIP]
> If you need to update through multiple versions, reimplementing the updated pagination
> from scratch might be faster.

<hr>

## Version 43.2.7

- Add a hint predicate for DB optimizers, to multi-column keysets
- Improve code readability and style
- Refactor anchor tag helpers

## Version 43.2.6

- Refactor i18n:
  - Raise exceptions for missing 'pagy' and 'p11n' keys in the dictionary
  file
  - Improve efficiency and readability

## Version 43.2.5

- Fix Pagy::I18n.locale to ensure to_s. Close #861.
- Reduce endless methods to very short, paramless ones
- Refactor the in_range? method:
  - Remove implicit assignation to empty page variable
- Enforce freezing the Pagy::Request object and params
- Refactor calendar:
  - Remove the marshaling
  - Improve use and naming of locals
  - Improve readability
- Refactor linkable:
  - Improve use of locals
  - Extend conditional sub to fragment
  - Improve readability
- Improve simplicity and readability

## Version 43.2.4

- Fix anchor_string option not being read from @options in a_lambda. Close #857
- Fix page '0' raising an exception

## Version 43.2.3

- Remove rerun
- Improved direction handling in CSSs

## Version 43.2.2

- Refactor bin/pagy to use the Pagy::CLI class
- Replace optimist with the optparse standard lib
- Simplify apps by using SQLite :memory:

## Version 43.2.1

- Fix the shallow cloning of root_key params. Close #851.
- Implements support for easy overriding
- Add :current_url alias to :page_url
- Fix limit_tag_js not respecting the passed :client_max_limit option
- Fix data_hash returning keys with nil values, or URLs without page; add :current_url alias to :page_url
- Remove warning when fit_time
- Fix respond_to_missing definition arguments in Search::Arguments

## Version 43.2.0

- Implement :countish paginator
- Simplify Pagy::Linkable

## Version 43.1.8

- Refactoring of elasticsearch_rails paginator:
  - Fix "response" shadowing. Close #842.
  - Simplify code
  - Improve readability: rename variables and methods in more natural
  and unambiguous language

## Version 43.1.7

- Fix and improve search paginators:
  - Add support for elasticsearch_rails v8
  - Prioritize elasticsearch_rails response over raw_response in
  total_count (causing multiple query executions)
  - Fix the ignored :search_method paginator option
  - Close #837, close #838, close #839.

## Version 43.1.6

- Ensure the request GET and POST merge into a proper params Hash
- Simplify code efficiency and readability

## Version 43.1.5

- Fix and improve the composition of the page url. Close #835

## Version 43.1.4

- Add full support for legacy countless params, url composition and (limited) behavior

## Version 43.1.3

- Improve the page options handling for countless:
  - Replace the crippled handling of legacy last-less links params
  introduced in 43.1.2 by gracefully starting the pagination from
  the beginning
  - Remove the compose_page_param method (it would need a deep refactoring
   for compatibility with the legacy handling)
  - Improve testing
- Improve the info message for empty collection in countless paginations

## Version 43.1.2

- Support easy countless page param overriding (for legacy param and behavior). See #816
- Handle legacy page param for :countless paginator. Close #832
- Improve mock collections
- Improve code comments

## Version 43.1.1

- Makes keynav pagination compatible with nested params:
  - Improve the URL composing and unescaping
  - Adds the keynav+root_key.ru showcase app
- Simplify the request code and arguments

## Version 43.1.0

- Translate the aria_label.nav entry in the id, ja, kn, sw locales. Close #588, close #590, close #591, close #603.
- Improve the Pagy AI panel
- Simplify the paginators code
- Allow nested :page and :limit request params and URLs:
  - Add the :root_key option:
  - Simplify the :jsonapi handling as a special case of nested params
- Fix and simplify the pagy console code

## Version 43.0.7

- Add compatibility for searchkick 6. Close #831
- Fix the search paginators request in passive mode. Close #830.

## Version 43.0.6

- Improve Pagy AI Widget scripts

## Version 43.0.5

- Add console loader for easier usage
- Add comment for the calendar usage. Close #827.

## Version 43.0.4

- Remove the Pagy.options from the Calendar configuration. Close #825

## Version 43.0.3

- Update tr.yml (#824)

## Version 43.0.2

- Ensure the Pagy::Request#params are the original params sent with the request. Close #821

## Version 43.0.1

- Reimplement reading params from POST requests; rename internal variables. Close #821
- Fix AI widget problem for apps. Close #817.
- Improve I18n documentation. Close #811
- Link to documentation website's CHANGELOG page (#804)

## Version 43.0.0

We needed a leap version to unequivocally signal that it's not just a major version: it's a complete redesign of the legacy
code at all levels, usage and API included.

**Why 43?** Because it's exactly one step beyond _"The answer to the ultimate question of life, the Universe, and everything."_ 😉

## Changes

- **The Countless pagination remembers the last page**
  - Pagination navs now allow jumping forward after navigating back a few pages.
- **Javascript refactoring**
  - The new `Pagy.sync_javascript` function used in the `pagy.js` initializer, avoids complicated configurations.
  - Added the plain `pagy.js` and relative source map files.
- **I18n refactoring**
  - No setup required: the locales and their pluralization are autoloaded when your app uses them.
  - The locale files are easier to override with `Pagy::I18n.pathnames << my_dictionaries`.
- **HTML and CSS refactoring**
  - Stylesheets are now based on CSS properties and calculations, for easier customization.
  - The new PagyWand interactive tool generates the CSS Override for your custom styles and provides live feedback right in your
    app.
- **Playground apps**
  - Better usability and styles
- **Bootstrap and Bulma**
  - Fixed a few style glitches.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
