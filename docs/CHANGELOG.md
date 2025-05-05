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

Given a version number `MAJOR.MINOR.PATCH` (e.g. `10.0.0`):

The `gem 'pagy', '~> 10.0'` Gemfile entry (without the PATCH number) ensures that the `bundle update` command will update pagy to
the most recent version WITHOUT BREAKING CHANGES.

Increment the MAJOR version in your Gemfile ONLY when you are ready to handle the BREAKING CHANGES.

## Breaking Changes

If you upgrade from version `< 10.0.0` see the following:

- [Breaking changes in version 10.0.0](#version-1000)
- [Breaking changes in version 9.0.0](CHANGELOG_LEGACY#version-900)
- [Breaking changes in version 8.0.0](CHANGELOG_LEGACY#version-800)
- [Breaking changes in version 7.0.0](CHANGELOG_LEGACY#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY#version-100)

## Deprecations

None

<hr>

## Version 10.0.0

#### A complete redesign of the legacy code.

- **New [Keynav](toolbox/paginators/keynav_js.md) Pagination**
  - The pagy-exclusive technique using [keyset](toolbox/paginators/keyset.md) pagination alongside
    all frontend helpers.
- **Method Autoloading**
  - Methods are autoloaded only if used, unused methods consume no memory.
- **Intelligent automation**
  - [Configuration](toolbox/configurators.md) requirements reduced by 99%, simplified [JavaScript](resources/javascript.md)
    setup and automatic [I18n](resources/i18n.md)) loading.
- **Simplified user interaction**
  - You solely need the [pagy](toolbox/paginators.md) method and
    the [@pagy](toolbox/helpers.md) instance, to paginate any collection, and use any navigation
    tag and helper.
- **[Self-explaining API](https://github.com/ddnexus/pagy#examples)**
  - Explicit and unambiguous renaming reduces the need to consult the documentation.
- **New and simpler [documentation](guides/quick-start.md)**
  - Very concise, straightforward, easy to navigate and understand.
- **Effortless [overriding](guides/how-to#override-pagy-methods)**
  - The new methods have narrower scopes and can be overridden without deep knowledge.

Take a look at the [Examples](https://github.com/ddnexus/pagy#examples) for a quick overview.

## Breaking changes

See the [Upgrade Guide](guides/upgrade-guide)

## Changes (TL;DR)

- **The Countless pagination remembers the last page**
  - Pagination navs now allow jumping forward after navigating back a few pages.
- **Javascript refactoring**
  - The new `Pagy.sync_javascript` function used in the `pagy.js` initializer, avoids complicated configurations.
  - Added the plain `pagy.js` and relative source map files.
- **I18n refactoring**
  - No setup required: the locales and their pluralization are autoloaded when your app uses them.
  - You can easily override the lookup of locale files with `Pagy::I18n.pathnames << my_dictionaries`.
- **HTML and CSS refactoring**
  - Stylesheets are now based on CSS properties and calculations, for easer customizstion.
  - The new PagyWand interactive tool generates the CSS Override for your custom styles, and provides live feedback right in your app.
- **Playground apps**
  - Better usability and styles
- **Boostrap and Bulma**
  - Fixed a few style glitches.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
