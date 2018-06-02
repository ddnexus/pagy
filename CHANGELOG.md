# CHANGELOG

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

- Added an [initializer_example.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/initializer_example.rb) that you can use as an easy template for pagy configuration
- Integrated extras from `pagy-extras` gem into pagy, now optionally required in the initializer
- Refactored I18n: simpler code and simpler configuration now based on the `I18n` extra
- Reorganized documentation and added a few more how-to topics
- Added the `:page_param` variable used to get the page number from and create the URL for the page links

### Breaking Changes

- Extras are now integrated in pagy. The `pagy-extras` gem has been discontinued: you should remove it and update your code as indicated [here](https://github.com/ddnexus/pagy-extras)
- Pagy I18n has been refactored and it's simpler to use. The main change is that the `Pagy::I18N[:gem]` variable has been removed, so if you want to use the `I18n` gem in place of the internal pagy implementation you need just to `require 'pagy/extra/i18n'` in your initializer. (see the [I18n doc](https://ddnexus.github.io/pagy/api/frontend.md#i18n))
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
