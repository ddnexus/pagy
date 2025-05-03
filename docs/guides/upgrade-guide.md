---
label: Upgrade to 43+
icon: paper-airplane
order: 80
---

#

## Upgrade to 43+

---

Pagy version 43+ is a complete redesign of the legacy code. Its improvements make pagination a lot simpler and powerful, but
require a quite different way to use it.

!!! success Follow this guide to upgrade your app in just a few minutes.

Cherry-pick only what applies to your app: you can safely skip all the rest.

!!!

!!! Just the steps without distractions.

This guide focuses on getting the job done quickly. If you want to learn more about the changes:

- Consult the docs
- Ask Pagy AI specific questions
- Ask in the [Q&A discussion](https://github.com/ddnexus/pagy/discussions/categories/q-a).

!!!

### 1. Replace the `pagy.rb` config file

- Rename your `pagy.rb` initializer as `pagy-old.rb`, and add the new, concise
  [pagy.rb](../toolbox/initializer/#initializer-file) initializer in its place.
- Search the `pagy-old.rb` for code-occurrences of `Pagy::DEFAULT[...]` and move them to the new `pagy.js` (remove them from the `pagy-old.rb`)
- Replace all the `Pagy::DEFAULT[...]` entries just added to the new `pagy.rb` with `Pagy.options[...]`.

_In the next steps we will use the `pagy-old.rb` as the blueprint to guide most of the changes, and we will edit the new `pagy.rb`
as needed._

### 2. Replace your used extras

The new version doesn't use the extras anymore. They got integrated in the core code, and a few have been discontinued.

- Search any active `require 'pagy/extras/*` in the `pagy-old.rb` file
- When you find one, follow the specific section to upgrade your code.
- Remove each entry from the `pagy-old.rb` as you proceed.

<details>
  <summary><h4 style="display: inline-block">Extras...</h4></summary>

==- `array`

{.compact}

| Search (old)      | Replace with (new)  |
|-------------------|---------------------|
| `pagy_array(...)` | `pagy(:offset,...)` |

==- `arel`

{.compact}

| Search (old)     | Replace with (new)                     |
|------------------|----------------------------------------|
| `pagy_arel(...)` | `pagy(:offset, count_over: true, ...)` |

==- `pagy`

- All the old helpers are now `@pagy` instance methods with more explicit names.

{.compact}

| Search (old)                         | Replace with (new)               |
|--------------------------------------|----------------------------------|
| `pagy_nav(@pagy, ...)`               | `@pagy.series_nav(...)`          |
| `pagy_nav_js(@pagy, ...)`            | `@pagy.series_nav_js(...)`       |
| `pagy_combo_nav_js(@pagy, ...)`      | `@pagy.input_nav_js(...)`        |
| `pagy_limit_selector_js(@pagy, ...)` | `@pagy.limit_tag_js(...)`        |
| `pagy_prev_url(@pagy, ...)`          | `@pagy.page_url(:previous, ...)` |
| `pagy_next_url(@pagy, ...)`          | `@pagy.page_url(:next, ...)`     |
| `pagy_prev_a(@pagy, ...)`            | `@pagy.previous_tag(...)`        |
| `pagy_next_a(@pagy, ...)`            | `@pagy.next_tag(...)`            |
| `pagy_prev_link(@pagy, ...)`         | discontinued: implement manually |
| `pagy_next_link(@pagy, ...)`         | discontinued: implement manually |
| [*] `size: ...`                      | `slots: ...`                     |
| [*] `ends: false`                    | `compact: true`                  |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.

==- `boostrap`

- All the old helpers are now `@pagy` instance methods with more explicit names.

{.compact}

| Search (old)                             | Replace with (new)                    |
|------------------------------------------|---------------------------------------|
| `pagy_boostrap_nav(@pagy, ...)`          | `@pagy.series_nav(:boostrap, ...)`    |
| `pagy_boostrap_nav_js(@pagy, ...)`       | `@pagy.series_nav_js(:boostrap, ...)` |
| `pagy_boostrap_combo_nav_js(@pagy, ...)` | `@pagy.input_nav_js(:boostrap, ...)`  |
| [*] `size: ...`                          | `slots: ...`                          |
| [*] `ends: false`                        | `compact: true`                       |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.
- **FYI**: The redundant `pagy-bootstrap` class has been removed from the `input_nav_js` body.

==- `bulma`

- All the old helpers are now `@pagy` instance methods with more explicit names.

{.compact}

| Search (old)                          | Replace with (new)                 |
|---------------------------------------|------------------------------------|
| `pagy_bulma_nav(@pagy, ...)`          | `@pagy.series_nav(:bulma, ...)`    |
| `pagy_bulma_nav_js(@pagy, ...)`       | `@pagy.series_nav_js(:bulma, ...)` |
| `pagy_bulma_combo_nav_js(@pagy, ...)` | `@pagy.input_nav_js(:bulma, ...)`  |
| [*] `size: ...`                       | `slots: ...`                       |
| [*] `ends: false`                     | `compact: true`                    |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.
- **FYI**: The `is-centered` CSS class has been removed.
- **FYI**: The previous/next links have been moved at the beginning and end of the pagination.

==- `countless`

{.compact}

| Search (old)                  | Replace with (new)      |
|-------------------------------|-------------------------|
| `pagy_countless(...)`         | `pagy(:countless, ...)` |
| [*] `countless_minimal: true` | `headless: true`        |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.

==- `calendar`

{.compact}

| Search (old)                      | Replace with (new)     |
|-----------------------------------|------------------------|
| `pagy_calendar(...)`              | `pagy(:calendar, ...)` |
| `Pagy::Calendar::OutOfRangeError` | `Pagy::RangeError`     |
| flag: `active: true`              | `disabled: false`      |
| config: `pagy: ...`               | `offset: ...`          |

- If your `pagy-old.rb` file contains any localization configuration, then uncomment and customize the following line in the
  `pagy.rb` initializer: `Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)`.
  - _Note: In non-Rails applications, calendar localization requires adding `rails-i18n` to your Gemfile._
- Remove any existing `Pagy::Calendar::*::DEFAULT`. Pass the options to each unit when you paginate.

==- `elasticsearch_rails`

- Active and passive modes are now handled by the same `pagy` method:

{.compact}

| Search (old)                             | Replace with (new)                |
|------------------------------------------|-----------------------------------|
| `pagy_elasticsearch_rails(...)`          | `pagy(:elasticsearch_rails, ...)` |
| `Pagy.new_from_elasticsearch_rails(...)` | `pagy(:elasticsearch_rails, ...)` |
| [*] `elasticsearch_rails_search: ...`    | `search_method: ...`              |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.
- **Customization of the `pagy_search` method name has been discontinued:**
  - Remove any existing `:elasticsearch_rails_pagy_search` variable from your code.
  - Replace custom method names with the standard `pagy_search` method.

==-  `meilisearch`

- Active and passive modes are now handled by the same `pagy` method:

{.compact}

| Search (old)                     | Replace with (new)        |
|----------------------------------|---------------------------|
| `pagy_meilisearch(...)`          | `pagy(:meilisearch, ...)` |
| `Pagy.new_from_meilisearch(...)` | `pagy(:meilisearch, ...)` |
| [*] `meilisearch_search: ...`    | `search_method: ...`      |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.
- **Customization of the `pagy_search` method name has been discontinued:**
  - Remove any existing `:meilisearch_pagy_search` variable from your code.
  - Replace custom method names with the standard `pagy_search` method.

==- `searchkick`

- Active and passive modes are now handled by the same `pagy` method:

{.compact}

| Search (old)                    | Replace with (new)       |
|---------------------------------|--------------------------|
| `pagy_searchkick(...)`          | `pagy(:searchkick, ...)` |
| `Pagy.new_from_searchkick(...)` | `pagy(:searchkick, ...)` |
| [*] `searchkick_search: ...`    | `search_method: ...`     |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.
- **Customization of the `pagy_search` method name has been discontinued:**
  - Remove any existing `:searchkick_pagy_search` variable from your code.
  - Replace custom method names with the standard `pagy_search` method.

==- `headers`

{.compact}

| Search (old)         | Replace with (new)                            |
|----------------------|-----------------------------------------------|
| `pagy_headers(...)`  | `@pagy.headers_hash(...)`                     |
| `pagy_headers_merge` | `response.headers.merge!(@pagy.headers_hash)` |
| [*] `headers: ...`   | `headers_map: ...`                            |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.

==- `jsonapi`

{.compact}

| Search (old)                     | Replace with (new)     |
|----------------------------------|------------------------|
| `pagy_jsonapi_links(@pagy, ...)` | `@pagy.urls_hash(...)` |

- _Notice that the `nil` links are now removed as the `JSON:API` specifications require._
- IMPORTANT: Enable the feature by explicitly setting the `jsonapi: true` option (initializer or `pagy` method).

==- `keyset`

{.compact}

| Search (old)                        | Replace with (new)            |
|-------------------------------------|-------------------------------|
| `pagy_keyset(...)`                  | `pagy(:keyset, ...)`          |
| `pagy_keyset_first_url(@pagy, ...)` | `@pagy.page_url(:first, ...)` |
| `pagy_keyset_next_url(@pagy, ...)`  | `@pagy.page_url(:next, ...)`  |
| `filter_newest: ...`                | override `compose_predicate`  |

- Replace any existing `:jsonify_keyset_attributes` with `:pre_serialize`.
  - The lambda receives the same `keyset_attributes` argument, but it must modify the specific values directly. The lambda's
    return value is ignored. For example: `->(attrs) { attrs[:created_at] = attrs[:created_at].strftime('%F %T.%6N') }`.

==- `limit`

{.compact}

| Search (old)        | Replace with (new) |
|---------------------|--------------------|
| `limit_param: :...` | `limit_key: '...'` |
| `limit_extra: ...`  | delete             |
| `max_limit: ...`    | delete             |

- Enable the feature by setting `client_max_limit: your_client_max_limit` option (initializer or `pagy` method).

==- `metadata`

{.compact}

| Search (old)                | Replace with (new)     |
|-----------------------------|------------------------|
| `pagy_metadata(@pagy, ...)` | `@pagy.data_hash(...)` |
| [*] `metadata: ...`         | `data_keys: ...`       |
| data_key -> `:scaffold_url` | `:url_template`        |

- [*] Replace also any existent related `Pagy.options[...]` in the `pagy.rb` file.

==- `overflow`

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

==- `standalone`

- Replace the `:url` variable with the `:request` option hash. For example:

  ```ruby
  request: { base_url: 'http://www.example.com',
             path:     '/path',
             query:    { 'param1' => 1234 }, # The string-keyed hash query from the request 
             cookie:   'xyz' }               # The 'pagy' cookie, only for keynav  
  ```

==- `i18n`

- If absolutely necessary, uncomment or add this line to your initializer: `Pagy.translate_with_the_slower_i18n_gem!`.

==- `gearbox` _(discontinued)_

- Due to extensive overwriting for minimal benefit, you can safely remove this feature from your app without noticeable impact.
  Remove all `/gearbox/` related.

==- `size` _(discontinued)_

- Pagination bars similar to WillPaginate and Kaminari are not good for a lot of reasons. If still required, adapt the legacy file
  from a previous commit.

==- `trim` _(discontinued)_

- It was mostly useless and half-baked, causing many complications in both the Ruby and JavaScript code for no significant
  benefit.
- Use an appropriate approach to address your requirement, such as utilizing URL rewriting at the HTTP server level.

===
</details>

### 3. Final steps

==- Search and replace

{.compact}

| Search (old)             | Replace with (new)     |
|--------------------------|------------------------|
| `include Pagy::Backend`  | `include Pagy::Method` |
| `include Pagy::Frontend` | delete / integrated    |
| `Pagy.root.`             | `Pagy::ROOT.`          |
| `page_param: :...`       | `page_key: '...'`      |
| `pagy_info(@pagy, ...)`  | `@pagy.info_tag(...)`  |
| `@pagy_locale = ...`     | `Pagy::I18n = ...`     |
| `@pagy.pages`            | `@pagy.last`           |
| `@pagy.vars`             | `@pagy.options`        |
| `VariableError`          | `OptionError`          |
| `<error>.variable`       | `<error>.option`       |
| `count_args: ...`        | delete / integrated    |
| `anchor_string: ...`     | delete / discontinued  |
| `outset: ...`            | delete / discontinued  |
| `cycle: ...`             | delete / discontinued  |

==- Replace the `:params` variable...

- Use the `:querify` option, which is a `lambda` that can modify the string-keyed query hash at will. It is a bit more verbose,
  but it's more powerful and low-level. It solves an incompatibility with the old high-level
  `:params` hash/lambda and improves performance. It is part of the [Common URL Options](../toolbox/paginators#common-url-options)
  group that gives you full and efficient control over the URL composition.
- Example:
  ```ruby
  # Old symbol-keyed, high-level hash variable
  params: { a: 1, b: 2 } 
  # New string-keyed, low-level, direct modification of the query hash
  querify: ->(q) { q.merge!('a' => 1, 'b' => 2) } 
  # It also allows to do things like:
  querify = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
  ```

==- Replace the `*prev*` abbreviated naming

- Use `*previous*` in all the option, accessor, methods, etc.

_Because we don't use abbreviated words anymore_

===

### 4. Finalize the upgrade

==- Javascript

- If your `pagy-old.rb` contains any JavaScript setup, it sould still work, so you can move it to the `pagy.rb` file, however, consider using the new [simpler recommented way](../resources/javascript/#2-make-the-file-available-to-your-app).

==- Pagy::I18n and Locale Files

- If your `pagy-old.rb` contains the `Pagy::I18n` setup, and the setup includes some custom dictionary file,
then uncomment and set up the relevant `Pagy::I18n` lookup section in the `pagy.rb` file. _(See the [I18n docs](../resources/i18n) for details)_
- Update your custom dictionary files to the new dictionary structure, or they won't work correctly.
- Besides that, you don't need any line of the old setup, because all the locales are autoloaded when your app uses them.
- Remove all the I18n code from the `pagy-old.rb`.

==- Overriding

- Overriding methods in controllers/helpers is not possible or discouraged.
- The cleanest approach for local overriding is via Ruby refinements and the initializer for global override. 
- Check the [How To Override Pagy Method](../guides/how-to/#override-pagy-methods).
- If your `pagy-old.rb` contains overridden methods, copy the methods over to the `pagy.rb` initializer, however, consider that:
  - Internal Pagy protected methods have been extensively refactored, frequently renamed, and occasionally removed.
  - You should reconcile internal overrides by reviewing the updated Pagy codebase.

You may want also to check these internal renaming:

{.compact}

| Search (old)         | Replace with (new) |
|----------------------|--------------------|
| `pagy_url_for(@pagy` | `@pagy.page_url(`  |
| `pagy_anchor(pagy`   | `pagy.a_lambda(`   |
| `pagy_t`             | `I18n.translate`   |
| `label_for`          | `page_label`       |
| `label`              | `page_label`       |

==- Delete the `pagy-old.rb` file

- At this point, there should be no more code in the `pagy-old.rb`.

===

!!! warning

Please report any issue with this guide opening a [new docs issue](https://github.com/ddnexus/pagy/issues/new?template=Documentation.yml).

!!!
