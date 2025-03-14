---
icon: versions
---

# CHANGELOG

## Release Policy

Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/), and introduces BREAKING CHANGES only for MAJOR versions.

We release any new version (MAJOR, MINOR, PATCH) as soon as it is ready for release, regardless of any time constraint, frequency
or duration.

We rarely deprecate elements (releasing a new MAJOR version is just simpler and more efficient). However, when we do, you can
expect the old/deprecated functionality to be supported ONLY during the current MAJOR version.

## Recommended Version Constraint

Given a version number `MAJOR.MINOR.PATCH` (e.g. `10.0.0`):

The `gem 'pagy', '~> 10.0'` Gemfile entry (without the PATCH number) ensures that the `bundle update` command will update pagy to
the most recent version WITHOUT BREAKING CHANGES.

Increment the MAJOR version in your Gemfile ONLY when you are ready to handle the BREAKING CHANGES.

## Breaking Changes

If you upgrade from version `< 10.0.0` see the following:

- [Breaking changes in version 10.0.0](#version-1000)
- [Breaking changes in version 9.0.0](CHANGELOG_LEGACY#version-900)
- [Breaking changes in version 8.0.0](CHANGELOG_LEGACY#version-800)
- [Breaking changes in version 7.0.0](CHANGELOG_LEGACY#version-700)
- [Breaking changes in version 6.0.0](CHANGELOG_LEGACY#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY#version-100)

## Deprecations

None

<hr>

## Version 10.0.0

#### A complete redesign of the legacy code.

- **New [Keynav](toolbox/paginators/keynav_js.md) Pagination**
  - The pagy-exclusive technique using [keyset](toolbox/paginators/keyset.md) pagination alongside
    all frontend helpers.
- **Method Autoloading**
  - Methods are autoloaded only if used, unused methods consume no memory.
- **Intelligent automation**
  - [Configuration](toolbox/initializer.md) requirements reduced by 99%, simplified [JavaScript](resources/javascript.md)
    setup and automatic [I18n](resources/i18n.md)) loading.
- **Simplified user interaction**
  - You solely need the [pagy](toolbox/paginators.md) method and
    the [@pagy](toolbox/methods.md) instance, to paginate any collection, and use any navigation
    tag and helper.
- **[Self-explaining API](https://github.com/ddnexus/pagy#examples)**
  - Explicit and unambiguous renaming reduces the need to consult the documentation.
- **New and simpler [documentation](guides/quick-start.md)**
  - Very concise, straightforward, easy to navigate and understand.
- **Effortless [overriding](guides/how-to#override-pagy-methods)**
  - The new methods have narrower scopes and can be overridden without deep knowledge.

Take a look at the [Examples](https://github.com/ddnexus/pagy#examples) for a quick overview.

### Breaking Changes / Updating Guide

Your existing code will require several minor adjustments to function. Following these changes, **this API will remain stable for
a long time**.

#### Replace your `pagy.rb` config file

- Nearly all statements in the old file are obsolete; it's recommended to start fresh with the new, concise version of the file.
- The `Pagy::DEFAULT` is now frozen and used internally. Use the `Pagy.options` hash to the same effect.
- Copy over the relevant `Pagy::DEFAULT` values (most are no longer needed) and replace `Pagy::DEFAULT` with `Pagy.options`.

#### The `Pagy::Backend` has been replaced

- Replace `include Pagy::Backend` with `include Pagy::Method` since Pagy now includes only the `pagy` method.

#### All the `pagy_*` methods and the `Pagy::Frontend` are gone

- Remove any existing `include Pagy::Frontend`
- The paginators (i.e. the `pagy_*` methods returning the `@pagy` instance and the `@records`) got integrated in the `pagy`
  method.
  - The old `pagy(...)` statement works as-is, but it is _preferable_ to update it to the new explicit syntax:
    `pagy(:offset, ...)`.
- All the `pagy_*` helpers provided by the `Pagy::Frontend` are now `@pagy` instance methods (and most have been renamed). _(See
  how to replace them in the [Extras Changes](#extras-changes))_

#### Core changes

- The `:params` variable/option has been removed and replaced with the `:querify` option, which is a `lambda` that can modify
  the string-keyed query hash at will. It is a bit more verbose, but it's a very powerful and efficient low-level modification,
  solves an incompatibility with the old high level `:params` hash and improve performnce. It is part of
  the [Common URL Options](toolbox/paginators#common-url-options) group that gives you full and efficient control on the URL composition.
  - Replace the existing `:params` hash with the lambda that merges them:
    ```ruby
    # Old symbol-keyed, high-level hash variable
    params: { a: 1, b: 2 } 
    # New string-keyed, low-level, direct modification of the query hash
    querify: ->(q) { q.merge!('a' => 1, 'b' => 2) } 
    # It also allows to do things like:
    querify = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
    ```
- The `:page_param` and `:limit_param` have been replaced by `:page_key` and `:limit_key`, which are strings now, not symbols (for
  significant fewer conversions).
- The `count_args` variable has been removed. Pagy sets it automatically.
- The `:outset` and `:cycle` variables have been removed.
  - They were seldom used, mostly useless, and implementing them in your own code is trivial.
- The `:anchor_string` variable has been removed
  - It was only helpful for adding `data-remote="true"`, which is obsolete. Rails apps relying on it cannot run on Ruby 3.2, so they cannot use this version.
- The `pagy_prev_link` and `pagy_next_link` have been removed: they were just useless.
- Rename the `:size` variable to `slots`.
- Replace the `ends` with `compact` (with opposite boolean)

#### Simple search and replace renaming (without logic changes)

These renamings implement a consistent logic throughout the gem, aimed to avoid confusion and to improve readability and
understanding.

##### Public API

{.compact}

| Type      | Search (old)         | Replace with (new)   | Why?                                                                                               |
|-----------|----------------------|----------------------|----------------------------------------------------------------------------------------------------|
| Method    | `pagy(...)`          | `pagy(:offset, ...)` | Because it's explicit and consistent with the other paginators (however `:offset` can be omitted). |
| Function  | `Pagy.root`          | `Pagy::ROOT`         | Because we don't need to call a method just to get a constant Pathname.                            |
| Accessor  | `pagy.vars`          | `pagy.options`       | Because they are actually `options` that don't change during execution.                            |
| Accessor  | `pagy.pages`         | `pagy.last`          | Because they are just an alias that we removed for simplicity.                                     |
| Exception | `VariableError`      | `OptionError`        | Because it's consistent with the `options` argument.                                               |
| Accessor  | `e.variable`         | `e.option`           | Because it's consistent with its `OptionError` class.                                              |
| Naming    | `*prev*`             | `*previous*`         | Because we don't use abbreviated words anymore (check: option, accessor, methods, CSS).            |
| Option    | `size: 7`            | `slots: 7`           | Because it's actually the number of page slots, and avoids confusion with other `size`s.           |
| Option    | `ends: false`        | `compact: true`      | Because it's an opt-in option of the `series`, boolean inverse of `ends`.                          |
| Option    | `:page_param`        | `:page_key`          | Because `page_param` make people think "page param value". Value is a string now, not a symbol.    |
| Option    | `:limit_param`       | `:limit_key`         | Because `limit_param` make people think "limit param value". Value is a string now, not a symbol.  |
| Variable  | `@pagy_locale = ...` | `Pagy::I18n = ...`   | Because the `Pagy::I18n` API is now fully compatible with the `i18n` gem                           |
| Path      | `'javascripts'`      | `'javascript'`       | Because it is the "javascript" dir, with one single file in a few formats                          |
| Path      | `'stylesheets'`      | `'stylesheet'`       | Because it is the "stylescript" dir, with one single file in a few formats                         |

##### Internal API

You may check these if you override some internal method:

{.compact}

| Type        | Search (old)         | Replace with (new) | Why?                                                                                    |
|-------------|----------------------|--------------------|-----------------------------------------------------------------------------------------|
| Method      | `pagy_url_for(@pagy` | `@pagy.page_url(`  | Because `_url_for` suggests diversifiable results, and rails-related expectations       |
| Method      | `pagy_anchor(pagy`   | `pagy.a_lambda(`   | Because it creates a lambda, not the a tag itself, and it's a pagy instance method      |
| Method      | `pagy_t`             | `I18n.translate`   | Because we don't use abbreviated words anymore, and it's exactly like with the I18n gem |
| Method/args | `label_for`          | `page_label`       | Because `_for` suggests diversifiable results                                           |
| Method/args | `label`              | `page_label`       | Because we don't need two methods                                                       |

#### Extras Changes

All the extras are gone. Here is what to do in order to accomodate the changes:

- Remove all `require 'pagy/extras/*` statements from the `pagy.rb` initializer.

##### `array`

- Replace `pagy_array(...)` with `pagy(:offset,...)`

##### `arel`

- Replace `pagy_arel(...)` with `pagy(:offset, count_over: true, ...)`.

##### `pagy`

- All the old helpers are now `@pagy` instance methods with more explicit names.

{.compact}

| Search (old)                         | Replace with (new)               |
|--------------------------------------|----------------------------------|
| `pagy_nav(@pagy, ...)`               | `@pagy.series_nav(...)`          |
| `pagy_nav_js(@pagy, ...)`            | `@pagy.series_nav_js(...)`       |
| `pagy_combo_nav_js(@pagy, ...)`      | `@pagy.input_nav_js(...)`        |
| `pagy_info(@pagy, ...)`              | `@pagy.info_tag(...)`            |
| `pagy_limit_selector_js(@pagy, ...)` | `@pagy.limit_tag_js(...)`        |
| `pagy_prev_url(@pagy, ...)`          | `@pagy.page_url(:previous, ...)` |
| `pagy_next_url(@pagy, ...)`          | `@pagy.page_url(:next, ...)`     |
| `pagy_prev_a(@pagy, ...)`            | `@pagy.previous_tag(...)`        |
| `pagy_next_a(@pagy, ...)`            | `@pagy.next_tag(...)`            |

##### `boostrap`, `bulma`

- Replace any existing `pagy_<extra-name>_nav(@pagy, ...)` with `@pagy.series_nav(:<extra-name>, ...)`
- Replace any existing `pagy_<extra-name>_nav_js(@pagy, ...)` with `@pagy.series_nav_js(:<extra-name>, ...)`
- Replace any existing `pagy_<extra-name>_combo_nav_js(@pagy, ...)` with `@pagy.input_nav_js(:<extra-name>, ...)`

##### `countless`

- Replace `pagy_countless(...)` with `pagy(:countless, ...)`
- Rename any existing `countless_minimal: true` to `headless: true`.

##### `calendar`

- Replace `pagy_calendar(...)` with `pagy(:calendar, ...)`.
- Remove your old localization configuration (if any), then uncomment and customize the following line in the `pagy.rb`
  initializer:
  `Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)`.
  - _Note: In non-Rails applications, calendar localization requires adding `rails-i18n` to your Gemfile._
- Replace any existing `Pagy::Calendar::OutOfRangeError` with `Pagy::RangeError`.
- Rename the current `:active` flag to `:disabled`; this sets the opposite boolean value.
- Rename any existing `:pagy` configuration key to `:offset`.
- Leave all remaining elements unchanged.

##### `elasticsearch_rails`, `meilisearch`, `searchkick`

- Replace `pagy_<extra-name>(...)` with `pagy(:<extra-name>, ...)`.
- **Active and passive modes are now handled by the same `pagy` method:**
  - Replace any existing `Pagy.new_from_<extra-name>(...)` with `pagy(:<extra-name>, ...)`.
- **Customization of the `pagy_search` method name has been discontinued:**
  - Remove any existing `:<extra-name>_pagy_search` variable from your code.
  - Replace custom method names with the standard `pagy_search` method.
- Rename any existing `:<extra-name>_search` variable to `:search_method` and provide it to the `pagy` method.
- All other elements remain unchanged.

##### `headers`

- Replace any instance of `pagy_headers(...)` with `@pagy.headers_hash(...)`.
- Replace any instance of `pagy_headers_merge` with `response.headers.merge!(@pagy.headers_hash)`.
- Rename any instance of the `:headers` variable to `:headers_map` (renamed to clarify that it represents a map of the headers).
- Pass the `:headers_map` option directly to the `headers_hash` helper or to the `pagy` method, as needed.

##### `jsonapi`

- Rename any existing `pagy_jsonapi_links(@pagy, ...)` to `@pagy.links_hash(...)`.
  - _Notice that the `nil` links are now removed as the `JSON:API` specifications require._
- Enable the feature by passing the `jsonapi: true` option to the `pagy` method.

##### `keyset`

- Replace `pagy_keyset(...)` with `pagy(:keyset, ...)`.
- Replace any existing `:jsonify_keyset_attributes` with `:pre_serialize`.
  - The lambda receives the same `keyset_attributes` argument, but it must modify the specific values directly. The lambda's
    return value is ignored. For example: `->(attrs) { attrs[:created_at] = attrs[:created_at].strftime('%F %T.%6N') }`.
- Remove any existing `:filter_newest`. Override the `compose_predicate` method instead.
- Replace any existing `pagy_keyset_first_url(@pagy, ...)` with `@pagy.page_url(:first, ...)`.
- Replace any existing `pagy_keyset_next_url(@pagy, ...)` with `@pagy.page_url(:next, ...)`.

##### `limit`

- Rename the existing `:limit_param` to `:limit_key`.
- Delete the existing `:limit_extra`.
- Enable the feature by passing `client_max_limit: your_client_max_limit` option to the `pagy` method.

##### `metadata`

- Rename `pagy_metadata(@pagy, ...)` to `@pagy.data_hash(...)` (renamed to reflect its functionality and returned value).
- Rename any existing `:scaffold_url` to `url_template` (renamed to clarify that it is a template string).
- Rename any existing `:metadata` option to `:data_keys` (renamed to specify that they correspond to data-identifying keys).
- Pass the `:data_keys` option directly to the `data_hash` helper or the `pagy` method, depending on the context.

##### `overflow`

- The `Pagy::OverflowError` has been replaced by the `Pagy::RangeError`; however, it is no longer raised by default.
- Pagy rescues the `Pagy::RangeError` and serves an empty page by default.
  - Now, Pagy behaves the same as it did before when requiring the overflow extra and using its default settings.
- The legacy `pagy.overflow?` is now the `pagy.in_range?` method, which checks/returns the opposite state/boolean.
- The `overflow: :last_page` behavior has been discontinued because it provides nearly no benefit:
  - **Why there is little benefit in serving the last page**
    - The navigation bar for an out-of-range request is rendered identically to that of the last page.
    - The only difference is that there are no records/results to display.
    - The "previous page" button points to the last page, so if users truly want to see the last page results (which they have
      already seen), they can simply click the link.
- **Summary for keeping the same behavior**:
  - The `:overflow` variable is not used anymore.
  - If you did not use the extra (i.e., Pagy raised errors), set `raise_range_error: true`.
  - If you used `overflow: :empty_page` or just required the overflow extra, simply remove it (this is now the default behavior).
  - If you used `overflow: :last_page` and still want this behavior despite the reasons above:
    - Set `raise_range_error: true`.
    - Use `rescue Pagy::RangeError => e` in your method.
    - Redirect to `@pagy.page_url(:last)`.

##### `standalone`

- Replace the `:url` variable with the `:request` option hash. For example:

  ```ruby
  request: { base_url: 'http://www.example.com',
             path:     '/path',
             query:    { 'param1' => 1234 }, # The string-keyed hash query from the request 
             cookie:   'xyz' }               # The 'pagy' cookie, only for keynav  
  ```
  
##### `i18n`

- If absolutely necessary, uncomment or add this line to your initializer: `Pagy.translate_with_the_slower_i18n_gem!`.

##### `gearbox` (discontinued feature)

- Due to extensive overwriting for minimal benefit, you can safely remove this feature from your app without noticeable impact.

##### `size` (discontinued feature)

- Pagination bars similar to WillPaginate and Kaminari are not good for a lot of reasons. If still required, adapt the legacy file
  from a previous commit.

##### `trim` (discontinued feature)

- It was mostly useless and half-baked, causing numerous complications in both the Ruby and JavaScript code for no significant
  benefit.
- Use an appropriate approach to address your requirement, such as utilizing URL rewriting at the HTTP server level.

#### Direct instantiation of the pagy classes is not recommended

- The provided `pagy(:<paginator>, ...)` method ensures easier usage, maintenance, and forward compatibility.
- Use the implementing classes only if the documentation explicitly suggests you to do so, or if you know what you are doing.

#### Possibly Breaking Overridings

- Overriding methods in controllers/helpers is not possible or discouraged.
- The cleanest approach for local overriding is via Ruby refinements. For global overriding, use the `pagy.rb` initializer.
- Check the [How To Override Pagy Method](guides/how-to#override-pagy-methods)
- Additionally, internal Pagy protected methods have been extensively refactored, frequently renamed, and occasionally removed.
- Reconcile internal overrides by reviewing the updated Pagy codebase.

## Changes (TL;DR)

- **The Countless pagination remembers the last page**
  - Pagination navs now allows jumping forward after navigating back a few pages.
- **Javascript refactoring**
  - The new `Pagy.sync_javascript` function used in the `pagy.js` initializer, avoids complicated configurations.
  - Added the plain `pagy.js` and relative source map files.
- **I18n refactoring**
  - No setup required: the locales and their pluralization are autoloaded when your app uses them.
  - You can easily override the lookup of locale files with `Pagy::I18n.pathnames << my_dictionaries`.

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md)
