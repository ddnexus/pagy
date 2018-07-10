# CHANGELOG

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
- Added items extra: Allow the client to request a custom number of items per page with a ready to use selector UI

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

- `Pagy::I18N` has been moved to `Pagy::Frontend::I18N`: you should update the [initializer](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/initializer_example.rb) in case you set any of the `Pagy::I18N` variable. Read [I18n](docs/api/frontend.md#I18n) for details.

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

- Extras are now integrated in Pagy. The `pagy-extras` gem has been discontinued: you should remove it and update your code as indicated [here](https://github.com/ddnexus/pagy-extras)
- Pagy I18n has been refactored and it's simpler to use. The main change is that the `Pagy::I18N[:gem]` variable has been removed, so if you want to use the `I18n` gem in place of the internal Pagy implementation you need just to `require 'pagy/extra/i18n'` in your initializer. (see the [I18n doc](https://ddnexus.github.io/pagy/api/frontend.md#i18n))
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
