---
icon: versions-24
---

# CHANGELOG

## Breaking Changes

If you upgrade from version `< 6.0.0` see the following:

- [Breaking changes in version 6.0.0](#version-600)
- [Breaking changes in version 5.0.0](CHANGELOG_LEGACY.md#version-500)
- [Breaking changes in version 4.0.0](CHANGELOG_LEGACY.md#version-400)
- [Breaking changes in version 3.0.0](CHANGELOG_LEGACY.md#version-300)
- [Breaking changes in version 2.0.0](CHANGELOG_LEGACY.md#version-200)
- [Breaking changes in version 1.0.0](CHANGELOG_LEGACY.md#version-100)

## Deprecations

None

<hr>

## Version 6.0.0

### Breaking changes

Removed support for the deprecation of `5.0`:

- The `pagy_massage_params` method: use the `:params` variable set to a lambda `Proc` that does the same (but per instance). See [How to customize the params](https://ddnexus.github.io/pagy/how-to#customize-the-params).
- The `activesupport` core dependency: it will become an optional requirement if you use the calendar: add `gem 'activesuport'` to your Gemfile if your app doesn't use rails.
- The plain `Time` objects in the `:period` variable: use only `ActiveSupport::TimeWithZone` objects.
- The `:offset` variable used by the `Pagy::Calendar::Week`: set the `Date.beginning_of_week` variable to the symbol of the first day of the week (e.g. `Date.beginning_of_week = :sunday`). Notice the default is `:monday` consistently with the ISO-8601 standard (and Rails).
- The `Pagy::DEFAULT[:elasticsearch_rails_search_method]`: use `Pagy::DEFAULT[:elasticsearch_rails_pagy_search]` instead.
- The `Pagy::DEFAULT[:searchkick_search_method]`: use `Pagy::DEFAULT[:searchkick_pagy_search`] instead.
- The `Pagy::DEFAULT[:meilisearch_search_method]`: use `Pagy::DEFAULT[:meilisearch_pagy_search]` instead.

#### Suggestions for a smooth removal of deprecations from pagy 5

- Upgrade to the latest version of pagy 5 first
- Run your tests or app
- Check the log for any deprecations message starting with '[PAGY WARNING]'
- Update your code as indicated by the messages
- Ensure that the log is now free from warnings
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

[LEGACY CHANGELOG >>>](CHANGELOG_LEGACY.md) 
