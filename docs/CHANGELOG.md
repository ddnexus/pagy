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

Given a version number `MAJOR.MINOR.PATCH` (e.g. `43.0.0-pre.1`):

The `gem 'pagy', '~> 43.0'` Gemfile entry (without the PATCH number) ensures that the `bundle update` command will update pagy to
the most recent version WITHOUT BREAKING CHANGES.

Increment the MAJOR version in your Gemfile ONLY when you are ready to handle the BREAKING CHANGES.

## Breaking Changes

If you upgrade from version `< 43.0.0` see the following:

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

## Version 43.0.0-pre.1

We needed a leap version to unequivocally segnaling that it's not just a major version: it's a complete redesign of the legacy
code at all levels, usage and API included.

**Why 43?** Because it's exactly one step beyond _"The answer to the ultimate question of life, the Universe, and everything."_ 😉

## Breaking changes

See the [Upgrade Guide](guides/upgrade-guide)

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
  - Stylesheets are now based on CSS properties and calculations, for easer customizstion.
  - The new PagyWand interactive tool generates the CSS Override for your custom styles and provides live feedback right in your
    app.
- **Playground apps**
  - Better usability and styles
- **Boostrap and Bulma**
  - Fixed a few style glitches.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
