---
icon: versions-24
---

# CHANGELOG

## Breaking Changes

If you upgrade from version `< 8.0.0` see the following:

- [Breaking changes in version 7.0.0](#version-800)
- [Breaking changes in version 7.0.0](CHANGELOG_LEGACY.md#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY.md#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY.md#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY.md#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY.md#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY.md#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY.md#version-100)

## Deprecations

None
<hr>

## Breaking changes

- Renamed/removed the following arguments for all the helpers:
  - Search `pagy_id:`, replace with `id:`
  - Search `nav_aria_label:`, replace with`aria_label:`
  - The `nav_i18n_key` has been removed: pass the interpolated/pluraized value as the `aria_label:` argument
  - The `item_i18n_key` has been removed: pass the interpolated/pluralied value as the `item_name:` argument
  - The `link_extra:` has been removed: its cumulative mechanism was confusing and error prone. The `:anchor_string` pagy
    variable substitutes it, however it's not an helper argument anymore, so you can assign it as the `DEFAULT[:anchor_string]`
    and/or passing it as any other pagy variable at object construction . (see ...)
- HTML structure, classes and internal methods have been changed: they may break your views if you used custom stylesheets, 
  templates or helper overrides. See the complete changes below if you notice any cosmetic changes or get some exception.
- The `navs` and `support` extras has been merged into the new `compoenents` extra. Search for `"extra/navs"` and 
  `"extras/support"` and replace with `"extras/pagy"` (removing duplicates if you used both) 

## Changes

- Streamlined HTML and CSS helper structure. You may want to look at the actual output by running the single-file self-contained 
  app [!file](/lib/apps/demo.ru)
  - The `pagy_nav` and `pagy_nav_js` are a series of `a` tags inside a wrapper `nav` tag (nothing else there)
  - The disabled links are so because they are missing the `href` attributes
  - The `pagy`, `pagy-nav` and `pagy-nav-js` classes are assigned to the `nav` tag
  - The `current`, `gap` classes are assigned to the specific `a` tags
  - HTML changes
    - All the pagy helper root classes have been changed according to the following rule. For example:
      - `"pagy-nav"` > `"pagy nav"`
      - `"pagy-bootstrap-nav-js"` > `"pagy-bootstrap nav-js"`
      - and so on for all the helpers
    - The `active` class of the `*nav`/`*nav_js` links is now `current`
    - The `disabled`, `prev` and `next` link classes have been removed
    - The `pagy-combo-input` class has been removed
    - The `rel="prev"` and  `rel="next"` attributes have been dropped (they don't do anything anymore)
    - The `\<label>`/`\</label>` and `\<b>`/`\</b>` wrappers the dictionary files have been removed
- The `pagy_link_proc` method (only used internally or in your custom overriding) has been renamed to `pagy_anchor`and it works
  slighty differently:
  - The `link_extra:` key argument has been removed
    - The `extra` positional argument of the returned lambda has been removed
    - The `classes:` and `aria_label:` keyword arguments have been added to the returned lambda
- The `nav_aria_label_attr` method has been renamed as `nav_aria_label`
- The internal `prev_aria_label_attr` and `next_aria_label_attr` methods have been removed
- The `gap` in the nav bars is a disabled anchor element (`a` tag without a `href` attribute`)
- The `pagy_prev_html` and `pagy_next_html` have been renamed as `pagy_prev_a` and `pagy_next_a`
- The `pagy_prev_link_tag` and `pagy_next_link_tag` have been renamed as `pagy_prev_link` and `pagy_next_link`
- The `*combo_nav_js` and `pagy_items_selector_js` helpers use a more efficient mechanism
- The `src/pagy.ts` and relative built javascript files have been adapted to the above changes
- The stylesheets are a lot simpler as a consequence of the changes above
- All the `*combo-nav_js` in the framework extras use simpler structure and improve the look and feel consistently with their
  respective frameworks
- All the frontend extra have been normalized and are totally consistent with each other, a few may add the `classes:` argument to a few components, when the framework allows it.
- Created `demo.ru` and `repro.ru` out of heavy refactored standalone styles, with `pagy` bin utility launcher
- Internal renaming `FrontendHelpers` > `JSTools`

## Version 7.0.11

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md) 
