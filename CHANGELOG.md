---
icon: versions-24
---

# CHANGELOG

## Breaking Changes

If you upgrade from version `< 6.0.0` see the following:

- [Breaking changes in version 7.0.0](#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY.md#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY.md#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY.md#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY.md#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY.md#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY.md#version-100)

## Deprecations

None

<hr>

## Version 7.0.0

### Breaking changes

- Dropped old rubies support: Pagy follows the [ruby end-of-life](https://endoflife.date/ruby) supported rubies now.
- Renamed `:i18n_key` > `:item_i18n_key`
- Refactored `support` extra
  - Renamed `pagy_prev_link` to `pagy_prev_html` to avoid confusion with pagy_prev_link_tag
  - Removed `pagy_next_link` to `pagy_next_html` to avoid confusion with pagy_next_link_tag
- Rack 3 breaking changes:
  - The `headers` extra produces all lowercase headers, regardless how you set
    them [see rack issue](https://github.com/rack/rack/issues/1592)
  - Removed `:escaped_html` option from `pagy_url_for` (only breaking if you override the method or use the option directly)
- Dictionary structure changes: (affects only app with custom helper/templates/dictionary entries)
  - The `nav` entry has been flattened: `pagy.nav.*` entries are now `pagy.*`:
    - If you have custom helpers/templates: search the keys that contain `'.nav.'` and replace them with `'.'`
    - If you have custom dictionary entries (overrides): remove the `'nav:'` line and unindent its block
  - A few labels used as `aria-label` have been added: you may want to add/use them to your custom helper/templates/dictionaries
    for ARIA compliance.
    - `pagy.aria_label.nav` Pluralized entry: used in the `nav` element
    - `pagy.aria_label.prev`, `pagy.aria_label.next` Single entry: used in the prev/next `a` link elements

### Default changes (possibly breaking test/views)

- Changed `Pagy::DEFAULT[:size]` variable defaults from `[1, 4, 4, 1]` to `7`. You can explicitly set/restore it in the
  initializer, if your app was relying on it.
- Added sensible `:size` defaults in Calendar Unit subclasses. You can explicitly set it in the initializer, if your app was
  relying on it.
  - `Pagy::Calendar::Day::DEFAULT[:size]` `31`
  - `Pagy::Calendar::Month::DEFAULT[:size]` `12`
  - `Pagy::Calendar::Quarter::DEFAULT[:size]` `4`
  - `Pagy::Calendar::Year::DEFAULT[:size]` `10`
- Changed a few `format` defaults in Calendar Unit subclasses. You can explicitly set it in the initializer, if your app was
  relying on it.
  - `Pagy::Calendar::Day::DEFAULT[:format]` from `'%Y-%m-%d'` to `'%d'`
  - `Pagy::Calendar::Month::DEFAULT[:format]` from `'%Y-%m'` to `'%b'`
  - `Pagy::Calendar::Quartr::DEFAULT[:format]` from `'%Y-Q%q'` to `'Q%q'`

### Visual changes (possibly breaking test/views)

- The ARIA label compliance required the refactoring of all the nav helper that might look slightly different now.
- The text for `"Previous"` and `"Next"` is now used for the `aria-label` and has been replaced in the UI as `<` and `>`. You can
  edit the dictionary entries if you want to revert it to the previous default (`< Prev` and `Next >`)

### Internal renaming of private methods (unlikely to break anything)

You should not have used any of the private methods, but if you did so, you will get a `NoMethodError`
(undefined method...) very easy to fix by simply renaming, because there are no changes in the logic.

### Changes

- [ARIA compliance](https://ddnexus.github.io/pagy/docs/api/aria/)
- Removed the pagy templates: they were a burden for maintenance with very limited usage.
- Internal renaming of private frontend methods

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md) 
