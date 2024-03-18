---
icon: versions-24
---

# CHANGELOG

## Breaking Changes

If you upgrade from version `< 7.0.0` see the following:

- [Breaking changes in version 7.0.0](#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY.md#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY.md#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY.md#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY.md#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY.md#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY.md#version-100)

## Deprecations

- The "pagination" CSS class for the `pagy_nav`, `pagy_nav_js` and `pagy_combo_nav_js` has been deprecated and will be removed in
  version 8. Replace it with the new "pagy" CSS class added also to the `pagy-items-selector-js`.

<hr>

## Version 7.0.11

- Fix jsonapi prev and next keys for unavailable links (#665)
- Docs fixes

## Version 7.0.10

- Added name attribute to combo and items input tags; removed pagy_marked_link and refactored js input action

## Version 7.0.9

- Improve all pagy apps
- Normalized bootstrap, bulma, foundation, navs extra

## Version 7.0.8

- Update gems and fix a rubocop bug
- Add all styles to pagy_styles.ru
- Better pagy stylesheets
- Fix for uikit extra prev and next link duplicating chevrons
- Change aria_Label to aria_label for Arabic locale (#657)

## Version 7.0.7

- Fix for retype exluding linked files and showing category images
- Fix for first *nav_js page not active with trim (introduced with the #656 fix 7e2f118)
- Normalize pagy apps; implement pagy_styles.ru

## Version 7.0.6

- Internal renaming of frontend constants
- Fix for disabled links and missing or extra ARIA attributes in frontend extras
- Boostrap fix for current page link; pagy.js fix for trim of current page (closes #656)

## Version 7.0.5

- Updated gems, npm modules, contributors
- Added the pagy stylesheets to the gem, updated apps, docs and manifest
- Added note for the metrics and compacted the chart section (closes #652)
- Docs: fix formatting, grammar in README.md (#654)
- Add note about PR base branches to readme (#653)

## Version 7.0.4

- Tailwind styles integrated with the pagy-items-selector-js (#646)
- Deprecated the "pagination" CSS class, use the "pagy" CSS class that has been added to all the interactive pagy helper outputs
- Fix indentation of cs locale (#648); add "pagy.aria_label.nav.few" entry, duplicating the "other" pluralization
- Update cs translations (#648)
- Expand/Correct changes about `pagy.prev` and `pagy.next` (#649)

## Version 7.0.3

- Remove extra space in `pagy_nav`, `pagy_nav_js` and `.pagy-combo-input`
- Refactor of tailwind styles and docs (closes #646)
- Add `pagy_tailwind_app.ru` (#646)
- Add missing CSS breaking change to the CHANGELOG (#646)

## Version 7.0.2

- Fix for missing to fetch count_args default (close #645)
- Non-code improvements

## Version 7.0.1

- Updates ckb translations to be complaint with ARIA in v7.x.x (#643)

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

- The ARIA label compliance required the refactoring of all the nav helpers that might look slightly different now:
- The text for `"Prev"` and `"Next"` is now used for the `aria-label` (actually as `"Previous"` and `"Next"`) and has been
  replaced in the UI as `<` and `>`. You can edit the dictionary entries `pagy.prev` and `pagy.next` if you want to revert it to
  the previous default (`&lsaquo;&nbsp;Prev` and `Next&nbsp;&rsaquo;`)

### CSS changes (possibly looking different/broken)

- The HTML of the current page in `pagy_nav` and `pagy_nav_js` has been changed from simple text (e.g. `5`) to a
  disabled link (e.g. `<a role="link" aria-disabled="true" aria-current="page">5</a>`). That affects your CSS rules and
  the old tailwind examples targeting the page links, now overreaching the current page.
  - You may fix eventual problems either by replacing the affected `a` rules with narrower `a[href]` selectors however if you use
    Tailwind we recommend to use the [improved tailwind style](https://ddnexus.github.io/pagy/docs/extras/tailwind/), that you can
    adapt in no time to anything you need.
- The extra spaces added between pages of `pagy_nav` and `pagy_nav_js` have been removed
- The `pagy-combo-nav-js .pagy-combo-input` internal element x-margins have been removed

### Internal renaming of private methods (unlikely to break anything)

You should not have used any of the private methods, but if you did so, you will get a `NoMethodError`
(undefined method...) very easy to fix by simply renaming, because there are no changes in the logic.

### Changes

- Added `:count_args` variable passed to the `collection.count(...)` statement (avoids overriding of `pagy-gets-vars` and
  expands count capabilities)
- [ARIA compliance](https://ddnexus.github.io/pagy/docs/api/aria/)
- Removed the pagy templates: they were a burden for maintenance with very limited usage,
  still [you can use them](http://ddnexus.github.io/pagy/docs/how-to/#using-your-pagination-templates)
- Added a simpler and faster nav without gaps (just pass an integer to the `:size`)
- Internal renaming of private frontend methods
- Updated code and tests for latest gem and npm module versions
- Internal improvements of automation scripts

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md) 
