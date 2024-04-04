---
icon: versions-24
---

# CHANGELOG

## ⚠ WARNING

We may drop pagy's less used CSS extras.

If you wish to keep them alive, please, [vote here](https://github.com/ddnexus/pagy/discussions/categories/survey).

## Breaking Changes

If you upgrade from version `< 8.0.0` see the following:

- [Breaking changes in version 8.0.0](#version-800)
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

## Version 8.0.1

- Reorganize the gem root dir: it was the lib dir (containing everything), now is the gem dir (containing lib and everything
  else).
- Fix broken link in README

## Version 8.0.0

### Breaking changes

- Renamed/removed the following arguments for all the helpers:
  - Search `pagy_id:`, replace with `id:`
  - Search `nav_aria_label:`, replace with`aria_label:`
  - The `nav_i18n_key` has been removed: pass the interpolated/pluralized value as the `aria_label:` argument
  - The `item_i18n_key` has been removed: pass the interpolated/pluralized value as the `item_name:` argument
  - The `link_extra:` has been removed: its cumulative mechanism was confusing and error prone. The `:anchor_string` pagy
    variable substitutes it, however it's not an helper argument anymore, so you can assign it as the `DEFAULT[:anchor_string]`
    and/or pass it as any other pagy variable at object construction. (
    See [customize the link attributes](https://ddnexus.github.io/pagy/docs/how-to/#customize-the-link-attributes))
- HTML structure, classes and internal methods have been changed: they may break your views if you used custom stylesheets,
  templates or helper overrides. See the complete changes below if you notice any cosmetic changes or get some exception.
- The `navs` and `support` extras has been merged into the new [pagy extra](https://ddnexus.github.io/pagy/docs/extras/pagy).
  Search for `"extra/navs"` and
  `"extras/support"` and replace with `"extras/pagy"` (remove the duplicate if you used both)
- The build path for javascript builders has been updated to the canonical paths for gems, and has moved from the `lib` to
  the gem root. Notice that the correct setup in `package json` was still wrongly wrapped in the `gem` dir for 8.0.0-8.0.1, and it
  has finally been fixed in 8.0.2 (sorry for that):
  - 8.0.0-8.0.1 only: `build: "NODE_PATH=\"$(bundle show 'pagy')/gem/javascripts\" <your original command>"`
  - 8.0.2+: `build: "NODE_PATH=\"$(bundle show 'pagy')/javascripts\" <your original command>"`

### Changes

- Streamlined HTML and CSS helper structure. You may want to look at the actual output by running
  the [pagy demo](https://ddnexus.github.io/pagy/playground.md#3-demo-app)
  - The `pagy_nav` and `pagy_nav_js` helpers output a series of `a` tags inside a wrapper `nav` tag (nothing else)
  - The disabled links are so because they are missing the `href` attributes. (They also have the `role="link"`
    and `aria-disabled="true"` attributes)
  - The `current` and `gap` classes are assigned to the specific `a` tags
  - HTML changes
    - All the pagy helper root classes have been changed according to the following rule. For example:
      - `"pagy-nav"` > `"pagy nav"`
      - `"pagy-bootstrap-nav-js"` > `"pagy-bootstrap nav-js"`
      - and so on for all the helpers
    - The `active` class of the `*nav`/`*nav_js` links as been renamed as `current`
    - The `disabled`, `prev`, `next` and `pagy-combo-input` link classes have been removed (see
      the [stylesheets](https://ddnexus.github.io/pagy/docs/api/stylesheets/#pagy-scss) for details)
    - The `rel="prev"` and  `rel="next"` attributes have been dropped (they are obsolete)
    - The `<label>`/`</label>` and `<b>`/`</b>` wrappers in the dictionary files have been removed
- The `pagy_link_proc` method (only used internally or in your custom overriding) has been renamed to `pagy_anchor` and it works
  slighty differently:
  - The `link_extra:` key argument has been removed
    - The `extra` positional argument of the returned lambda has been removed
    - The `classes:` and `aria_label:` keyword arguments have been added to the returned lambda
- The `nav_aria_label_attr` method has been renamed as `nav_aria_label`
- The internal `prev_aria_label_attr` and `next_aria_label_attr` methods have been removed
- The `gap` in the nav bars is a disabled anchor element (`a` tag without a `href` attribute)
- The `pagy_prev_html` and `pagy_next_html` have been renamed as `pagy_prev_a` and `pagy_next_a`
- The `pagy_prev_link_tag` and `pagy_next_link_tag` have been renamed as `pagy_prev_link` and `pagy_next_link`
- The `*combo_nav_js` and `pagy_items_selector_js` helpers use a more efficient code
- The `src/pagy.ts` and relative built javascript files have been adapted to the above changes
- The [stylesheets](https://ddnexus.github.io/pagy/docs/api/stylesheets/) are a lot simpler as a consequence of the changes above
- All the `*combo-nav_js` of the framework extras use simpler structure and improve the look and feel consistently with their
  respective frameworks
- All the frontend extra have been normalized and are totally consistent with each other; a few may add the `classes:`
  argument to a few components, when the framework allows it.
- Created the [pagy playground](https://ddnexus.github.io/pagy/playground) system of apps working with the `pagy` executable.
- Internal renaming `FrontendHelpers` > `JSTools`
- Fix broken link of pagy.rb in docs (closes #668, #669)
- Docs Improvements
- Better code issue template

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md) 
