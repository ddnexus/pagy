---
icon: versions-24
layout: page
visibility: hidden
---

# LEGACY CHANGELOG

## Version 8.6.3

- Add missing DEFAULT[:max_pages] hint to the config/pagy.rb
- Improve activerecord handling in playground apps
- Fix the missing "ar.pagy.aria_label.nav.other" (closes #577)

## Version 8.6.2

- Fix the legacy size in code and test
- Improve code readability and size check in series
- Fix the old terminology in the demo.ru app

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

- Fix for retype excluding linked files and showing category images
- Fix for first *nav_js page not active with trim (introduced with the #656 fix 7e2f118)
- Normalize pagy apps; implement pagy_styles.ru

## Version 7.0.6

- Internal renaming of frontend constants
- Fix for disabled links and missing or extra ARIA attributes in frontend extras
- Bootstrap fix for current page link; pagy.js fix for trim of current page (closes #656)

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

## Version 6.5.0

- Add ckb: "pagination" entry (#641)

## Version 6.4.4

- Adapt pagy-ci workflow to run on current gemfile (no-failure for new gems enabled in leading version)
- Fix for wrong arguments types in meilisearch pagy_search extension

## Version 6.4.3

- Exclude coverage for prepend conditional, ruby < 3.0 syntax for prepend

## Version 6.4.2

- Better module overrides in jsonapi
- Replaced the is_a?(Hash) check for jsonapi reserved :page param with respond_to?(:Fetch) and prepended to the Frontend
- Docs improvements and fixes

## Version 6.4.1

- Remove dependency on base64 (#618)Ruby 3.3 prints a warning if base64 is used without specifying it in the gemfile.
  Ruby 3.4 will error

## Version 6.4.0

- Implement JSON:API specifications
- Added simpler nav generation, triggered by setting the size variable to a positive Integer
- Fix for pagy_calendar_app.ru

## Version 6.3.0

- Calendar improvements:
  - Added the :fit_time option to page_at and pagy_calendar_url_at methods. It avoids the OutOfRangeError by returning the first or last page
  - Added starting_time_for and page_offset_at feedback methods to the Calendar base class
  - Prepended the pagy_calendar_url_at to the Frontend and Backend
  - Added calendar showtime
- Updated node modules (dev on node 20)
- Updated Gemfile and fixed new rubocop complaints

## Version 6.2.0

- Add Belarusian locale (#567)
- Reordered RubyMine tasks (fix #541)

## Version 6.1.0

- Add Vietnamese locale (#550)
- Maintenance (docs, test, gems and node modules updates) fixes and improvements

## Version 6.0.4

- Updated gems and npm modules
- fix: Extras::Trim - fix trimming first page (#516)
- Fix for new rubocop

## Version 6.0.3

- Updated Gemfile and npm modules
- Improved Danish translation (#502)

## Version 6.0.2

- Fix: foundation combo helper (#469)

## Version 6.0.1

- Fix for pagy_bootstrap_combo_nav_js disabled input in certain bootstrap versions
- Fix for wrong module in standalone extra
- Fix for broken links in code comments and docs

## Version 6.0.0

### Breaking changes

Removed support for the deprecation of `5.0`:

- The `pagy_massage_params` method: use the `:params` variable set to a lambda `Proc` that does the same (but per instance). See [How to customize the params](https://ddnexus.github.io/pagy/docs/how-to#customize-the-params).
- The `activesupport` core dependency is now an optional requirement if you use the calendar: you must add `gem 'activesuport'` to your Gemfile if your app doesn't use rails.
- The plain `Time` objects in the `:period` variable: use only `ActiveSupport::TimeWithZone` objects.
- The `:offset` variable used by the `Pagy::Calendar::Week`: set the `Date.beginning_of_week` variable to the symbol of the first day of the week (e.g. `Date.beginning_of_week = :sunday`). Notice the default is `:monday` consistently with the ISO-8601 standard (and Rails).
- The `Pagy::DEFAULT[:elasticsearch_rails_search_method]`: use `Pagy::DEFAULT[:elasticsearch_rails_pagy_search]` instead.
- The `Pagy::DEFAULT[:searchkick_search_method]`: use `Pagy::DEFAULT[:searchkick_pagy_search`] instead.
- The `Pagy::DEFAULT[:meilisearch_search_method]`: use `Pagy::DEFAULT[:meilisearch_pagy_search]` instead.

#### Suggestions for a smooth removal of deprecations from pagy 5

- Upgrade to the latest version of pagy 5 (5.10.1)
- Run your tests or app
- Check the log for any deprecations message starting with '[PAGY WARNING]'
- Update your code as indicated by the messages
- Ensure that the log is now free from warnings
- If you are overriding the `pagy_url_for` method ensure you [add the extra parameters required.](https://github.com/ddnexus/pagy/discussions/424).
- Upgrade to pagy 6

### Changes

- Added new doc changes
- Replaced the gitter support with the Q&A discussion links
- reorganized cypress tests
- Updated run configurations
- Fix for bump.sh
- Add Meilisearch finite pagination by default in the meilisearch extra (#417)
- Allowing users to override the request path (#404)(squashed)
- Fix the args in the Pagy::Countless#series override (#411)(fixes #410)
- update: pagy_bare_rails script: for db testing (#379)
- Fix rubocop glitch
- added specific typescript installation to pagy-ci
- Chore: update github action versions to latest
- Reorganized pnpm setup and updated pagy.js to the new parcel default
- Reduced the error level for eslint rules
- Add Dependabot for GitHub Actions (#392)
- Fix NoMethodError when page param is hash (#390)
- Removed deprecated variables for the search extras
- Removed deprecated :offset variable for Calendar::Week
- Removed deprecated support for Time instances
- Removed activesupport hard dependency
- Removed support for deprecated pagy_massage_params
- fixup .gitignore
- Dropped docker env support
- Calendar code cleanup and normalization
- Implementation of calendar extra feature: pagy_calendar_url_at; refactoring and testing of the calendars files
- Pagy::Calendar::*: Simpler code and improved readability
- Added Pagy::Calendar#page_for(time) helper
- Fix for ignored pnpm files from other branch
- Updated cypress action
- Updated node modules and cypress 12
- Updated gems and rubocop config
- Remove aria-label="pager" (#412)
- Update korean translation (#413)
- Fixed small typo in German (#409)
- fix: Added Norwegian Nynorsk translation (#408)* Added Norwegian Nynorsk translation
- Fix Pagy configuration and documentation for renamed "pagy/extras/shared" to "pagy/extras/frontend_helpers" (#399)
- update link: to referenced rails apps (#384)
- Added reference to avoid N+1 queries when using `includes` (closes #378)
- Fix for broken links in docs
- Added note about overriding the `pagy_headers` method in the `headers` extra
- Bundle and npm updates
- Add: documentation changes (#376)
- Added post link in README; fix for another example in how-to.md
- Fix for example in how-to.md (closes #373)
- Added missing info
- Fix: docs - typo, minimise ambiguity (#372)

## Version 5.10.1

- Changed default for :meilisearch_search method to always defined :ms_search method

## Version 5.10.0

- Adjusted Psych::VERSION condition to avoid deprecations
- Improvement of search extras: (closes #367) (closes #369)
  - Added DEFAULT[:*_search] variables used to call the original :search method
  - Deprecated and renamed DEFAULT[:*_search_method] to DEFAULT[:*_pagy_search]
  - Updated config, docs and CHANGELOG deprecations
- Fix for wrong calculation of :page in Pagy.new_from_meilisearch (closes #368)
- Faster assignment of javascript path
- Simplified webpack config, added rollup config and normalized doc
- Better javascript doc (closes #365)
- Added specific webpack javascript configuration info; a few minor doc adjustments
- Added specific webpack javascript configuration info
- Update javascript.md (#362)

## Version 5.9.3

- Fix for too generalized html_escape in pagy_url_for. (closes #363)
- Docs updates

## Version 5.9.2

- Added info about using pagy-module.js with importmap
- Bundle and npm update
- Fix for non escaped query strings in links
- Small improvements in src files
- Added legacy methods to use the javascript files
- Added missing require in docs
- Updated docs with the proper way to use pagy with esbuild
- Docs improvements
- Improved the javascript files docs and moved into the lib/javascripts/README.md file

## Version 5.9.1

- Updated build.sh to set window.Pagy in pagy-dev.js
- Update pagy.md (#360)
- Minor - fix syntax highlighting (#361)
- Updated info about the current way to use pagy.js with jsbuilder-rails/esbundle

## Version 5.9.0

- Npm and bundle update
- Fix and refactoring of pagy calendar calculation of local time (closes #358):
  - The `Pagy::Calendar::*` classes require ActiveSupport (temporarily added activesupport dependency that will e replaced in 6.0)
  - The `:period` items can be `Time` or `TimeWithZone` objects (which work across DST ranges)
  - Deprecated use of `:offset` to set the first weekday, in favour of `Date.beginning_of_week` (default to `:monday`)
  - Added DST specific tests
  - Fix for calculation of label quarter
  - Updated docs and tests
- Fix for wrong offset in gearbox extra (closes #356)
- Reduced the public interface of pagy.js and relative files to just `version` and `init()`
- Add Ruby 3.1 to CI (#354)

## Version 5.8.1

- Shorter warning messages and minified pagy.js
- Fix for wrong decoding of non latin charsets

## Version 5.8.0

- The JSON in data-pagy attributes is base64 encoded: it is smaller than HTML escaped and it avoids crawlers to follow look-alike links
- Removed redundant PagyJSON type

## Version 5.7.6

- Updated Gemfile.lock and package-lock.json
- Broader browserslist and better doc for javascript
- Updated build.sh
- Improvement of pagy.ts:
  - Moved warn() out of init()
  - More inclusive try block
  - Simplified rjsObserver function
  - Replaced getOwnPropertyNames with keys
- Fix for missing entry in CHANGELOG.md

## Version 5.7.5

- Fix for unwanted offset in source map data

## Version 5.7.4

- Added parcel-plugin-nuke-dist
- Renamed pagy.mjs -> pagy-module.js; added TypeScript declaration file and build.sh

## Version 5.7.3

- npm update
- Simper pagy-dev.js; added pagy.mjs module
- Updated .eslintrc.json and package.json files

## Version 5.7.2

- Simplified keyword naming
- Better compilation and development support for pagy.js. Replaced babel with parcel.

## Version 5.7.1

- Simpler syntax for nav js helpers
- Added input e2e test file
- Simpler abstraction of input based js helpers

## Version 5.7.0

- Bundle and npm update
- TypeScript/Javascript improvements:
  - More efficient handling of responsive *nav_js helpers
  - Replaced window resize event listener with ResizeObserver
  - More robust input based js helpers (catching possible invalid user input)
  - Improved typing, function naming
  - Added error catching

## Version 5.6.10

- Improvement and fixes for client-side related structure
- Replaced e2e/cy script with a couple of npm scripts backed by the start-server-and-test
- Added trim test for items_selector_js; cleanup of e2e dir
- Normalized json files indentation
- Added trim to e2e tests
- Reorganized cypress tests: faster and more accurate
- Simpler pagy.ts

## Version 5.6.9

- Better doc for e2e related commands in docker/README.md
- Updated package-lock.json and improved ci-cache.sh
- Used better syntax and code style in typescript files
- Updated copyright year
- Refactoring of typescript related files and dirs:
  - Moved e2e dir in the project root
  - Added typescript linting plugins and configuration
  - Converted all the e2e test to typescript
- Updated Docker, VSC and .idea configurations

## Version 5.6.8

- Reorganized TypeScript/JavaScript with npm workspaces and better script naming
- Fix typo in gemspec
- Better typescript configuration with source maps and declarations

## Version 5.6.7

- GitHub Actions: added quotes to version ruby 3.0
- Added typescript + babel environment for better pagy.js
- Updated e2e environment
- Updated gemfiles
- Fix for support doc snippets and other typos
- Minor update of gemfiles and docs
- Added more gemspec metadata entries (closes #351)

## Version 5.6.6

- Docs improvements
- Added **_ to series and sequels
- Updated rematch and gemfiles
- Updated release-gem.yml workflow

## Version 5.6.5

- Improved a few code comments; added post link in README
- Full name for translate, aliased as t
- Added check for no calendar units in pagy_calendar configuration
- Updated gemfiles
- Small docs layout adjustment

## Version 5.6.4

- Updated RM run configurations
- Fix for missing innerHTML reset, unintentionally committed during a cleanup (closes #350)
- Updated gemfiles, docs and comments

## Version 5.6.3

- Improved readability and efficiency of calendar files
- Fix for English spelling in local variable name

## Version 5.6.2

- Updated pagy.manifest for Tamil locale
- Add Tamil (ta) translation (#349)
- Internal changes in calendar files:
  - Simpler calculations for month mixin
  - Normalized naming of non-api methods
  - Better comments
- Pagy::I18n: small performance improvement
- Docs reorganization
- Update paths_ignore for skip CI and docs

## Version 5.6.1

- Updated cypress and bundler
- Improved efficiency of unit labelling and support for custom calendar unit sub formats
- Added missing initializer default for calendar quarter and missing doc for custom units

## Version 5.6.0

- Updated gemfiles
- Updated docs
- Added calendar quarter tests
- Internal calendar refactoring to allow custom units; added quarter unit

## Version 5.5.1

- Docs updates
- upgrade bootstrap template navs: call pagy_link_proc with link_extra key (#348)
- Renamed internal #time_for -> #start_for
- Docs fixes and improvements

## Version 5.5.0

- Updated cypress and related packages
- **Calendar API: FINAL breaking changes** (stable from now on):
  - Refactoring of calendar classes and variables:
  - Moved calendar defaults from `Pagy::DEFAULT` to class-specific `Pagy::Calendar::*::DEFAULT`
  - Renamed variables:
    - `:minmax` -> `:period`
    - `:time_order` -> `:order`
    - `:week_offset` -> `:offset`
    - `:*_format` -> `:format`
  - Returning local time instead of UTC time for the utc accessors, now renamed:
    - `#utc_from` -> `#from` (use `from.utc` if you need it)
    - `#utc_to` -> `#to` (use `to.utc` if you need it)
  - Inverted the logic for the `:skip` key in the `#pagy_calendar` conf, now renamed:
    - `:skip` -> `:active`
  - Renamed methods:
    - `#pagy_calendar_minmax` -> `#pagy_calendar_period`
    - `#pagy_calendar_filtered` -> `#pagy_calendar_filter`
  - Added alternative way to delegate the localization to i18n without the i18n extra
  - Updated `pagy_calendar_app.ru`
  - Fix for wrong reordering in `:desc` order
  - Documentation fixes and improvements
  - Removed the warning for the API changes: the API is stable after these changes

## Version 5.4.0

- **Calendar API breaking changes** for refactoring of `Pagy::Calendar` and calendar extra:
  - Added complete compatibility with all the backend extras
  - Simpler usage with automatic handling of pagy objects
  - Less variables and simpler requirements for the methods to implement
- Updated gemfiles
- The localize method overridden by the i18n extra must receive a format
- Series and sequels use keyword arguments and pagy_*nav methods accepts a size keyword argument
- Docs improvements
- Removed unnecessary empty section in calendar docs
- Fixes for typos and misalignment

## Version 5.3.1

- Added screenshot to the calendar extra (closes #346)
- Added bump.sh script to bump the version in multiple files; check for consistency and optionally commit the changes
- Minor fixes
- Changelog improvements
- Reversed CHANGELOG (closes #345)
- Calendar I18n small internal renaming and docs improvements

## Version 5.3.0

- Implemented localization of time labels through the i18n extra delegation
- Renamed internal module and files of SharedExtra to FrontendHelpers
- Added support for `*nav_js` to Calendar
- Simplified page labelling, moved into the pagy classes and removed frontend methods
- Deprecated `pagy_massage_params`: use the :params variable set to a Proc that does the same, but per instance
- Added apps README
- Completed overflow fix for pagy Countless

## Version 5.2.3

- Fix for overflow :empty_page in regular Pagy instances, not returning an empty page
- docs: add tutorial, simplify header (#343)
- Refactoring of rails_inline_input.rb (include and close #342)

## Version 5.2.2

- Fix for missing defined?(Calendar) checks; small simplification in headers extra
- Calendar docs improvements and fixes

## Version 5.2.1

- Reorganization of mock collection classes; enabled rubocop layout in tests
- Small refactoring of the overview extra
- A few improvements for the Calendar pagination; added the current_page_label method

## Version 5.2.0

- Small changes in code; updated gemfiles, tests and docs
- Implemented calendar extra to paginate a Time periods by unit (year, month, week or day)
- Added pagy_labeler frontend method overridable for changing the link text from a simple page number to any arbitrary string
- Enabled rubocop Style/Documentation cop
- Updated npm modules and gemfiles
- Docker better mounts
- Used gem-generic release-gem action

## Version 5.1.3

- Added single action standalone rails_inline_output.rb
- Small improvements in code and docs
- Fix for rails problem with internal params in pagy URL (closes #341)
- Documentation improvements
- A few details tag in the README should be opened by default

## Version 5.1.2

- Refactoring of pagy_url_for and relative test:
  - Fix for ignoring the items_extra variable
  - Replaced request.GET with request.params to enable POST pagination
  - Refactoring of Mock test classes for better handling of params

## Version 5.1.1

- This reverts commit 1d77e672d5b7813108b40c13ca93fdec045f4c03.
  Generating the URL by using the application params method breaks rails apps because it requires manual changes in the apps.

## Version 5.1.0

- Fix and refactoring of pagy_url_for and relative test:
  - Fix for ignoring the params not coming from the request
  - Fix for ignoring the items_extra variable
  - Refactoring of Mock test classes for better handling of params
- Improved code comments, formatting and docs fixes
- Countless extra: simplified code, internal renaming of locals and docs update

## Version 5.0.1

- Updated docs and issue templates
- Added cypress-dark theme to e2e test
- Refactoring of coverage to include 100% of line and condition branches covered
- Simplification of metadata extra
- Refactoring of exceptions
- Added CHANGELOG_LEGACY

## Version 5.0.0

### Breaking changes - 1. Code update

Pagy 4 dropped the compatibility for old ruby versions `>2.5` and started to refactor the code using more modern syntax and paradigms and better performance. It deprecated the legacy ones, printing deprecation warnings and upgrading instruction in the log, but still supporting its legacy API. Pagy 5.0.0 cleans up and removes all that transitional support code.

The changes for upgrading your app cannot be fixed with simple search and replace, but fear not! Fixing them should just take a few minutes with the following steps:

- Upgrade to the latest version of pagy 4
- Run your tests or app
- Check the log for any deprecations message starting with '[PAGY WARNING]'
- Update your code as indicated by the messages
- Ensure that the log is now free from warnings
- Upgrade to pagy 5

FYI: Here is the list of the deprecations that are not supported anymore:

#### Removed support for deprecated variables

- `Pagy::VARS[:anchor]` is now `Pagy::DEFAULT[:fragment]`

#### Removed support for deprecated arguments order

- The argument order in `pagy_url_for(page, pagy)` is now inverted: `pagy_url_for(pagy, page)`

#### Removed support for deprecated positional arguments

The following optional positional arguments are passed with keywords arguments in all the pagy helpers:

- The `id` html attribute string with the `id` keyword
- The `url|absolute` flag with the `absolute` keyword
- The `item_name` string with the `item_name` keyword
- The `extra|link_extra` string with the `link_extra` keyword
- The `text` string with the `text` keyword

### Breaking changes - 2. Simple search and replace

There are a few renaming that have not been deprecated in previous versions because they are extremely easy to fix with simple search and replace (while implementing deprecations would have been detrimental to performance and complex for no reason)

#### Consistency renaming

A few elements have been renamed: you code may or may not contain them. Just search and replace the following strings:

- Rename `Pagy::VARS` to `Pagy::DEFAULT`
- Rename `enable_items_extra` to `items_extra`
- Rename `enable_trim_extra` to `trim_extra`
- Rename `Pagy::Helpers` to `Pagy::UrlHelpers`
- Rename `pagy_get_params` to `pagy_massage_params`

#### Items accessor

The items accessor does not adjust for the actual items in the last page anymore. This should not affect normal usage, so you can ignore this change unless you build something on that assumption.

If your code is relying on the actual number of items **in** the page, then just replace `@pagy.items` with `@pagy.in` wherever you meant that.

FYI: The `@pagy.items` is now always equal to `@pagy.vars[:items]` (i.e. the requested items), while the `@pagy.in` returns the actual items in the page (which could be less than the `items` when the page is the last page)

### Changes

- Removed support for deprecations
- Refactoring of Pagy and Pagy::Countless classes, I18n, and url helpers
- Refactoring of the docker environment, addition of ready to use VSCode setup
- Changed general module structure (use of prepend instead of re-opening modules)
- Added gearbox extra for geared pagination
- Added configuration files for a full working VSCode devcontainer environment
- Added Run Configurations for RubyMine
- Improved the usage of e2e tests
- Updated doc, gemfiles and github workflow
- Other minor fixes and improvements in code and doc

## Version 4.11.0

### Changes

- added countless_minimal feature
- added missing deprecation to countless class
- doc improvements

### Commits

- [5103ee9](http://github.com/ddnexus/pagy/commit/5103ee9): added countless_minimal feature
- [ed6bc0b](http://github.com/ddnexus/pagy/commit/ed6bc0b): added missing deprecation to countless class
- [bedb2d6](http://github.com/ddnexus/pagy/commit/bedb2d6): Fix - link directly to docs [ci-skip] (#328)
- [74aa300](http://github.com/ddnexus/pagy/commit/74aa300): Remove minor extra parenthesis in trim docs [ci-skip] (#326)
- [f8b96eb](http://github.com/ddnexus/pagy/commit/f8b96eb): docs - add links directly to docs page [ci-skip] (#324)

## Version 4.10.2

### Changes

- improve the customization of url when using the trim extra
- better tailwind rules
- doc fixes and improvements

### Commits

- [9e7fd48](http://github.com/ddnexus/pagy/commit/9e7fd48): improve the customization of url when using the trim extra (closes #325)
- [0d48b5f](http://github.com/ddnexus/pagy/commit/0d48b5f): better handling of extra docker-compose run files
- [f5ed8f6](http://github.com/ddnexus/pagy/commit/f5ed8f6): added note about the possible workaround for bundler/inline bug
- [2715660](http://github.com/ddnexus/pagy/commit/2715660): doc fixes
- [7187101](http://github.com/ddnexus/pagy/commit/7187101): Javascript doc improvements
- [24b7e78](http://github.com/ddnexus/pagy/commit/24b7e78): release workflow refactoring
- [20d1d8e](http://github.com/ddnexus/pagy/commit/20d1d8e): chore: add github action - publish & tag versions (#322)
- [922fd7f](http://github.com/ddnexus/pagy/commit/922fd7f): better tailwind rules
- [28983e6](http://github.com/ddnexus/pagy/commit/28983e6): added doc for using Searchkick.pagy_search (closes #319)

## Version 4.10.1

### Changes

- fixes for meilisearch extra

### Commits

- [ec748c2](http://github.com/ddnexus/pagy/commit/ec748c2): Fixes for Meilisearch extra (#318)

## Version 4.10.0

### Changes

- added arabic locale

### Commits

- [9bc548e](http://github.com/ddnexus/pagy/commit/9bc548e): added missing keys for Arabic (#317) (closes #295)
- [1b95674](http://github.com/ddnexus/pagy/commit/1b95674): Add arabic locale, pluralization and tests; alpha ordered tests

## Version 4.9.0

### Changes

- added meilisearch extra
- docs fixes

### Commits

- [572ed78](http://github.com/ddnexus/pagy/commit/572ed78): updated pagy-ci.yml
- [8fe1d19](http://github.com/ddnexus/pagy/commit/8fe1d19): Fix documents for searchkick (#315)
- [744717f](http://github.com/ddnexus/pagy/commit/744717f): Meilisearch extra (#316)
- [fb65260](http://github.com/ddnexus/pagy/commit/fb65260): updated issue templates
- [1c3d283](http://github.com/ddnexus/pagy/commit/1c3d283): Added Pagy::Console links to README

## Version 4.8.1

### Changes

- fix for deprecation and test improvements

### Commits

- [0f1a7f2](http://github.com/ddnexus/pagy/commit/0f1a7f2): improved deprecation_tests (see #311)
- [7e9c9cd](http://github.com/ddnexus/pagy/commit/7e9c9cd): fix(pagy): deprecated_var is a class method (#311)

## Version 4.8.0

### Changes

- Lowered minimal ruby version requirement to 2.5+
- Simpler tests using the `rematch` gem
- Docker environment improvements

### Commits

- [b5b500a](http://github.com/ddnexus/pagy/commit/b5b500a): Merge branch 'backport-to-2.5' into dev
- [001f22f](http://github.com/ddnexus/pagy/commit/001f22f): fix for different handling of module prepend in ruby <3
- [d6d71a5](http://github.com/ddnexus/pagy/commit/d6d71a5): fix for frozen error handled differently on ruby <3
- [8a2cf76](http://github.com/ddnexus/pagy/commit/8a2cf76): replaced syntax not available in ruby 2.5
- [14b3a0c](http://github.com/ddnexus/pagy/commit/14b3a0c): lowered the minimum ruby version requirement to 2.5
- [8c76943](http://github.com/ddnexus/pagy/commit/8c76943): updated Gemfile.lock
- [934f602](http://github.com/ddnexus/pagy/commit/934f602): added comment in doc example about the inverted order of arguments in previous versions
- [acd59f5](http://github.com/ddnexus/pagy/commit/acd59f5): moved command out of default docker-compose to its own file in order to avoid error before first bundle install
- [527a14f](http://github.com/ddnexus/pagy/commit/527a14f): Gemfile update
- [842de05](http://github.com/ddnexus/pagy/commit/842de05): better tests and stricter rubocop
- [d82e95c](http://github.com/ddnexus/pagy/commit/d82e95c): Gemfile updated and used for CI
- [675f587](http://github.com/ddnexus/pagy/commit/675f587): Gemfile: added gemspec and updated rematch
- [b0a6603](http://github.com/ddnexus/pagy/commit/b0a6603): Updated to rematch 1.0 and copyright year
- [8bda6a9](http://github.com/ddnexus/pagy/commit/8bda6a9): added rematch gem and reset rematch stores
- [f62fa88](http://github.com/ddnexus/pagy/commit/f62fa88): added e2e tests to ci
- [04755aa](http://github.com/ddnexus/pagy/commit/04755aa): updated puma
- [4ec03f1](http://github.com/ddnexus/pagy/commit/4ec03f1): added HTML validation for all the helpers and styles
- [87b2f62](http://github.com/ddnexus/pagy/commit/87b2f62): refactoring e2e: replaced snapshot plugin; updated to cypress 7.3.0

## Version 4.7.1

### Changes

- Fixed a couple of HTML validity issues with uikit and materialize combo_nav_js
- Improved rematch testing
- Updated the documentation

### Commits

- [8cb4193](http://github.com/ddnexus/pagy/commit/8cb4193): fixed and simplified uikit combo nav
- [f762aca](http://github.com/ddnexus/pagy/commit/f762aca): used chip class for materialized combo nav
- [064a2b5](http://github.com/ddnexus/pagy/commit/064a2b5): rematched tests
- [2a45321](http://github.com/ddnexus/pagy/commit/2a45321): expanded the combo nav label to the whole text
- [37c65a8](http://github.com/ddnexus/pagy/commit/37c65a8): fixed and simplified materialize combo nav
- [789773b](http://github.com/ddnexus/pagy/commit/789773b): removed faulty PAGY_REMATCH variable function; added rematch_all rake task
- [eb2df6d](http://github.com/ddnexus/pagy/commit/eb2df6d): updated docs [skip ci]

## Version 4.7.0

### Changes

- Refactoring of pagy-json tags into data attributes
- Added the rematch testing system to ease maintenance of tests
- Added Ukrainian locale
- updated Gemfile and doc

### Commits

- [887c783](http://github.com/ddnexus/pagy/commit/887c783): better doc for E2E testing
- [738fd93](http://github.com/ddnexus/pagy/commit/738fd93): updated manifest
- [0110e3a](http://github.com/ddnexus/pagy/commit/0110e3a): Ukrainian locale (#310)
- [9265cd2](http://github.com/ddnexus/pagy/commit/9265cd2): extended must_rematch to other tests
- [d217965](http://github.com/ddnexus/pagy/commit/d217965): refactoring of pagy_json_tag to pagy_json_attr: from script tag to data attribute
- [57e6f91](http://github.com/ddnexus/pagy/commit/57e6f91): added rematch test to ease maintenance of tests
- [94561a0](http://github.com/ddnexus/pagy/commit/94561a0): updated puma

## Version 4.6.0

### Changes

- Added labels to all input tags for improved usability and compliance
- Fixed a few HTML typos and redundant or illegal attributes
- Improved Sinatra app usable for experiment with pagy and providing support for ode issues
- Documentation improvements
- Added E2E testing for all pagy helpers
- GitHub management improvements

### Commits

- [0fe2e49](http://github.com/ddnexus/pagy/commit/0fe2e49): added helpers and navbar tests for all the styles; updated docker readme
- [26b57a8](http://github.com/ddnexus/pagy/commit/26b57a8): Added fix for Cypress bug affecting the snapshots plugin, improved cypress dockerfiles; added cypress studio and basic try
- [7693b3e](http://github.com/ddnexus/pagy/commit/7693b3e): cypress: updated images; better open-cypress.yml with persistent configuration settings; added snapshots plugin
- [94e262f](http://github.com/ddnexus/pagy/commit/94e262f): added label tag to the pagy inputs
- [f5e3482](http://github.com/ddnexus/pagy/commit/f5e3482): removed redundant role="navigation" attribute from nav tags; removed illegal aria-label="pager" from semantic div
- [0467d32](http://github.com/ddnexus/pagy/commit/0467d32): fixes for html typos in semantic, foundation and materialize helpers
- [3f2c9f0](http://github.com/ddnexus/pagy/commit/3f2c9f0): doc small fixes
- [bff8c5f](http://github.com/ddnexus/pagy/commit/bff8c5f): refactoring of sinatra apps; added quick-start doc section
- [b0baaa5](http://github.com/ddnexus/pagy/commit/b0baaa5): simplified standalone_app.ru
- [5442b34](http://github.com/ddnexus/pagy/commit/5442b34): fix broken link [ci skip]
- [17b1faf](http://github.com/ddnexus/pagy/commit/17b1faf): improved issue template [ci skip]
- [f933cd7](http://github.com/ddnexus/pagy/commit/f933cd7): Added issue template and standalone_app to use as a scaffold for reproducing issues [ci skip]
- [c8e41e3](http://github.com/ddnexus/pagy/commit/c8e41e3): added superails screencast; resized thumbnails [skip ci]
- [6116c32](http://github.com/ddnexus/pagy/commit/6116c32): added a few references in the how_to doc [skip ci]

## Version 4.5.1

### Changes

- Better Pagy::Console usability

### Commits

- [4ee8bbf](http://github.com/ddnexus/pagy/commit/4ee8bbf): pagy console extracted in its own module

### Version 4.5.0

### Changes

- Added E2E infrastructure for development and testing
- Refactoring of Javascript and docker environment

### Commits

- [1b7b014](http://github.com/ddnexus/pagy/commit/1b7b014): Add: clarity, further instructions to run pagy tests [skip ci] (#304)
- [7c723ba](http://github.com/ddnexus/pagy/commit/7c723ba): added basic structure to run cypress tests and open the cypress IDE

## Version 4.4.0

### Changes

- Passing positional arguments (besides `@pagy`) to all the helpers is deprecated and it will be supported only until pagy 5.0
- All the helpers accept more optional keyword arguments variables, for example:
  - `pagy*_nav(@pagy, id: 'my-id', link-extra: '...')`
  - `pagy*_nav_js(@pagy, id: 'my-id', link-extra: '...', steps: {...})`
  - `pagy*_combo_nav_js(@pagy, id: 'my-id', link-extra: '...')`
  - `pagy_items_selector_js(pagy, id: 'my-id', item_name: '...', i18n_key: '...', link_extra: '...')`
  - `pagy_info(@pagy, id: 'my-id', item_name: '...', i18n_key: '...')`
  - `pagy_prev_link(@pagy, text: '...', link_extra: '...')`
  - `pagy_next_link(@pagy, text: '...', link_extra: '...')`
  - `pagy_link_proc(@pagy, link_extra: '...')`
  - `pagy_url_for(pagy, page, absolute: nil)` (notice the inverted page/pagy order with the legacy`pagy_url_for(page, pagy, url=nil)`)
- deprecated `:anchor` variable in favor of `:fragment`
- Refactoring of rake tasks, tests, items extra, javascript helpers
- Gems and documentation updates and fixes
- Added standalone extra

### Commits

- [b69a2f2](http://github.com/ddnexus/pagy/commit/b69a2f2): Merge branch 'dev'
- [9611eac](http://github.com/ddnexus/pagy/commit/9611eac): updated CHANGELOG
- [d977767](http://github.com/ddnexus/pagy/commit/d977767): better links in extras.md
- [aa83126](http://github.com/ddnexus/pagy/commit/aa83126): added standalone extra
- [e22c9c3](http://github.com/ddnexus/pagy/commit/e22c9c3): Merge branch 'args-refactoring' into dev
- [d791a04](http://github.com/ddnexus/pagy/commit/d791a04): deprecated :anchor variable in favor of :fragment
- [e91e4da](http://github.com/ddnexus/pagy/commit/e91e4da): [skip ci] update javascript documentation (#305)
- [034afe8](http://github.com/ddnexus/pagy/commit/034afe8): config/pagy.rb: moved pagy variables block at the beginning
- [bd0bb6c](http://github.com/ddnexus/pagy/commit/bd0bb6c): renamed :trim variable to the more explicit :enable_trim_extra; removed redundant tests
- [76096e7](http://github.com/ddnexus/pagy/commit/76096e7): simplified the items extra, and added its features to the array and arel extras
- [86fb20e](http://github.com/ddnexus/pagy/commit/86fb20e): fixed pagy_semantic_nav hellips
- [2382482](http://github.com/ddnexus/pagy/commit/2382482): added link_extra keyword arg to pagy_items_selector_js
- [627a0dc](http://github.com/ddnexus/pagy/commit/627a0dc): also pagy_link_proc uses keyword arguments
- [8ff2665](http://github.com/ddnexus/pagy/commit/8ff2665): completed args conversion also for pagy_url_for and pagy_metadata
- [6a8fbb4](http://github.com/ddnexus/pagy/commit/6a8fbb4): added "pagy-info" and "pagy-items-selector-js" classes to helpers output
- [ad350e1](http://github.com/ddnexus/pagy/commit/ad350e1): pagy_info wrapped into span tag, and added id keyword arg
- [2faca63](http://github.com/ddnexus/pagy/commit/2faca63): small improvement to pagy_url_for
- [2acbac6](http://github.com/ddnexus/pagy/commit/2acbac6): added "pagy-njs" class to all pagy*_nav_js helpers
- [670f5a5](http://github.com/ddnexus/pagy/commit/670f5a5): updated documentation
- [64347f8](http://github.com/ddnexus/pagy/commit/64347f8): changed the argument order from pagy_url_for(page, pagy) > pagy_url_for(pagy, page) for consistency with all the other helpers; deprecation warning and support for pagy < 5
- [393d216](http://github.com/ddnexus/pagy/commit/393d216): updated gems
- [d2891fb](http://github.com/ddnexus/pagy/commit/d2891fb): refactoring and additions of tests
- [1538f24](http://github.com/ddnexus/pagy/commit/1538f24): updated tests with keyword arguments
- [6ce0c1d](http://github.com/ddnexus/pagy/commit/6ce0c1d): helpers: deprecated positional id argument and added keyword arguments
- [9fd7930](http://github.com/ddnexus/pagy/commit/9fd7930): removed id method and added id arg to the pagy*_nav helpers
- [ec74e4f](http://github.com/ddnexus/pagy/commit/ec74e4f): removed the mandatory id arg passed to pagy_json_tag; updated tests; simplified pagy.js using previousSibling
- [3f13014](http://github.com/ddnexus/pagy/commit/3f13014): added resource post and relative link [skip ci]
- [7927f37](http://github.com/ddnexus/pagy/commit/7927f37): added manifest:check to CI for master and dev and to the default rake task
- [01f8f1c](http://github.com/ddnexus/pagy/commit/01f8f1c): refactoring of Rakefile now split in different task files

## Version 4.3.0

### Changes

- Improved efficiency of #series algorithm
- Added new features to the trim extra
- Added rubocop compliance (additional rubocop-packaging plugin)
- Many test tasks improvements
- CI transition from Travis to Github Action

### Commits

- [80cef45](http://github.com/ddnexus/pagy/commit/80cef45): updated Gemfile
- [3cc464b](http://github.com/ddnexus/pagy/commit/3cc464b): added coverage_summary at the end of the default task; added possibility of creating a coverage report
- [0424b71](http://github.com/ddnexus/pagy/commit/0424b71): docs and comment additions/fixes [skip ci]
- [b6115e7](http://github.com/ddnexus/pagy/commit/b6115e7): Added explicit pagy.manifest to comply with rubocop-packaging (see also #297)
- [ef1980e](http://github.com/ddnexus/pagy/commit/ef1980e): refactoring of CI from Travis to Github Actions
- [9fb1195](http://github.com/ddnexus/pagy/commit/9fb1195): more verbose condition
- [fe565eb](http://github.com/ddnexus/pagy/commit/fe565eb): removed RUN_RUBOCOP
- [60be542](http://github.com/ddnexus/pagy/commit/60be542): fix missing codecov formatter/circular reference problem
- [8c4ccfc](http://github.com/ddnexus/pagy/commit/8c4ccfc): rubocop: added rubocop-packaging plugin; expanded inclusion of files
- [487eb70](http://github.com/ddnexus/pagy/commit/487eb70): small code normalization
- [3ea2d27](http://github.com/ddnexus/pagy/commit/3ea2d27): codecov gets already required in travis on ruby 3.0 (but not locally)
- [e17d294](http://github.com/ddnexus/pagy/commit/e17d294): improved series algorithm efficiency (now up to ~5x faster and ~2.3x lighter than the previous one)
- [1051e6d](http://github.com/ddnexus/pagy/commit/1051e6d): trim feature: added :trim variable to opt-out to trim even with the trim extra loaded, or invert the logic to out-in by setting Pagy::VARS[:trim] to false
- [ece4daa](http://github.com/ddnexus/pagy/commit/ece4daa): minor code restyling
- [0e3a09d](http://github.com/ddnexus/pagy/commit/0e3a09d): added :ide_development bundle group; small README changes
- [5e6f749](http://github.com/ddnexus/pagy/commit/5e6f749): simpler test tasks
- [e5ee4e7](http://github.com/ddnexus/pagy/commit/e5ee4e7): CI: Remove Bundler 1.x workaround (#296)The "github" source now has that form, already.

## Version 4.2.0

### Changes

- Fix for `Pagy::Frontend::I18n` conflicting with rthe `I18n` gem namespace after inclusion and safer renaming of other modules
- Fix the simplecov setup reporting less coverage than what's actually covered
- Updated Tailwind styles
- Included the test dir in the coverage check, refactoring and additions of tests
- Big code restyling following ruby 3.0 syntax and cops; tried to make the code simpler, more readable and verbose with almost negligible performance loss.

### Commits

- [a62ae94](http://github.com/ddnexus/pagy/commit/a62ae94): Updated README
- [9efb908](http://github.com/ddnexus/pagy/commit/9efb908): removed ENABLE_OJ from tests and travis config
- [dede255](http://github.com/ddnexus/pagy/commit/dede255): removed RUN_SIMPLECOV option
- [fc614bd](http://github.com/ddnexus/pagy/commit/fc614bd): fix/refactoring for simplecov setup reporting less coverage than what's actually covered
- [5e6ecf1](http://github.com/ddnexus/pagy/commit/5e6ecf1): refactoring of Rakefile
- [aea25a1](http://github.com/ddnexus/pagy/commit/aea25a1): code-restyling: test
- [cb67353](http://github.com/ddnexus/pagy/commit/cb67353): code-restyling: extras
- [b2dc35a](http://github.com/ddnexus/pagy/commit/b2dc35a): code-restyling: locales, config
- [b638764](http://github.com/ddnexus/pagy/commit/b638764): code-restyling: root files and Pagy Core
- [aac54aa](http://github.com/ddnexus/pagy/commit/aac54aa): Renaming prepended modules with more specific and safe naming convention (see Issue #290 PR #293)
- [3eef450](http://github.com/ddnexus/pagy/commit/3eef450): Simpler test for I18n namespace conflict
- [b2aaa01](http://github.com/ddnexus/pagy/commit/b2aaa01): README: fix typo (#289) [ci-skip]
- [3a9e70f](http://github.com/ddnexus/pagy/commit/3a9e70f): Fix extra i18n namespacing (#293)* Add a test that looks at i18n working in Modules included (fixes #290)
- [8cd25d2](http://github.com/ddnexus/pagy/commit/8cd25d2): renamed docker > pagy-on-docker
- [a8060b1](http://github.com/ddnexus/pagy/commit/a8060b1): fixed doc typos
- [f0e0d41](http://github.com/ddnexus/pagy/commit/f0e0d41): removed require for minitest/reporters
- [c178c6f](http://github.com/ddnexus/pagy/commit/c178c6f): docker README fixes [ci-skip]
- [ac988fd](http://github.com/ddnexus/pagy/commit/ac988fd): docs fixes
- [4d20d34](http://github.com/ddnexus/pagy/commit/4d20d34): Update Tailwind styles (#285)
- [9a14400](http://github.com/ddnexus/pagy/commit/9a14400): Small README addition [ci-skip]
- [9b40cdd](http://github.com/ddnexus/pagy/commit/9b40cdd): Update frontend.md (#284) [ci-skip]
- [2bbf204](http://github.com/ddnexus/pagy/commit/2bbf204): added Mike Rogers' screencast [ci-skip]
- [b24b86d](http://github.com/ddnexus/pagy/commit/b24b86d): Added note for brakeman false positive warnings (closes #243) [ci-skip]
- [df3c8d6](http://github.com/ddnexus/pagy/commit/df3c8d6): small syntax normalization
- [618d226](http://github.com/ddnexus/pagy/commit/618d226): docker README fix [ci-skip]

## Version 4.1.0

### Changes

- added Bosnian, Croatian and Serbian locales

### Commits

- [8da0e06](http://github.com/ddnexus/pagy/commit/8da0e06): Add Serbian locale (#283)
- [dcfc659](http://github.com/ddnexus/pagy/commit/dcfc659): Add locales for Bosnian and Croatian language (#281)

## Version 4.0.0

### Breaking Changes

- renamed `Pagy::Search` as `Pagy::Searchkick` or `Pagy::ElasticsearchRails`

### Changes

- Dropped support for all jruby versions and ruby version <3.0 (use pagy 3.x instead)
- Dropped deprecation for old/renamed locales
- Fixed error in searchkick extra with ruby 3
- Various refactorings taking advantage of the dropped support for old ruby versions

### Commits

- [4d48d33](http://github.com/ddnexus/pagy/commit/4d48d33): refactoring of pagy_json_tag
- [745e68f](http://github.com/ddnexus/pagy/commit/745e68f): minor fixes for docker
- [296f060](http://github.com/ddnexus/pagy/commit/296f060): added pagy_search name customization to elasticsearch extras
- [98a5254](http://github.com/ddnexus/pagy/commit/98a5254): refactoring of the elasticsearch_rails extra matching the actual params of the search method
- [6966fe3](http://github.com/ddnexus/pagy/commit/6966fe3): refactoring of elasticsearch extras
- [aecb565](http://github.com/ddnexus/pagy/commit/aecb565): normalization of i18n naming
- [b3f78b8](http://github.com/ddnexus/pagy/commit/b3f78b8): refactoring of items extra using module prepend instead alias method chaining and module_eval; refactoring of tests (countless was masking failures of elasticsearch extras)
- [8ec7893](http://github.com/ddnexus/pagy/commit/8ec7893): refactoring of trim extra using module prepend instead alias method chaining
- [05d9e92](http://github.com/ddnexus/pagy/commit/05d9e92): used ruby 3.0 syntax
- [f1d89a5](http://github.com/ddnexus/pagy/commit/f1d89a5): refactoring of I18n extra using module prepend instead alias method chaining
- [df8607e](http://github.com/ddnexus/pagy/commit/df8607e): refactoring of overflow extra using module prepend instead alias method chaining
- [c361293](http://github.com/ddnexus/pagy/commit/c361293): Gemfile: uncommented performance group
- [66e29d1](http://github.com/ddnexus/pagy/commit/66e29d1): fixes for the docker README
- [2a343ce](http://github.com/ddnexus/pagy/commit/2a343ce): added README note about versions
- [dadd2f1](http://github.com/ddnexus/pagy/commit/dadd2f1): ruby 3.0 syntax
- [ce1d7ec](http://github.com/ddnexus/pagy/commit/ce1d7ec): removed legacy I18n compatibility
- [6751412](http://github.com/ddnexus/pagy/commit/6751412): added a few env variables in order to control the verbosity of tests; added test for negative page number
- [3eac56b](http://github.com/ddnexus/pagy/commit/3eac56b): removed unused Hash additional methods
- [24ab5c6](http://github.com/ddnexus/pagy/commit/24ab5c6): simpler travis setup
- [ba100dc](http://github.com/ddnexus/pagy/commit/ba100dc): updated documentation
- [5d53043](http://github.com/ddnexus/pagy/commit/5d53043): emptied CHANGELOG and dropped LEGACY_CHANGELOG
- [33c467a](http://github.com/ddnexus/pagy/commit/33c467a): removed MARK constant
- [49040fb](http://github.com/ddnexus/pagy/commit/49040fb): removed EMPTY constant used for legacy compatibility with frozen_string_literal
- [b826f61](http://github.com/ddnexus/pagy/commit/b826f61): updated rubocop and fixed offending lines
- [f075337](http://github.com/ddnexus/pagy/commit/f075337): removed deprecated locales
- [a70881a](http://github.com/ddnexus/pagy/commit/a70881a): updated version to 4.0.0
- [4676788](http://github.com/ddnexus/pagy/commit/4676788): updated docker environment for pagy 4
- [4a85efe](http://github.com/ddnexus/pagy/commit/4a85efe): updated gemfile and gemspec for pagy 4
- [fcaab88](http://github.com/ddnexus/pagy/commit/fcaab88): updated gemfile and gemspec
- [467b985](http://github.com/ddnexus/pagy/commit/467b985): added docker development environment

## Version 3.11.0

### Changes

- added Swahili localization

### Commits

- [fbc322f](http://github.com/ddnexus/pagy/commit/fbc322f): Add Swahili (sw) to pagy (#276)
- [ebbac6b](http://github.com/ddnexus/pagy/commit/ebbac6b): Fix: broken links (#272) [ci-skip]
- [2178436](http://github.com/ddnexus/pagy/commit/2178436): restored file removed by mistake

## Version 3.10.0

### Changes

- added Czeck localization

### Commits

- [316183f](http://github.com/ddnexus/pagy/commit/316183f): minor adjustments to p11n.rb; removed local file
- [2e7fa1b](http://github.com/ddnexus/pagy/commit/2e7fa1b): Update with 'cs' (#269)added lambda for 'west_slavic' and 'hash for 'cs' language
- [70760c6](http://github.com/ddnexus/pagy/commit/70760c6): Czech localization (#268)

## Version 3.9.0

### Changes

- added link tags helpers to support extra

### Commits

- [a66491b](http://github.com/ddnexus/pagy/commit/a66491b): added link tags helpers to support extra
- [2ef08a9](http://github.com/ddnexus/pagy/commit/2ef08a9): @pagy_locale explicitly initialized to avoid warning
- [261c6a1](http://github.com/ddnexus/pagy/commit/261c6a1): reorganized gemfiles for travis, removed jruby 9.2 tests and added CAVEATS and removed redundant ||=nil
- [619d7d1](http://github.com/ddnexus/pagy/commit/619d7d1): updated gems
- [fc861d8](http://github.com/ddnexus/pagy/commit/fc861d8): added .gitattributes to fix github linguist [ci-skip]
- [287b94f](http://github.com/ddnexus/pagy/commit/287b94f): added Raul Palacio screencast link to README
- [52c65a3](http://github.com/ddnexus/pagy/commit/52c65a3): added "Contributions" section in the README
- [f09a80a](http://github.com/ddnexus/pagy/commit/f09a80a): Add tutorial link to readme (#259)
- [86bf3dc](http://github.com/ddnexus/pagy/commit/86bf3dc): Fix: typo [ci-skip] (#257)
- [bd3bcc7](http://github.com/ddnexus/pagy/commit/bd3bcc7): Update copyright notice to 2020 (#256) [ci-skip]
- [01e4a14](http://github.com/ddnexus/pagy/commit/01e4a14): [ci-skip] Add note re: html safe helpers (#254)Fixes discussion noted in: #6
- [1d812be](http://github.com/ddnexus/pagy/commit/1d812be): doc improvements [ci-skip]

## Version 3.8.3

### Changes

- Portuguese translation
- Fixes and documentation improvements

### Commits

- [f64a1d6](http://github.com/ddnexus/pagy/commit/f64a1d6): added pagy reference to jetbrains link
- [8a4596f](http://github.com/ddnexus/pagy/commit/8a4596f): Add translation for Portuguese (#250) [ci-skip]
- [515de9b](http://github.com/ddnexus/pagy/commit/515de9b): Adds parentheses (#249) [ci-skip]
- [734f30c](http://github.com/ddnexus/pagy/commit/734f30c): added basic sinatra app
- [c7aa44d](http://github.com/ddnexus/pagy/commit/c7aa44d): updated gems
- [62bd4ac](http://github.com/ddnexus/pagy/commit/62bd4ac): added tailwind extra styles
- [c2e8eef](http://github.com/ddnexus/pagy/commit/c2e8eef): added "Customizing CSS styles" how to section
- [614a3e1](http://github.com/ddnexus/pagy/commit/614a3e1): fix for extra "-js" in "pagy-combo-nav-js"
- [8673ca4](http://github.com/ddnexus/pagy/commit/8673ca4): a couple of how_to additions

## Version 3.8.2

### Changes

- Fixes, improvements and gems updates

### Commits

- [a1a7962](http://github.com/ddnexus/pagy/commit/a1a7962): gems update
- [0a70110](http://github.com/ddnexus/pagy/commit/0a70110): item_name can be overridden by passing an already pluralized string to pagy_info
- [28913d6](http://github.com/ddnexus/pagy/commit/28913d6): Use proper attributes for "previous" links (#244)

## Version 3.8.1

### Changes

- Various fixes ad gems update

### Commits

- [1aa1fa7](http://github.com/ddnexus/pagy/commit/1aa1fa7): gems update
- [289d38a](http://github.com/ddnexus/pagy/commit/289d38a): added conditional definition of pagy_t_with_i18n to avoid ruby 2.7 "last argument as keyword parameters" deprecation warning (closes #241)
- [d571719](http://github.com/ddnexus/pagy/commit/d571719): added raw_response method check for pagy_elasticsearch_rails (#234)
- [7a09bb9](http://github.com/ddnexus/pagy/commit/7a09bb9): fix typo in documentation
- [d7a9f7a](http://github.com/ddnexus/pagy/commit/d7a9f7a): Fixes boundary character escaping in regex in js trim function (#239)
- [3561885](http://github.com/ddnexus/pagy/commit/3561885): gems update

## Version 3.8.0

### Changes

- Khmer translation
- Added support for elasticsearch < 6
- Documentation fixes

### Commits

- [bba1bca](http://github.com/ddnexus/pagy/commit/bba1bca): used ternary conditional
- [a9cee7d](http://github.com/ddnexus/pagy/commit/a9cee7d): Support ES5 on elasticsearch rails (#234)
- [d58a39d](http://github.com/ddnexus/pagy/commit/d58a39d): Khmer translation for pagy (#235)
- [7ced96c](http://github.com/ddnexus/pagy/commit/7ced96c): fix for missing suffix fr method reference in doc
- [73600be](http://github.com/ddnexus/pagy/commit/73600be): improved consistency in searchkick and elasticsearch_rails documentation examples (#231)

## Version 3.7.5

### Changes

- Danish translation
- Re-enabled legacy jruby travis config
- Added ruby 2.7 travis testing and rubocop config

### Commits

- [721d01f](http://github.com/ddnexus/pagy/commit/721d01f): more documentation fixes and improvements
- [246fca7](http://github.com/ddnexus/pagy/commit/246fca7): Danish translation for Pagy (#232)
- [e57215f](http://github.com/ddnexus/pagy/commit/e57215f): added ruby 2.7 travis testing and rubocop target version
- [280164a](http://github.com/ddnexus/pagy/commit/280164a): re-enabled travis testing for old jruby (travis fixed the jruby images issue)

## Version 3.7.4

### Changes

- Locales normalization and deprecations
- Bundle update

### Commits

- [c424466](http://github.com/ddnexus/pagy/commit/c424466): Merge branch 'locales-normalization' into dev
- [032615c](http://github.com/ddnexus/pagy/commit/032615c): added Pagy::I18n deprecation tests
- [ebd6151](http://github.com/ddnexus/pagy/commit/ebd6151): added deprecation remapping
- [e1bd70c](http://github.com/ddnexus/pagy/commit/e1bd70c): renamed pt-br -> pt-BR
- [a77dfcf](http://github.com/ddnexus/pagy/commit/a77dfcf): fix for sv and sv-SE pluralization
- [6a31db6](http://github.com/ddnexus/pagy/commit/6a31db6): Swedish locale: add sv-SE, rename se -> sv (#226)
- [00bd312](http://github.com/ddnexus/pagy/commit/00bd312): bundle update (closes #208, closes #223, closes #224)
- [133da16](http://github.com/ddnexus/pagy/commit/133da16): Add tutorial link (#222) [ci skip]

## Version 3.7.3

### Commits

- [a2b915e](http://github.com/ddnexus/pagy/commit/a2b915e): reorganization of Javascript documentation
- [fead55c](http://github.com/ddnexus/pagy/commit/fead55c): Remove duplicated pagination class for Bootstrap (#212)

## Version 3.7.2

### Changes

- fix for numeric headers in the headers extra

### Commits

- [6a93b97](http://github.com/ddnexus/pagy/commit/6a93b97): headers must be strings (closes #211)

## Version 3.7.1

### Changes

- fix for arel count

### Commits

- [cbe4a97](http://github.com/ddnexus/pagy/commit/cbe4a97): Type cast pagy_arel_count value to integer (#207)
- [973f4fe](http://github.com/ddnexus/pagy/commit/973f4fe): updated link [ci skip]

## Version 3.7.0

### Changes

- updated French and Spanish translations
- added Italian translation
- internal renaming `Pagy::Frontend::MARK` > `Pagy::PAGE_PLACEHOLDER`

### Commits

- [434912b](http://github.com/ddnexus/pagy/commit/434912b): updated rubyzip gem
- [b627e55](http://github.com/ddnexus/pagy/commit/b627e55): add italian translation (#202)
- [3341dcc](http://github.com/ddnexus/pagy/commit/3341dcc): created ITEMS_PLACEHOLDER constant
- [7775155](http://github.com/ddnexus/pagy/commit/7775155): replaced Pagy::Frontend::MARK with Pagy::PAGE_PLACEHOLDER (MARK is still defined for backward compatibility)
- [439676e](http://github.com/ddnexus/pagy/commit/439676e): Fixed previous translation for Spanish (#199)
- [ee1b1f0](http://github.com/ddnexus/pagy/commit/ee1b1f0): Update fr.yml (#195)
- [8b6f81f](http://github.com/ddnexus/pagy/commit/8b6f81f): added pagy-cursor link in README
- [c290dca](http://github.com/ddnexus/pagy/commit/c290dca): update incorrect tutorial link (#198)
- [77c045d](http://github.com/ddnexus/pagy/commit/77c045d): add: tutorial link in ReadMe - complex search forms (#194)
- [846eece](http://github.com/ddnexus/pagy/commit/846eece): fix in README.md
- [224748a](http://github.com/ddnexus/pagy/commit/224748a): fix for resurrected-by-mistake line in README

## Version 3.6.0

### Changes

- added arel extra
- updated Gemfile for development environment
- docs fixes and improvements

### Commits

- [af0f189](http://github.com/ddnexus/pagy/commit/af0f189): updated minitest and minitest-reporter gems and removed deprecation
- [6a62de5](http://github.com/ddnexus/pagy/commit/6a62de5): updated Gemfile
- [4856782](http://github.com/ddnexus/pagy/commit/4856782): Arel Extra (#189)
- [2a2d9b0](http://github.com/ddnexus/pagy/commit/2a2d9b0): Revert "Added digital-climate-strike banner"This reverts commit 07f7d9256ef9b1cef1c1eaf6da56ebb03daa19d5.
- [b5c2809](http://github.com/ddnexus/pagy/commit/b5c2809): docs fixes
- [f8e4f42](http://github.com/ddnexus/pagy/commit/f8e4f42): replaced markdown file link for documentation link in extras
- [6a5c271](http://github.com/ddnexus/pagy/commit/6a5c271): updated github-pages gem
- [60d243c](http://github.com/ddnexus/pagy/commit/60d243c): small doc improvement [ci skip]
- [2feb451](http://github.com/ddnexus/pagy/commit/2feb451): docs changes
- [07f7d92](http://github.com/ddnexus/pagy/commit/07f7d92): Added digital-climate-strike banner
- [281da85](http://github.com/ddnexus/pagy/commit/281da85): update grammar (#187)
- [739f032](http://github.com/ddnexus/pagy/commit/739f032): Update how-to: Correct to require header for API (#188)

## Version 3.5.1

### Changes

- added support for elasticsearch 7

### Commits

- [ca736cc](http://github.com/ddnexus/pagy/commit/ca736cc): Adding elasticsearch7 support (#185) Fixes #184
- [13b7314](http://github.com/ddnexus/pagy/commit/13b7314): correct typos in docs and initializer (#186) [ci skip]
- [9734ed6](http://github.com/ddnexus/pagy/commit/9734ed6): Docs style changes [ci skip]
- [fb8bcf4](http://github.com/ddnexus/pagy/commit/fb8bcf4): doc fix for missing :partial key in rendering example (closes #180)
- [7160a18](http://github.com/ddnexus/pagy/commit/7160a18): Minor docs changes [ci skip]

## Version 3.5.0

### Changes

- Added Korean locale
- Added Catalan locale
- Added metadata extra
- Docs fixes and improvements

### Commits

- [2813973](http://github.com/ddnexus/pagy/commit/2813973): Docs:
  - added detailed Quick Start steps (closes #176, closes #177)
  - added specific sections for API clients and javascript frameworks
- [43349a8](http://github.com/ddnexus/pagy/commit/43349a8): added metadata extra
- [261e6e6](http://github.com/ddnexus/pagy/commit/261e6e6): Add Catalan localization (#178)
- [30ed505](http://github.com/ddnexus/pagy/commit/30ed505): temporarily removed jruby 1.7 and 9.0 rvm from travis - waiting travis to fix their rvms or suggest some work around [see issue](https://travis-ci.community/t/jruby-1-7-and-9-0-fail/4703)
- [2863c55](http://github.com/ddnexus/pagy/commit/2863c55): added minitest-reporters gem
- [0b42e5c](http://github.com/ddnexus/pagy/commit/0b42e5c): Add translation ko.yml for korean (#172)
- [da3fc37](http://github.com/ddnexus/pagy/commit/da3fc37): minor doc fixes [ci skip]

## Version 3.4.1

### Changes

- Improvements for searchkick extra
- Added javascript Pagy.version

### Commits

- [0ac5c27](http://github.com/ddnexus/pagy/commit/0ac5c27): refactoring of pagy_search and its usage in order to allow optional term argument for searchkick (#169)
- [389755b](http://github.com/ddnexus/pagy/commit/389755b): small docs editing [ci skip]

## Version 3.4.0

### Changes

- Added UIkit nav, nav_js and combo_js helpers and templates.

### Commits

- [1eb25ec](http://github.com/ddnexus/pagy/commit/1eb25ec): Implement UIkit pagination (#164)

## Version 3.3.2

### Changes

- Fix for #163
- Javascript improvements

### Commits

- [aff8cbb](http://github.com/ddnexus/pagy/commit/aff8cbb): better handling of resize listeners; added render function to the pagy element
- [c699fe5](http://github.com/ddnexus/pagy/commit/c699fe5): fix for javascript/turbolink nav.render firing when element not found (#163)

## Version 3.3.1

### Changes

Namespacing of all exceptions, still backward compatible with legacy rescues

### Commits

- [530cb24](http://github.com/ddnexus/pagy/commit/530cb24): all the exceptions are namespaced and can return more information for easier rescue of special cases

## Version 3.3.0

### Changes

- Added Bulgarian locale

### Commits

- [2c56428](http://github.com/ddnexus/pagy/commit/2c56428): added pluralization comment to bg.yml dictionary
- [7111cec](http://github.com/ddnexus/pagy/commit/7111cec): Bulgarian language yml file. (#162)
- [a46f6b5](http://github.com/ddnexus/pagy/commit/a46f6b5): improved suggestion for headers usage

## Version 3.2.1

### Commits

- [b403a35](http://github.com/ddnexus/pagy/commit/b403a35): improved trim regex: simpler, safer and more tested
- [bd3be09](http://github.com/ddnexus/pagy/commit/bd3be09): normalized aliasing with alias_method
- [3c60d9b](http://github.com/ddnexus/pagy/commit/3c60d9b): minor doc fixes
- [9aa1bea](http://github.com/ddnexus/pagy/commit/9aa1bea): fix for missing "partial" in examples for template usage (#160)
- [405b4d2](http://github.com/ddnexus/pagy/commit/405b4d2): reorganization and renaming of test helpers
- [459edaa](http://github.com/ddnexus/pagy/commit/459edaa): improved notes about preventing crawlers to follow look-alike links
- [01c73d3](http://github.com/ddnexus/pagy/commit/01c73d3): added search box to docs

## Version 3.2.0

### Commits

- [2341a83](http://github.com/ddnexus/pagy/commit/2341a83): docs fixes and additions
- [96ad00f](http://github.com/ddnexus/pagy/commit/96ad00f): extended trim extra support to all the *_js helpers:
  - refactored trim extra
  - simplified MARK strings
  - use of RegExp patterns in pagy.js
  - added and improved tests

## Version 3.1.0

### Commits

- [1732dee](http://github.com/ddnexus/pagy/commit/1732dee): refactoring of marker and hidden links in *_js helpers:
  - MARKER renamed to MARK is simpler, static and hardcoded in pagy.js as well
  - removed hidden links to bogus urls that were triggering crawlers to follow (#158)
  - pagy_items_selector now works also with trim and in combination with other *nav_js helpers
  - updated tests
- [aa140e1](http://github.com/ddnexus/pagy/commit/aa140e1): doc improvement
- [d0e4ba6](http://github.com/ddnexus/pagy/commit/d0e4ba6): a few fixes and doc improvements
- [c1ddbd9](http://github.com/ddnexus/pagy/commit/c1ddbd9): Fix typo in docs example (#156)
- [e0b2a2b](http://github.com/ddnexus/pagy/commit/e0b2a2b): removed duplication in LEGACY_CHANGELOG
- [ecb6822](http://github.com/ddnexus/pagy/commit/ecb6822): fix typo in README

## Version 3.0.0

### Breaking Changes

#### Refactoring of i18n

- The `zh-cn` and `zh-hk` were named incorrectly. They have been properly renamed as `zh-CN` and `zh-HK`. If you used them, you should update the `Pagy::I18n.load` statement.
- Removed the plural keys inconsistent with the locale: now the dictionary files are 100% compatible with the I18n gem. If you use custom dictionaries, you should update their entries.
- The `:item_path` variable has been renamed as `:i18n_key`: you should search and replace it.

#### Renamed nav helper methods and files

The javascript-powered helpers (`pagy*_responsive_nav`, `pagy*_compact_nav` and `items_selector`) have been renamed in order to be simpler and more descriptive of their arguments, features and requirements. They have been improved internally, but you need only to search and replace because their usage has not been changed.

#### Bootstrap Extra

| v2.0+                                          | v3.0+                            |
|:-----------------------------------------------|:---------------------------------|
| `pagy_bootstrap_responsive_nav` `:breakpoints` | `pagy_bootstrap_nav_js` `:steps` |
| `pagy_bootstrap_compact_nav`                   | `pagy_bootstrap_combo_nav_js`    |

#### Bulma Extra

| v2.0+                                      | v3.0+                        |
|:-------------------------------------------|:-----------------------------|
| `pagy_bulma_responsive_nav` `:breakpoints` | `pagy_bulma_nav_js` `:steps` |
| `pagy_bulma_compact_nav`                   | `pagy_bulma_combo_nav_js`    |

#### Foundation Extra

| v2.0+                                           | v3.0+                             |
|:------------------------------------------------|:----------------------------------|
| `pagy_foundation_responsive_nav` `:breakpoints` | `pagy_foundation_nav_js` `:steps` |
| `pagy_foundation_compact_nav`                   | `pagy_foundation_combo_nav_js`    |

#### Materialize Extra

| v2.0+                                            | v3.0+                              |
|:-------------------------------------------------|:-----------------------------------|
| `pagy_materialize_responsive_nav` `:breakpoints` | `pagy_materialize_nav_js` `:steps` |
| `pagy_materialize_compact_nav`                   | `pagy_materialize_combo_nav_js`    |

#### Plain > Navs Extra

| v2.0+                                      | v3.0+                        |
|:-------------------------------------------|:-----------------------------|
| `pagy_plain_nav` (`pagy_nav` alias)        | - removed -                  |
| `pagy_plain_responsive_nav` `:breakpoints` | `pagy_nav_js` `:steps`       |
| `pagy_plain_compact_nav`                   | `pagy_combo_nav_js`          |
| `require "pagy/extras/plain"`              | `require "pagy/extras/navs"` |

#### Semantic Extra

| v2.0+                                         | v3.0+                           |
|:----------------------------------------------|:--------------------------------|
| `pagy_semantic_responsive_nav` `:breakpoints` | `pagy_semantic_nav_js` `:steps` |
| `pagy_semantic_compact_nav`                   | `pagy_semantic_combo_nav_js`    |

#### Renamed Pagy::VARS

`Pagy::Vars[:breakpoints]` has been renamed as `Pagy::VARS[:steps]`

#### Renamed items_selector

`items_selector` has been renamed as `items_selector_js`. It is also possible to use the `i18n_key` variable to customize the item name.

#### Renamed classes and params in helpers

**Notice**: You can skip the following sections if you did not override any nav helper.

#### CSS nav classes

The `nav` CSS classes follow the same renaming rules of the helper methods:

| v2.0+                             | v3.0+                           |
|:----------------------------------|:--------------------------------|
| `pagy-bootstrap-responsive-nav`   | `pagy-bootstrap-nav-js`         |
| `pagy-bootstrap-compact-nav`      | `pagy-bootstrap-combo-nav-js`   |
| `pagy-bulma-responsive-nav`       | `pagy-bulma-nav-js`             |
| `pagy-bulma-compact-nav`          | `pagy-bulma-combo-nav-js`       |
| `pagy-foundation-responsive-nav`  | `pagy-foundation-nav-js`        |
| `pagy-foundation-compact-nav`     | `pagy-foundation-combo-nav-js`  |
| `pagy-materialize-responsive-nav` | `pagy-materialize-nav-js`       |
| `pagy-materialize-compact-nav`    | `pagy-materialize-combo-nav-js` |
| `pagy-plain-responsive-nav`       | `pagy-nav-js`                   |
| `pagy-plain-compact-nav`          | `pagy-combo-nav-js`             |
| `pagy-semantic-responsive-nav`    | `pagy-semantic-nav-js`          |
| `pagy-semantic-compact-nav`       | `pagy-semantic-combo-nav-js`    |

#### CSS JSON tag classes

Renamed first param passed to the `pagy_json_tag`:

| v2.0+         | v3.0+             |
|:--------------|:------------------|
| `:responsive` | `:nav`            |
| `:compact`    | `:combo_nav`      |
| `:items`      | `:items_selector` |

#### Javascript functions

| v2.0+             | v3.0+                 |
|:------------------|:----------------------|
| `Pagy.responsive` | `Pagy.nav`            |
| `Pagy.compact`    | `Pagy.combo_nav`      |
| `Pagy.items`      | `Pagy.items_selector` |

#### Dropped marginal methods

Dropped `pagy_serialized`, `pagy_apply_init_tag` and `PagyInit` javascript namespace. They were too basic to be useful as support for javascript powered custom component.

### Commits

- [df3ebf2](http://github.com/ddnexus/pagy/commit/df3ebf2): updated performance assets for v3
- [260e7d4](http://github.com/ddnexus/pagy/commit/260e7d4): refactoring of i18n:
  - I18n gem compliant (removed plural keys inconsistent with the locale)
  - added tests for all the pluralization procs
  - simplified and normalized Pagy dictionary file
  - renamed :items_Path to :collection_key
  - added :collection_key lookup for the items_selector_js helper
- [8ebb1ab](http://github.com/ddnexus/pagy/commit/8ebb1ab): refactoring of test coverage:
  - replaced SingleCov with SimpleCov for CodeCov integration
  - simplified Travis setup
  - separate controls of RuboCop, SimpleCov, Oj and CodeCov with dedicated ENV variables
  - completed coverage at 100%
- [ae3e4bc](http://github.com/ddnexus/pagy/commit/ae3e4bc): removed overridden method and undefined instance variable warnings
- [aa1aad9](http://github.com/ddnexus/pagy/commit/aa1aad9): renamed multi_series > sequels and relative js arguments and variables; renamed :sizes > :steps; updated nav test cases
- [901f779](http://github.com/ddnexus/pagy/commit/901f779): compact > combo and other changes
- [f7425a5](http://github.com/ddnexus/pagy/commit/f7425a5): renamed assets according to helper names; reordered and improved nav docs
- [ad100eb](http://github.com/ddnexus/pagy/commit/ad100eb): renamed plain extra to navs; removed the "plain_" qualifier for the helpers
- [54f4a7e](http://github.com/ddnexus/pagy/commit/54f4a7e): updated docs and comments
- [25470dd](http://github.com/ddnexus/pagy/commit/25470dd): renamed items_selector > items_selector_js
- [d4be9dd](http://github.com/ddnexus/pagy/commit/d4be9dd): replaced responsive with nav_js; reordered methods and test normalization
- [ec7d754](http://github.com/ddnexus/pagy/commit/ec7d754): removed warning for locales zh-cn and zh-hk, and properly renamed as zh-CN and zh-HK
- [2548557](http://github.com/ddnexus/pagy/commit/2548557): simplified support extra (dropped pagy_serialized and pagy_apply_init_tag)
- [f82b2e7](http://github.com/ddnexus/pagy/commit/f82b2e7): fix typo
- [704a4df](http://github.com/ddnexus/pagy/commit/704a4df): add french translation (#154)
- [2f67dfa](http://github.com/ddnexus/pagy/commit/2f67dfa): UPDATE pagy locales id (#151)
- [15732da](http://github.com/ddnexus/pagy/commit/15732da): fix for broken migration link (#150)

## Version 2.1.5

### Changes

- Fix for `pagy_url_for` returning duplicated params
- Added "zh-TW" locale
- Deprecated incorrect zh-cn and zh-hk locales in favor of zh-CN and zh-HK locales

### Commits

- [62ee172](http://github.com/ddnexus/pagy/commit/62ee172): fixes for pagy_url_for full url gets duplicated page param (#149)
  - used concatenated request.
    base_url instead of request.url
  - added better tests
  - fixed overriding of pagy_url_for in items extra
- [0bca4af](http://github.com/ddnexus/pagy/commit/0bca4af): fix for rubocop offense
- [6b7fe77](http://github.com/ddnexus/pagy/commit/6b7fe77): deprecated zh-cn and zh-hk locales, normalized as zh-CN and zh-HK
- [c28d21a](http://github.com/ddnexus/pagy/commit/c28d21a): Added locale zh-TW (#147)
- [95cdf61](http://github.com/ddnexus/pagy/commit/95cdf61): docs improvements
- [310c804](http://github.com/ddnexus/pagy/commit/310c804): Update lib/locales/README.md (#148)

## Version 2.1.4

### Changes

- Fix for responsive javascript not working with IE

### Commits

- [3cce19a](http://github.com/ddnexus/pagy/commit/3cce19a): javascript responsive refactoring:
  - replaced problematic loop functions with plain for loops
  - better naming in responsive function
  - shortened rendering time
  - simpler doc
- [3eacc8d](http://github.com/ddnexus/pagy/commit/3eacc8d): better doc examples
- [5c92187](http://github.com/ddnexus/pagy/commit/5c92187): added missing event listeners to auto-incremental javascript example
- [119ba78](http://github.com/ddnexus/pagy/commit/119ba78): fix for support.md auto-incremental javascript example
- [1f376d4](http://github.com/ddnexus/pagy/commit/1f376d4): Update support.md (#146) Fix incremental/infinite scroll examples

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
- [2a90e6a](http://github.com/ddnexus/pagy/commit/2a90e6a): stop following the GitFlow conventions (extra complexity for no advantage for this project; too many merge commits; history difficult to follow)
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

The following methods have been renamed. You only need to search and replace, because the functionality has not been changed.

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

## Version 1.3.3

### Commits

- [11944e4](http://github.com/ddnexus/pagy/commit/11944e4): Fix typo in class name (#122)
- [40ef36d](http://github.com/ddnexus/pagy/commit/40ef36d): travis badge links to branches
- [78141a3](http://github.com/ddnexus/pagy/commit/78141a3): Improve default German translation (#120)
- [c0fe0df](http://github.com/ddnexus/pagy/commit/c0fe0df): minor typo corrections (#119)

## Version 1.3.2

### Changes

- fixed responsive javascript error

### Commits

- [332c6a2](http://github.com/ddnexus/pagy/commit/332c6a2): fix for responsive javascript error in slow loading pages (#115)

## Version 1.3.1

### Changes

- fixed issue with items extra rendered after pagy_nav

### Commits

- [3ead159](http://github.com/ddnexus/pagy/commit/3ead159): fix for temp items variable in items extra (#117)

## Version 1.3.0

### Changes

- Added Dutch locale
- Refactoring of plurals
- Javascript refactoring: fixes and improvements

### Commits

- [70796d3](http://github.com/ddnexus/pagy/commit/70796d3): Add Dutch language (#116)Added Dutch dictionary
- [b112f30](http://github.com/ddnexus/pagy/commit/b112f30): plurals.rb:
  - added frozen variables
  - added explicit 'zero' for :zero_one_few_may_other
  - added :pl pluralization (#111)
  - added README.md
- [6cf86af](http://github.com/ddnexus/pagy/commit/6cf86af): added docs notes
- [b05db4e](http://github.com/ddnexus/pagy/commit/b05db4e): added optional target element to Pagy.init for AJAX support
- [e35a9ae](http://github.com/ddnexus/pagy/commit/e35a9ae): refactoring of default element ids for helpers and deprecation:
  - default ids are now constant also in different processes and compliant also with older HTML versions
  - simpler deprecation code
- [cef823c](http://github.com/ddnexus/pagy/commit/cef823c): pagy.js responsive refactoring (#115):
  - moved handling of window event listeners into the responsive function
  - added resize delay to Pagy.responsive
- [a64a8bd](http://github.com/ddnexus/pagy/commit/a64a8bd): fix for items test
- [e9ab4a1](http://github.com/ddnexus/pagy/commit/e9ab4a1): renamed argument items > fetched; removed redundant assignation


## Version 1.2.1

### Changes

- Improved efficiency for count in backend and extras

### Commits

- [01178cb](http://github.com/ddnexus/pagy/commit/01178cb): replaced enumerable #count for #size (suggested in #112)
- [0723228](http://github.com/ddnexus/pagy/commit/0723228): count (and page) in *get_variables methods are set only when nil (alternative implementation of #112)

### Changes

- Deprecation of frontend helpers (see [Deprecations](https://github.com/ddnexus/pagy/blob/master/DEPRECATIONS.md))
- Internal refactoring of javascript
- added `support` extra for features like: incremental, infinite, auto-scroll pagination

### Commits

- [2bdb1e5](http://github.com/ddnexus/pagy/commit/2bdb1e5): added support extra
- [055af34](http://github.com/ddnexus/pagy/commit/055af34): added :cycle variable to Pagy
- [c1680ec](http://github.com/ddnexus/pagy/commit/c1680ec): add JSON/javascript deprecations
- [263c12d](http://github.com/ddnexus/pagy/commit/263c12d): better internal javascript naming
- [910facc](http://github.com/ddnexus/pagy/commit/910facc): updated tests
- [6e8cde8](http://github.com/ddnexus/pagy/commit/6e8cde8): refactoring of json tags:
  - single "pagy-json" class for all json tags
  - removed prefix used for all pagy element ids
  - extracted pagy_json_tag from frontend extras
- [98ce8e7](http://github.com/ddnexus/pagy/commit/98ce8e7): automatic ids based on hash must be strings
- [cd8256e](http://github.com/ddnexus/pagy/commit/cd8256e): added DEPRECATIONS file
- [6e3e1e4](http://github.com/ddnexus/pagy/commit/6e3e1e4): deprecated and renamed navs helpers in code, tests and docs; renamed navs extension as plain; added :pagy_plain_nav alias of :pagy_nav
- [4bc72af](http://github.com/ddnexus/pagy/commit/4bc72af): deprecated and renamed semantic navs in code, tests and docs
- [a9c3822](http://github.com/ddnexus/pagy/commit/a9c3822): deprecated and renamed materialize navs in code, tests and docs
- [5481f40](http://github.com/ddnexus/pagy/commit/5481f40): renamed foundation templates and updated docs
- [f984f83](http://github.com/ddnexus/pagy/commit/f984f83): deprecated and renamed foundation navs in code, tests and docs
- [95045c3](http://github.com/ddnexus/pagy/commit/95045c3): renamed bulma templates and updated docs
- [dbad41a](http://github.com/ddnexus/pagy/commit/dbad41a): deprecated and renamed bulma navs in code, tests and docs
- [e4f859f](http://github.com/ddnexus/pagy/commit/e4f859f): renamed bootstrap templates and updated docs
- [35078ab](http://github.com/ddnexus/pagy/commit/35078ab): deprecated and renamed bootstrap navs in code, tests and docs
- [04ec860](http://github.com/ddnexus/pagy/commit/04ec860): added Pagy.deprecate method

## Version 1.1.0

### Changes

- added `Pagy::Countless` support subclass
- added `countless` extra integrated with the other extras

### Commits

- [fa547ad](http://github.com/ddnexus/pagy/commit/fa547ad): reworded the doc notice about :pagy_countless_get_items returning an Array; fix typo in comment
- [8368a99](http://github.com/ddnexus/pagy/commit/8368a99): Synopsys > Synopsis
- [1b8a080](http://github.com/ddnexus/pagy/commit/1b8a080): a few fixes for the countless tests
- [0bf2f46](http://github.com/ddnexus/pagy/commit/0bf2f46): Typo fix
- [2f93227](http://github.com/ddnexus/pagy/commit/2f93227): Test coverage for `Pagy::Countless` (#108)
- [c2a25b6](http://github.com/ddnexus/pagy/commit/c2a25b6): Add some tests for Countless extra (#108)
- [04fa7a2](http://github.com/ddnexus/pagy/commit/04fa7a2): added countless support to the items extra
- [f272faf](http://github.com/ddnexus/pagy/commit/f272faf): added countless support to the overflow extra
- [7b25165](http://github.com/ddnexus/pagy/commit/7b25165): added countless sub-class and extra code
- [37cf51a](http://github.com/ddnexus/pagy/commit/37cf51a): series can return an empty array if size is empty
- [7bf9d14](http://github.com/ddnexus/pagy/commit/7bf9d14): fix for a few missing lines in the extras docs

## Version 1.0.0

### Breaking Changes

- The "Out Of Range" concept has been redefined as "Overflow" resulting in a few renaming. Since there are no changes in the logic, you can update by just searching and replacing (if present) a few string in your code:
  - `"/out_of_range"` > `"/overflow"`
  - `"OutOfRangeError"` > `"OverflowError"`
  - `":out_of_range_mode"` > `":overflow"`
  - `"out_of_range?` > `"overflow?"`

### Commits

- [431e4db](http://github.com/ddnexus/pagy/commit/431e4db): redefined the "Out Of Range" concept as "Overflow" (#103):
  - files: out_of_range* > overflow*
  - extra name: out_of_range > overflow
  - error class: OutOfRangeError > OverflowError
  - module: OutOfRange > Overflow
  - VARS: :out_of_range_mode > :overflow
  - instance variable: @out_of_range > @overflow
  - method: out_of_range? > overflow?
- [a0b411a](http://github.com/ddnexus/pagy/commit/a0b411a): added README note about semantic versioning

## Version 0.23.1

### Commits

- [e8a2251](http://github.com/ddnexus/pagy/commit/e8a2251): fix for ArgumentError feedback in Pagy constructor should show the originally passed offending value (#104)

## Version 0.23.0

### Changes

- Added German locale

### Commits

- [f41d465](http://github.com/ddnexus/pagy/commit/f41d465): German (#101)
- [b6149ec](http://github.com/ddnexus/pagy/commit/b6149ec): docs fixes
- [408cc32](http://github.com/ddnexus/pagy/commit/408cc32): fix for typo in CHANGELOG

## Version 0.22.0

### Changes

- Added Norwegian locale

### Commits

- [59064c2](http://github.com/ddnexus/pagy/commit/59064c2): Added Norwegian locale (#100)

## Version 0.21.0

### Changes

- Added Elasticsearch Rails extra

### Commits

- [e0acbf6](https://github.com/ddnexus/pagy/commit/e0acbf6): fix for robocop offenses (#96)
- [d082729](https://github.com/ddnexus/pagy/commit/d082729): Added Elasticsearch Rails extra (#96)
- [dd0575a](https://github.com/ddnexus/pagy/commit/dd0575a): fix doc typo
- [d3510a7](https://github.com/ddnexus/pagy/commit/d3510a7): updated comments in plurals.rb
- [5ed458a](https://github.com/ddnexus/pagy/commit/5ed458a): added README disclaimer
- [02b0a74](https://github.com/ddnexus/pagy/commit/02b0a74): Update link to Semantic-UI pagination

## Version 0.20.0

### Breaking Changes

- I18n refactoring
  - Combo helpers and item selectors have been refactored: you should update your overridden helpers accordingly
  - The i18n structure has changed, update your custom i18n locale file

### Commits

- [bab3bf8](https://github.com/ddnexus/pagy/commit/bab3bf8): Merge pull request #93 from ddnexus/i18n
- [f8017c3](https://github.com/ddnexus/pagy/commit/f8017c3): updated config/pagy.rb
- [c461885](https://github.com/ddnexus/pagy/commit/c461885): added ru plural proc
- [5680628](https://github.com/ddnexus/pagy/commit/5680628): fix for wrong indentation in zh-cn
- [6998932](https://github.com/ddnexus/pagy/commit/6998932): pagy.yml properly split into separate locale files
- [e3048f2](https://github.com/ddnexus/pagy/commit/e3048f2): improvements for ja tr and zh-cn
- [c1aec4c](https://github.com/ddnexus/pagy/commit/c1aec4c): removed marginal pagy.nav.current key used only by foundation an fixed consistency in foundation helpers and templates
- [15e413b](https://github.com/ddnexus/pagy/commit/15e413b): refactoring of the composition of i18n strings for compact helpers and items selector

## Version 0.19.4

### Changes

- added Japanese, Brazilian and Indonesian translations

### Commits

- [67f1bb9](https://github.com/ddnexus/pagy/commit/67f1bb9): reordered translations
- [4ab3438](https://github.com/ddnexus/pagy/commit/4ab3438): adding pt-br translation (#87)
- [d1f8674](https://github.com/ddnexus/pagy/commit/d1f8674): alpha-ordered translations
- [0311c85](https://github.com/ddnexus/pagy/commit/0311c85): Added Indonesian locale (#91)
- [ce68624](https://github.com/ddnexus/pagy/commit/ce68624): add japanese translation (#89)
- [5e4f93d](https://github.com/ddnexus/pagy/commit/5e4f93d): corrected chinese translation (#88)
- [26654d4](https://github.com/ddnexus/pagy/commit/26654d4): updated README

## Version 0.19.3

### Changes

- added Chinese locale

### Commits

- [ebc0ed5](https://github.com/ddnexus/pagy/commit/ebc0ed5): added Chinese locale
- [31823f9](https://github.com/ddnexus/pagy/commit/31823f9): fix for compact nav in bootstrap 3 (#86)
- [ac2a76c](https://github.com/ddnexus/pagy/commit/ac2a76c): docs fixes

## Version 0.19.2

### Changes

- added Russian locale

### Commits

- [099731b](https://github.com/ddnexus/pagy/commit/099731b): small improvement in i18n docs
- [ef77ae2](https://github.com/ddnexus/pagy/commit/ef77ae2): Added ru translation (#84)
- [d4b49d6](https://github.com/ddnexus/pagy/commit/d4b49d6): Fixed a typo in spanish locale. (#85)
- [a91b72a](https://github.com/ddnexus/pagy/commit/a91b72a): small description change for items selector UI
- [a62b222](https://github.com/ddnexus/pagy/commit/a62b222): small refactoring of the trim extra
- [c23505a](https://github.com/ddnexus/pagy/commit/c23505a): fix for doc typo

## Version 0.19.1

### Changes

- added Spanish locale

### Commits

- [6d498a1](https://github.com/ddnexus/pagy/commit/6d498a1): Added Spanish locale (#82)
- [65db877](https://github.com/ddnexus/pagy/commit/65db877): general docs improvements
- [5862b3f](https://github.com/ddnexus/pagy/commit/5862b3f): updated README
- [6414395](https://github.com/ddnexus/pagy/commit/6414395): added GoRails screencast link to README
- [a8ad399](https://github.com/ddnexus/pagy/commit/a8ad399): docs fixes and improvements
- [435e849](https://github.com/ddnexus/pagy/commit/435e849): updated docs


## Version 0.19.0

### Important Changes

- added Semantic extra

### Commits

- [b65a905](https://github.com/ddnexus/pagy/commit/b65a905): fix for page_link string and conflicts, added compact and responsive navs tests and docs (#73)
- [f147cca](https://github.com/ddnexus/pagy/commit/f147cca): Semantic UI nav helper (#73)
- [429ac14](https://github.com/ddnexus/pagy/commit/429ac14): updated pagy.js requirements info

## Version 0.18.0

### Breaking Changes

- The extras dir has been reorganized:
  - the helpers in the `compact` and `responsive` extras have been integrated into the respective frontend extras (`bootstrap`, `bulma`, `foundation`, `materialize` and `navs`), so the `compact` and `responsive` extras are gone. You should remove them from the [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) initializer, eventually adding the `navs` extra if you use its plain helpers.
  - The `templates` and `javascripts` dirs have been moved to `lib`. If you use rails and the `pagy.js` you should update the `assets.paths` in the [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) initializer.

### Commits

- [8865fdb](https://github.com/ddnexus/pagy/commit/8865fdb): updated docs
- [f093c7e](https://github.com/ddnexus/pagy/commit/f093c7e): reorganization of tests
- [cd11c4f](https://github.com/ddnexus/pagy/commit/cd11c4f): reorganization of extras dir

## Version 0.17.0

### Important Changes

- added Foundation extra

### Commits

- [ba7d046](https://github.com/ddnexus/pagy/commit/ba7d046): added fixes and improvements for foundation extra:
- [d78f85d](https://github.com/ddnexus/pagy/commit/d78f85d): Foundation extra (#79)
- [13f37a0](https://github.com/ddnexus/pagy/commit/13f37a0): restyling of extras in README, docs and initializer example

## Version 0.16.0

### Important Changes

- added Searchkick extra

### Commits

- [6143f5f](https://github.com/ddnexus/pagy/commit/6143f5f): docs fixes
- [5227bd1](https://github.com/ddnexus/pagy/commit/5227bd1): added searchkick references in docs, README and initializer example (#75)
- [b9acf0c](https://github.com/ddnexus/pagy/commit/b9acf0c): Searchkick extra (#75)

## Version 0.15.1

### Important Changes

- small bugs and compatibility fixes

### Commits

- [1436833](https://github.com/ddnexus/pagy/commit/1436833): added Post and Tutorials links and Credits section
- [4e400c6](https://github.com/ddnexus/pagy/commit/4e400c6): items are adjusted only for non-empty pages
  (avoid sequel error for limit 0)
- [3abcc11](https://github.com/ddnexus/pagy/commit/3abcc11): fix for sinatra: page_param must be converted to string
- [ad8c311](https://github.com/ddnexus/pagy/commit/ad8c311): fix for trim extra missing when current page=1
- [6f774d7](https://github.com/ddnexus/pagy/commit/6f774d7): added missing doc menu for trim extra
- [5f6de56](https://github.com/ddnexus/pagy/commit/5f6de56): added a few tests for the trim extra

## Version 0.15.0

### Important Changes

- Added Trim extra

### Commits

- [868be25](https://github.com/ddnexus/pagy/commit/868be25): added trim extra
- [fb48976](https://github.com/ddnexus/pagy/commit/fb48976): chained method for extra items overrides

## Version 0.14.0

### Important Changes

- Added Materialize extra

### Commits

- [b0e959b](https://github.com/ddnexus/pagy/commit/b0e959b): added stars github button to docs
- [1dd38c9](https://github.com/ddnexus/pagy/commit/1dd38c9): added materialize extra (#44)
- [30c1a57](https://github.com/ddnexus/pagy/commit/30c1a57): updated docs

## Version 0.13.1

### Important Changes

- Improvements and fixes for the out_of_range extra

### Commits

- [419af23](https://github.com/ddnexus/pagy/commit/419af23): better comments and error message for unknown out_of_range_mode variable
- [48fa056](https://github.com/ddnexus/pagy/commit/48fa056): use case (#71)
- [36761a8](https://github.com/ddnexus/pagy/commit/36761a8): fix :last_page mode in out_of_range extra (#70)
- [5958dc5](https://github.com/ddnexus/pagy/commit/5958dc5): out_of_range extra improvements (#68)
- [7177cd9](https://github.com/ddnexus/pagy/commit/7177cd9): added note about the out_of_range exta to the README

## Version 0.13.0

### Important Changes

- Added Out Of Range extra

### Commits

- [c52db2a](https://github.com/ddnexus/pagy/commit/c52db2a): added out_of_range extra (#68)
- [37119ee](https://github.com/ddnexus/pagy/commit/37119ee): fixes for bulma extra in initializer_example.rb and docs
- [05729f6](https://github.com/ddnexus/pagy/commit/05729f6): removed redundant condition in Pagy initialize
- [2e75247](https://github.com/ddnexus/pagy/commit/2e75247): small fixes in CHANGELOG
- [3d732dd](https://github.com/ddnexus/pagy/commit/3d732dd): docs for empty page OutOfRangeError (#69)
- [a3be52e](https://github.com/ddnexus/pagy/commit/a3be52e): Fixed screenshot name for compact bulma extra (#67)

## Version 0.12.0

### Important Changes

- Added Bulma extra
- Added Turkish language in pagy dictionary
- Improved consistence and compatibility in extras

### Commits

- [8fc91df](https://github.com/ddnexus/pagy/commit/8fc91df): fix for "area" typos in bulma extra (#62) and consistency improvement across responsive helpers
- [bb0060f](https://github.com/ddnexus/pagy/commit/bb0060f): fix for window event listeners persisted by turbolinks (#64)
- [d759f91](https://github.com/ddnexus/pagy/commit/d759f91): Bulma extra (#62)
- [9f09837](https://github.com/ddnexus/pagy/commit/9f09837): Fixed typo in some extras usage (#63)
- [2ce572a](https://github.com/ddnexus/pagy/commit/2ce572a): Added Turkish locales (#58)
- [dd361e1](https://github.com/ddnexus/pagy/commit/dd361e1): replaced Array.from in pagy.js for extended compatibility
- [bb1243d](https://github.com/ddnexus/pagy/commit/bb1243d): fix typos
- [da34b94](https://github.com/ddnexus/pagy/commit/da34b94): fix typo (#61)
- [cdab354](https://github.com/ddnexus/pagy/commit/cdab354): added better I18n comments in initializer_example.rb

## Version 0.11.2

### Commits

- [76fc273](https://github.com/ddnexus/pagy/commit/76fc273): used merge! in place of **

## Version 0.11.1

### Important Changes

- All tests has been converted to the spec syntax

### Commits

- [b14f446](https://github.com/ddnexus/pagy/commit/b14f446): converted tests to spec syntax
- [0422568](https://github.com/ddnexus/pagy/commit/0422568): cleanup of i81n plurals in code and docs
- [5a2db16](https://github.com/ddnexus/pagy/commit/5a2db16): added a few missing references to docs
- [6028980](https://github.com/ddnexus/pagy/commit/6028980): enabled rubocop Naming/UncommunicativeMethodParamName
- [1de470b](https://github.com/ddnexus/pagy/commit/1de470b): small improvements and fixes for docs
- [228109e](https://github.com/ddnexus/pagy/commit/228109e): fix for typos
- [0a1ed94](https://github.com/ddnexus/pagy/commit/0a1ed94): updated initializer_example.rb

## Version 0.11.0

### Breaking Changes

- The `pagy_nav_bootstrap_compact` and `pagy_nav_boostrap_responsive` helpers have been renamed as `pagy_nav_compact_bootstrap` and `pagy_nav_responsive_bootstrap` to keep the consistency with the extras structure (and support the consistency of future framework additions). Please, rename them accordingly.
- The `Pagy::Frontend::I18N.load_file` has been renamed as `Pagy::Frontend::I18N.load` and expects a hash as the argument. See the [I18n doc](https://ddnexus.github.io/pagy/api/frontend#i18n).
- The seldom used `Pagy::Frontend::I18N[plurals]` has been renamed as `Pagy::Frontend::I18N[plural]`. See the [I18n doc](https://ddnexus.github.io/pagy/api/frontend#i18n).
- Please, update your initializer file to the new [initializer_example.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/initializer_example.rb)

### Commits

- [826798b](https://github.com/ddnexus/pagy/commit/826798b): refactoring of I18N constant: added support for multiple static languages and plural rules
- [b78b71e](https://github.com/ddnexus/pagy/commit/b78b71e): better naming of json classes
- [ea7c22b](https://github.com/ddnexus/pagy/commit/ea7c22b): breaking change for compact and responsive extras: renaming of pagy_nav_bootstrap_* helpers to pagy_nav_*_bootstrap, consistent with extras structure
- [7d1a573](https://github.com/ddnexus/pagy/commit/7d1a573): internal consistency renaming of local/test variables; minor fixes and improvements

## Version 0.10.1

### Commits

- [8ca5013](https://github.com/ddnexus/pagy/commit/8ca5013): doc improvements
- [99081ee](https://github.com/ddnexus/pagy/commit/99081ee): small performance improvement for #51 and updated doc
- [5863ceb](https://github.com/ddnexus/pagy/commit/5863ceb): add support for counting grouped collections (#51)

## Version 0.10.0

### Breaking Changes

- The javascript used by the `compact`, `items` and `responsive` extras has been refactored in order to avoid any usafe-inline vulnerability. The javascript files have been replaced by one shared file, and require to set an event listener or run a function on window load. See the commit below and the [javascript doc](https://ddnexus.github.io/pagy/extras#javascript) for details.

### Commits

- [50e304b](https://github.com/ddnexus/pagy/commit/50e304b): javascript refactoring in order to avoid any usafe-inline vulnerability (#52):
  - removed inline scripts from all extras
  - one single pagy.js file shared among all the extras
  - the Pagy.init function should be executed at document load
  - updated tests and docs
- [32d0afc](https://github.com/ddnexus/pagy/commit/32d0afc): doc fix: UI selector > selector UI

## Version 0.9.2

### Important Changes

- 100% test coverage for core code and extras

### Commits

- [c11dfcc](https://github.com/ddnexus/pagy/commit/c11dfcc): updated README
- [f8728e7](https://github.com/ddnexus/pagy/commit/f8728e7): added responsive extra tests
- [14ea356](https://github.com/ddnexus/pagy/commit/14ea356): added compact extra tests
- [2ac743c](https://github.com/ddnexus/pagy/commit/2ac743c): added bootstrap extra test
- [159b65e](https://github.com/ddnexus/pagy/commit/159b65e): added i18n extra tests
- [4449c95](https://github.com/ddnexus/pagy/commit/4449c95): normalization of indentation and empty lines
- [9afa9d9](https://github.com/ddnexus/pagy/commit/9afa9d9): Default Frozen Strings for Ruby Files (#49)
- [036c87f](https://github.com/ddnexus/pagy/commit/036c87f): Fix typo in :page_param configuration (#48)

## Version 0.9.1

### Important Changes

- Improved the Pagy::OutOfRangeError exception, now storing the failed Pagy object

### Commits

- [9817659](https://github.com/ddnexus/pagy/commit/9817659): improved OutOfRangeError exception (storing the failed Pagy object)
- [7195229](https://github.com/ddnexus/pagy/commit/7195229): a few minor consistency fixes for the initializer_example.rb
- [00cd5bb](https://github.com/ddnexus/pagy/commit/00cd5bb): Fix typo (#45)
- [8b3a733](https://github.com/ddnexus/pagy/commit/8b3a733): fix for header level in README

## Version 0.9.0

### Important Changes

- Improvements for compact extra
- Refactoring of test structure and tasks
- Added items extra: Allow the client to request a custom number of items per page with an optional selector UI

### Commits

- [45dd700](https://github.com/ddnexus/pagy/commit/45dd700): added array extra tests
- [623ce9e](https://github.com/ddnexus/pagy/commit/623ce9e): Added items extra and tests
- [5902e8a](https://github.com/ddnexus/pagy/commit/5902e8a): passed instance variables are not deleted from the vars hash
- [e2efb89](https://github.com/ddnexus/pagy/commit/e2efb89): refactoring of test structure
- [1cc335b](https://github.com/ddnexus/pagy/commit/1cc335b): documentation updates
- [42ba053](https://github.com/ddnexus/pagy/commit/42ba053): improved pagy-compact.js
- [8c20fa2](https://github.com/ddnexus/pagy/commit/8c20fa2): Enable support for return key inside Pagy compact input (#43)
- [d4b751c](https://github.com/ddnexus/pagy/commit/d4b751c): Documentation updates
- [9f0dec9](https://github.com/ddnexus/pagy/commit/9f0dec9): fix for broken links in docs
- [c41e823](https://github.com/ddnexus/pagy/commit/c41e823): additions and normalization of documentation and comments
- [38f9a49](https://github.com/ddnexus/pagy/commit/38f9a49): fix for broken links in readme

## Version 0.8.6

### Commits

- [0db9125](https://github.com/ddnexus/pagy/commit/0db9125): minor documentation improvements
- [8a0a5a8](https://github.com/ddnexus/pagy/commit/8a0a5a8): broader parallel assignment in methods (improved performance)
- [18baa8b](https://github.com/ddnexus/pagy/commit/18baa8b): small optimization (used a few less objects)
- [1d16e3d](https://github.com/ddnexus/pagy/commit/1d16e3d): documentation additions
- [62c420d](https://github.com/ddnexus/pagy/commit/62c420d): updated doc and charts

## Version 0.8.5

### Important Changes

- Fix for I18n exception on startup

### Commits

- [31b815d](https://github.com/ddnexus/pagy/commit/31b815d): fix for I18n exception on startup (#41)

## Version 0.8.4

### Important Changes

- Improved readability and memory allocation
- All the core methods are tested
- Better documentation

### Commits

- [c25493a](https://github.com/ddnexus/pagy/commit/c25493a): added backend tests
- [48dbe17](https://github.com/ddnexus/pagy/commit/48dbe17): docs small fixes and improvements
- [5e9b7d4](https://github.com/ddnexus/pagy/commit/5e9b7d4): add Pagy::VARS[:item_path] empty default
- [ce8d09a](https://github.com/ddnexus/pagy/commit/ce8d09a): add Pagy::VARS[:anchor] empty default
- [8789edd](https://github.com/ddnexus/pagy/commit/8789edd): improve readability of pagy_link_proc (#40):
  - remove conditions to avoid extra spaces inside the html tags
  - add Pagy::VARS[:link_extra] empty default
- [2f0d384](https://github.com/ddnexus/pagy/commit/2f0d384): docs additions

## Version 0.8.3

### Important Changes

- Refactoring of `I18N` to fix #39

### Breaking Changes

- `Pagy::I18N` has been moved to `Pagy::Frontend::I18N`: you should update the [initializer](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/initializer_example.rb) in case you set any of the `Pagy::I18N` variable. Read [I18n](docs/api/I18n.md) for details.

### Commits

- [d85791e](https://github.com/ddnexus/pagy/commit/d85791e): Refactoring I18N to fix #39:
  - moved I18N from Pagy to Pagy::Frontend - I18N_DATA moved to Pagy::Frontend::I18N[:data]
  - I18N[:file] removed
  - added I18N.load_file method
  - updated initializer and doc
- [504b943](https://github.com/ddnexus/pagy/commit/504b943): added missing tests to frontend_test.rb
- [6168df3](https://github.com/ddnexus/pagy/commit/6168df3): use actionable code coverage (#29)

## Version 0.8.2

### Important Changes

- Fix for PostgreSQL: `collection.count(:all)`

### Commits

- [8a204dc](https://github.com/ddnexus/pagy/commit/8a204dc): fix for count in Pagy::Backend (#36)
- [29ed221](https://github.com/ddnexus/pagy/commit/29ed221): added test_check_variable_defaults
- [1263540](https://github.com/ddnexus/pagy/commit/1263540): indentation fixes for tests
- [a927d57](https://github.com/ddnexus/pagy/commit/a927d57): improve testability by sorting tests into files that mirror lib + group by method (#37)
- [5a5178b](https://github.com/ddnexus/pagy/commit/5a5178b): docs markdown normalization and README editing
- [11fbc49](https://github.com/ddnexus/pagy/commit/11fbc49): examples was using responsive instead of i18n (#35)
- [b9517d3](https://github.com/ddnexus/pagy/commit/b9517d3): docs small fixes and improvements
- [8bc6900](https://github.com/ddnexus/pagy/commit/8bc6900): fix for typos and omissions in initializer_example.rb
- [a09558e](https://github.com/ddnexus/pagy/commit/a09558e): avoid uncoverable code by not using gemspec in Gemfile (#33)
- [a585fe6](https://github.com/ddnexus/pagy/commit/a585fe6): clean up gemspec (#32)
- [ae48f13](https://github.com/ddnexus/pagy/commit/ae48f13): test on all supported ruby versions and split out rubocop (#30)

## Version 0.8.1

### Important Changes

- Added `:params` and `:anchor` variables to control the generation of arbitrary URLs per pagy instance

### Commits

- [d185461](https://github.com/ddnexus/pagy/commit/d185461): added :params and :anchor variables to control the generation of arbitrary URLs per pagy instance
- [62fd6c8](https://github.com/ddnexus/pagy/commit/62fd6c8): better forward improvements with pagy_url_for receiving the pagy instance instead of the single pagy_param
- [748de0d](https://github.com/ddnexus/pagy/commit/748de0d): readme and changelog improvement

## Version 0.8.0

### Important Changes

- Added an [initializer_example.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/initializer_example.rb) that you can use as an easy template for Pagy configuration
- Integrated extras from `pagy-extras` gem into Pagy, now optionally required in the initializer
- Refactored I18n: simpler code and simpler configuration now based on the `I18n` extra
- Reorganized documentation and added a few more how-to topics
- Added the `:page_param` variable used to get the page number from and create the URL for the page links

### Breaking Changes

- Extra are now integrated in Pagy. The `pagy-extras` gem has been discontinued: you should remove it and update your code as indicated [here](https://github.com/ddnexus/pagy-extras)
- Pagy I18n has been refactored and it's simpler to use. The main change is that the `Pagy::I18N[:gem]` variable has been removed, so if you want to use the `I18n` gem in place of the internal Pagy implementation you need just to `require 'pagy/extras/i18n'` in your initializer. (see the [I18n doc](https://ddnexus.github.io/pagy/api/frontend.md#i18n))
- `pagy_url_for` now requires the pagy argument and it's called with 2 params: if you have overridden it, you should add the extra param.
- `pagy_get_vars` now requires the vars argument and it's called with 2 params: if you have overridden it, you should add the extra param.
- `pagy_array_get_vars` now requires the vars argument and it's called with 2 params: if you have overridden it, you should add the extra param.

### Commits

- [3e2ad90](https://github.com/ddnexus/pagy/commit/3e2ad90): added CHANGELOG.md with the latest few versions (#23)
- [f42811d](https://github.com/ddnexus/pagy/commit/f42811d): implemented :page_param (#20)
- [9040593](https://github.com/ddnexus/pagy/commit/9040593): added doc about skipping single pages navs
- [605169a](https://github.com/ddnexus/pagy/commit/605169a): added initializer_example.rb
- [daa2c1b](https://github.com/ddnexus/pagy/commit/daa2c1b): I18n refactoring:
  - simplified the pagy_t definition
  - simplified the configuration of I18n now using the I18n extra to override the pagy_t
  - modules are now required and not autoloaded
  - updated doc
- [9b0d420](https://github.com/ddnexus/pagy/commit/9b0d420): style cleanup (#24)
- [dbc5a05](https://github.com/ddnexus/pagy/commit/dbc5a05): Add prev/next links to compact Bootstrap nav and improve HTML semantics (#21)
- [f764cc1](https://github.com/ddnexus/pagy/commit/f764cc1): refactoring extras:
  - moved pagy-extra files into the extras dir - moved the templates dir into the extras dir
  - updated the documentation
- [befe92d](https://github.com/ddnexus/pagy/commit/befe92d): Fixes Travis Badge (#25)
- [3862d26](https://github.com/ddnexus/pagy/commit/3862d26): Travis (#22)
- [7050ee0](https://github.com/ddnexus/pagy/commit/7050ee0): basic rubocop setup (#18)
- [7aee689](https://github.com/ddnexus/pagy/commit/7aee689): small docs improvements

## Version 0.7.2

### Commits

- [527cd8e](https://github.com/ddnexus/pagy/commit/527cd8e): simplification of pagy_url_for
- [144c997](https://github.com/ddnexus/pagy/commit/144c997): URIs are always joined with forward slash (#11)

## Version 0.7.1

### Commits

- [92260b5](https://github.com/ddnexus/pagy/commit/92260b5): docs and comments refactoring, also updated for pagy-extras v0.2.0
- [46f235e](https://github.com/ddnexus/pagy/commit/46f235e): Remove a couple of Range allocations (#10)
- [39c5470](https://github.com/ddnexus/pagy/commit/39c5470): Only use and/or keywords for control flow (#12)
- [26bb29c](https://github.com/ddnexus/pagy/commit/26bb29c): fix for last page items adjusted to 0 (#3)
- [860c579](https://github.com/ddnexus/pagy/commit/860c579): small improvement: to_i called only once in core variables set
- [b18f254](https://github.com/ddnexus/pagy/commit/b18f254): Merge pull request #5 from artinboghosian/patch-1
- [03d6ee8](https://github.com/ddnexus/pagy/commit/03d6ee8): Update README.md
- [358a806](https://github.com/ddnexus/pagy/commit/358a806): a couple of links added to the doc
- [fac1f34](https://github.com/ddnexus/pagy/commit/fac1f34): docs small fixes and improvements

## Version 0.7.0

### Commits

- [e480d04](https://github.com/ddnexus/pagy/commit/e480d04): better handling of blank core variables
- [b56ef9e](https://github.com/ddnexus/pagy/commit/b56ef9e): docs fixes and improvements
- [987be15](https://github.com/ddnexus/pagy/commit/987be15): I18N[:plurals] proc uses symbols and returns a frozen string
- [6ea7a48](https://github.com/ddnexus/pagy/commit/6ea7a48): changes for PR #2: - use of local variable zero_one instead of constant I18N_PLURALS - VARS cannot be frozen
- [fb8975b](https://github.com/ddnexus/pagy/commit/fb8975b): Freeze class immutable constant variable at first

## Version 0.6.0

### Commits

- [ec8e268](https://github.com/ddnexus/pagy/commit/ec8e268): created pagy-extras gem:
  - moved pagy_nav_bootstrap method and templates
  - updated docs files (fixes and use of relative links)
- [facc4c3](https://github.com/ddnexus/pagy/commit/facc4c3): unescaped notation for all erb usage
- [26c068f](https://github.com/ddnexus/pagy/commit/26c068f): moved require yaml in Frontend
- [f5782d8](https://github.com/ddnexus/pagy/commit/f5782d8): added css classes to pagy helper navs
- [cee02c6](https://github.com/ddnexus/pagy/commit/cee02c6): helper tags are strings
- [4788c3c](https://github.com/ddnexus/pagy/commit/4788c3c): grouped the variables :initial, :before, :after and :final into one single :size array; #series can work with different sizes
- [e610b82](https://github.com/ddnexus/pagy/commit/e610b82): minor docs fixes
