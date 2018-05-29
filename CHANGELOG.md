# CHANGELOG

## Version 0.8.0

### Important Changes:

- Added an [initializer_example.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/initializer_example.rb) that you can use as an easy template for pagy configuration
- Integrated extras from `pagy-extras` gem into pagy, now optionally required in the initializer
- Refactored I18n: simpler code and simpler configuration now based on the `I18n` extra
- Reorganized documentation and added a few more how-to topics
- Added the `:page_param` variable used to get the page number from and create the URL for the page links


### Breaking changes:

- Extras are now integrated in pagy. The `pagy-extras` gem has been discontinued: you should remove it and update your code as indicated [here](https://github.com/ddnexus/pagy-extras)
- Pagy I18n has been refactored and it's simpler to use. The main change is that the `Pagy::I18N[:gem]` variable has been removed, so if you want to use the `I18n` gem in place of the internal pagy implementation you need just to `require 'pagy/extra/i18n'` in your initializer. (see https://ddnexus.github.io/pagy/api/frontend.md#i18n)
- `pagy_url_for` now requires the page_param argument and is called with 2 params: if you have overridden it, you should add the extra param.
- `pagy_get_vars` now requires the vars argument and is called with 2 params: if you have overridden it, you should add the extra param.
- `pagy_array_get_vars` now requires the vars argument and is called with 2 params: if you have overridden it, you should add the extra param.
- 
### Commits

- 08c9b91 implemented :page_param (#20)
- 1cf935c added doc about skipping single pages navs
- 26fdae4 added initializer_example.rb
- daa2c1b I18n refactoring:
  - simplified the pagy_t definition
  - simplified the configuration of I18n now using the I18n extra to override the pagy_t
  - modules are now required and not autoloaded - updated doc
- 9b0d420 style cleanup (#24)
- dbc5a05 Add prev/next links to compact Bootstrap nav and improve HTML semantics (#21)
- f764cc1 refactoring extras:
  - moved pagy-extra files into the extras dir
  - moved the templates dir into the extras dir
  - updated the documentation

## Version 0.7.2

### Commits

- 527cd8e simplification of pagy_url_for
- 144c997 URIs are always joined with forward slash (#11)

## Version 0.7.1

### Commits

- 92260b5 docs and comments refactoring, also updated for pagy-extras v0.2.0
- 46f235e Remove a couple of Range allocations (#10)
- 39c5470 Only use and/or keywords for control flow (#12)
- 26bb29c fix for last page items adjusted to 0 (#3)
- 860c579 small improvement: to_i called only once in core variables set
- d6659ca version 0.7.1
- b18f254 Merge pull request #5 from artinboghosian/patch-1
- 03d6ee8 Update README.md
- 358a806 a couple of links added to the doc
- fac1f34 docs small fixes and improvements

## Version 0.7.0

### Commits

- e480d04 better handling of blank core variables
- 7504fe4 version 0.7.0
- b56ef9e docs fixes and improvements
- 987be15 I18N[:plurals] proc uses symbols and returns a frozen string
- 6ea7a48 changes for PR #2: - use of local variable zero_one instead of constant I18N_PLURALS - VARS cannot be frozen
- 64ddfd6 updated Gemfile.lock
- 473cbb4 Merge pull request #2 from berniechiu/enhance/further-freezing-of-immutable-data
- 75e9428 version 0.6.1
- fb8975b Freeze class immutable constant variable at first

## Version 0.6.0

### Commits

- ec8e268 created pagy-extras gem: - moved pagy_nav_bootstrap method and templates - updated docs files (fixes and use of relative links)
- facc4c3 unescaped notation for all erb usage
- 26c068f moved require yaml in Frontend
- f5782d8 added css classes to pagy helper navs
- cee02c6 helper tags are strings
- 4788c3c grouped the variables :initial, :before, :after and :final into one single :size array; #series can work with different sizes
- e610b82 minor docs fixes

## Version 0.5.0

### Commits

- 695d76a Merge branch 'dev'
- 0366669 hotfix for broken links
- 486325a Merge branch 'dev'
- 4a8354b edited README
- 86a52d9 added documentation
- 9c7d02e refactoring of pagy_info
- 393d007 refactoring of Backend
- 459e593 initial offset renamed to outset; fixed values of from and to
- e03781e extracted series as a method
- 39e6b04 all-caps constants (Vars > VARS; I18n > I18N)
- 8498d0e I18n refactoring
- ac3d184 added pagy_get_params to Frontend
- c906def removed doc comments (to be moved in the doc)
- 1a4ae91 refactoring of Frontend
- 3dfb8f8 improved validation of core variables
- f5a4105 Pagy::Vars is a simple hash
- 0dd1fb7 renamed Opts > Vars, opts > vars
- 509862d renamed limit > items
- bb29f19 renamed nav templates; used if in place of case
- fb84e82 minor comments fixes
- e15ce0b added \&nbsp; in prev and next buttons
