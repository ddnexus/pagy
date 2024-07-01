---
icon: versions-24
---

# CHANGELOG

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

- The `foundation`, `materialize`, `semantic` and `uikit` CSS extras have been discontinued and will be removed in v9
  (See the [details](https://github.com/ddnexus/pagy/discussions/672#discussioncomment-9212328))
- Protected method `Pagy#setup_pages_var`. Use `Pagy#setup_last_var` instead
- **Javascript files renamed**
  - `pagy.js`: use `pagy.min.js`
  - `pagy-module.js`: use `pagy.mjs`
  - `pagy-dev.js`: use the `pagy.min.js`with the `pagy.min.js.map`
  - `pagy-module.d.ts`: use `pagy.d.ts`
- The Array type for the `:size` (e.g. `size: [1, 4, 4, 1]`) that generates the classic bar. Use the `:size` set to an integer 
  with the `ends: true` variable (which are the default since 8.4.6). If a legacy bar it will remain REALLY a requirement, add 
  `require 'pagy/extras/size` to your `pagy.rb` initalizer for smooth upgrades. (see [size extra](https://ddnexus.github.io/pagy/docs/extras/size))
<hr>

## Version 8.6.1

- Update playground apps and e2e tests
- Update pagy.rb initializer

## Version 8.6.0

- Add translated pluralized aria_label.nav for "ar" locale (close #577)
- Deprecate the legacy bar. Insert first and last pages and gaps when needed into the simple bar

## Version 8.5.0

- Improve pagy playground launcher
- Refactor calendar class structure
- Remove automatic skipping of bundle install in playground apps
- Update ruby calendar test
- Update cypress calendar test
- Refactor calendar test environment to use activerecord
- Add code for calendar counts
- Remove redundant Warning
- Convert calendar.ru to calendar_rails.ru

## Version 8.4.5

- Fix pluralization rule link on locale files (#716)
- Install gems in pagy CI
- Indentation changes
- Remove :cycle false default
- Fill aria_label.nav ca pluralized entry (#715) (Fixes #581)
- Fix typos (#710)

## Version 8.4.4

- Update eslint: new configuration, stricter rules and javascript code

## Version 8.4.3

- Deprecate/rename javascript files keeping copies of old files to avoid production breaking changes; updates playground apps

## Version 8.4.2

- Limit the playground --rerun option to linux platforms
- Simplify and improve the js environment by using bun

## Version 8.4.1

- Fix pagy.in in pagy_get_items method  introduced in 8.4.0 (see #696) (closes #704) (closes #708) (#707)
- Fix renamed Frontend Helpers to JS Tools and typo `next_a` "aria-label" (#700)
- Fix rubocop

## Version 8.4.0

- Retrieve only @in items:
  - improve the performance of the last page in
  particular storage conditions (see #696)
- Improve pagy launcher for pagy devs

## Version 8.3.0

- Discontinue foundation materialize, semantic and uikit CSS extras
- Improve playground:
  - Add install option (automated in pagy development)
  - Fix HTML validation for all apps
  - Remove unused styles from the demo app
- Hardcode version in pagy.gemspec

## Version 8.2.2

- Add nav translation for ko (closes #592) (#690)

## Version 8.2.1

- Fix empty page param raising error (closes #689)

## Version 8.2.0

- Fix the '#pagy_url_for' method for calendar pagination (#688)
- Extend the use of pagy_get_page to the arel, array and countless extras
- Add the pagy_get_count method to the backend

## Version 8.1.2

- Added "da" locale for aria_label.nav (closes #583)

## Version 8.1.1

- Fixed broken aria-label for disabled links in Foundation (#685)
- Simplification of input variables and defaults: params and request_path are not instance variables

## Version 8.1.0

- Implement max_pages to limit the pagination regardless the actual count
- Improve efficiency of params in pagy_url_for
- Remove nil variables from DEFAULT
- Removed redundant @pages, aliased with @last

## Version 8.0.2

- Minor change in rails app and RM run config
- Fix canonical gem root:
  - Correct script.build: "NODE_PATH="$(bundle show 'pagy')/javascripts"
  - Move pagy.gemspec inside the gem root dir
- Fix for Turbo not intercepting changes in window.location
- Use require_relative for gem/lib files
- Complete translation of aria.nav for "ru" locale (close #599)
- Docs improvement and fixes

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
  Search for `"extras/navs"` and
  `"extras/support"` and replace with `"extras/pagy"` (remove the duplicate if you used both)
- The `"extras/frontend_helpers"` has been renamed to `"extras/js_tools"`
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
  slightly differently:
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
