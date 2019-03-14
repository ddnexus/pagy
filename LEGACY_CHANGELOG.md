# LEGACY CHANGELOG

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

- [3ead159](http://github.com/ddnexus/pagy/commit/3ead159): fix for temp items variable in items extra (
#117)

## Version 1.3

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
    - default ids are now constant also in different processes and compliant also with oder HTML versions
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
  - Compact helpers and item selectors have been refactored: you should update your overridden helpers accordingly
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
- [5227bd1](https://github.com/ddnexus/pagy/commit/5227bd1): added searchkick references in docs, README and inititalizer example (#75)
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
