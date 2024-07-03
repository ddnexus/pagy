---
icon: versions-24
---

# CHANGELOG

## Breaking Changes

If you upgrade from version `< 9.0.0` see the following:

- [Breaking changes in version 9.0.0](#version-900)
- [Breaking changes in version 8.0.0](CHANGELOG_LEGACY.md#version-800)
- [Breaking changes in version 7.0.0](CHANGELOG_LEGACY.md#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY.md#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY.md#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY.md#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY.md#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY.md#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY.md#version-100)

## Deprecations

- None

## Version 9.0.0

### Breaking Changes

- The `foundation`, `materialize`, `semantic` and `uikit` CSS extras have been removed:
  (See the [reasons](https://github.com/ddnexus/pagy/discussions/672#discussioncomment-9212328))
- Protected method `Pagy#setup_pages_var` have been removed: use `Pagy#setup_last_var` instead
- **Javascript renamed files**
  - `pagy.js`: use `pagy.min.js`
  - `pagy-module.js`: use `pagy.mjs`
  - `pagy-dev.js`: use the `pagy.min.js`with the `pagy.min.js.map`
  - `pagy-module.d.ts`: use `pagy.d.ts`
- The Array type for the `:size` (e.g. `size: [1, 4, 4, 1]`) that generates the classic bar is not supported anymore: use the 
  `:size` set to an integer with the `ends: true` variable (which are the default since 8.4.6). If a legacy bar remains REALLY 
  a requirement, add `require 'pagy/extras/size` to your `pagy.rb` initalizer. (See the [size extra](https://ddnexus.github.io/pagy/docs/extras/size))
- The `DEFAULT[:anchor_string]` has been dropped.
- The `:anchor_string` is not an instance variable anymore, but a keyword argument for all the helpers, because it is
  frontend code (see the [discussion](https://github.com/ddnexus/pagy/discussions/719)). Instead of passing it to the `pagy*`
  method in the controller, pass it to any `pagy_*nav` method in the view.
<hr>

## Version 8.6.3

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
