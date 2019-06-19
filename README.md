# Pagy

[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=pagy&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/pagy)
![ruby](https://img.shields.io/badge/ruby-1.9+-ruby.svg?colorA=99004d&colorB=cc0066)
![jruby](https://img.shields.io/badge/jruby-1.7+-jruby.svg?colorA=99004d&colorB=cc0066)
[![CodeCov](https://img.shields.io/codecov/c/github/ddnexus/pagy.svg?colorA=1f7a1f&colorB=2aa22a)](https://codecov.io/gh/ddnexus/pagy)
[![Build Status](https://img.shields.io/travis/ddnexus/pagy/master.svg?colorA=1f7a1f&colorB=2aa22a)](https://travis-ci.org/ddnexus/pagy/branches)
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)
![Commits](https://img.shields.io/github/commit-activity/y/ddnexus/pagy.svg?label=commits&colorA=004d99&colorB=0073e6)
![Downloads](https://img.shields.io/gem/dt/pagy.svg?colorA=004d99&colorB=0073e6)
[![Chat](http://img.shields.io/badge/gitter-ruby--pagy-purple.svg?colorA=800080&colorB=b300b3)](https://gitter.im/ruby-pagy/Lobby)

Pagy is the ultimate pagination gem that outperforms the others in each and every benchmark and comparison.

## New in 3.0+

- Pagy 3.0+ is considerably faster, lighter and more efficient than 2.0+ on modern environments (see the charts below)
- The javascript nav helpers have been refactored for improved performance and more intuitive API
- The i18n has been refactored, the dictionary files are simpler and 100% compliant with the i18n gem
- Added [Maximizing Performance](https://ddnexus.github.io/pagy/how-to#maximizing-performance) docs as a practical guide to choose the best options for your requirements and environment

**Notice**: Updating from 2.0+ to 3.0+ requires just some search and replace and a little reorganization of your custom i18n dictionaries. Check the [CHANGELOG](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md) for details.

**Suggestion**: If you are using any `pagy*_nav` helper, [consider to switch](https://ddnexus.github.io/pagy/how-to#consider-the-nav_js) to `pagy*_nav_js`, which gives you the same output with a substancial performance boost.

## Comparison with other gems

The best way to quickly get an idea about Pagy is comparing it to the other well known gems.

The values shown in the charts below have been recorded while each gem was producing the exact same output in the exact same environment. _(see the [Detailed Gems Comparison](http://ddnexus.github.io/pagination-comparison/gems.html))_

### ~ 40x Faster!

[![IPS Chart](docs/assets/images/ips-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#ips-benchmark)

### ~ 36x Lighter!

[![Memory Chart](docs/assets/images/memory-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)

### ~ 35x Simpler!

[![Objects Chart](docs/assets/images/objects-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)

### ~ 1,410x More Efficient!

[![Resource Consumption Chart](docs/assets/images/resource-consumption-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio)

_Each dot in the visualization above represents the resources that Pagy consumes for one full rendering. The other gems consume hundreds of times as much for the same rendering._

_The [IPS/Kb ratio](http://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio) is calculated out of speed (IPS) and Memory (Kb): it shows how well each gem uses each Kb of memory it allocates/consumes._

## Features

### Straightforward Code

- Pagy has a very slim core code of just ~100 lines of simple ruby, organized in 3 flat modules, very easy to understand and use _(see [more...](https://ddnexus.github.io/pagy/api))_
- It has a quite fat set of optional extras that you can explicitly require for very efficient and modular customization _(see [extras](https://ddnexus.github.io/pagy/extras))_
- It has no dependencies: it produces its own HTML, URLs, i18n with its own specialized and fast code _(see [why...](https://ddnexus.github.io/pagy/index#specialized-code-instead-of-generic-helpers))_
- 100% of its methods are public API, accessible and overridable **right where you use them** (no pesky monkey-patching needed)
- 100% test coverage for core code and extras

### Totally Agnostic

- The `Pagy` class doesn't need to know anything about your models, ORM or storage, so it doesn't add any code to them _(see [why...](https://ddnexus.github.io/pagy/index#stay-away-from-the-models))_
- It works with all kinds of collections, even pre-paginated, records, Arrays, JSON data... and just any list, even if you cannot count it _(see [how...](https://ddnexus.github.io/pagy/how-to#paginate-any-collection))_
- Pagy works with the most popular Rack frameworks (Rails, Sinatra, Padrino, ecc.) out of the box _(see [more...](https://ddnexus.github.io/pagy/how-to#environment-assumptions))_
- It works also with any possible non-Rack environment by just overriding one or two two-lines methods _(see [more...](https://ddnexus.github.io/pagy/how-to#environment-assumptions))_

### Unlike the other gems

- Pagy is very modular and does not load any unnecessary code in your app _(see [why...](https://ddnexus.github.io/pagy/how-to#global-configuration))_
- It works even with collections/scopes that already used `limit` and `offset` _(see [how...](https://ddnexus.github.io/pagy/how-to#paginate-a-pre-offsetted-and-pre-limited-collection))_
- It works with fast helpers OR easy to edit templates _(see [more...](https://ddnexus.github.io/pagy/how-to#using-templates))_
- It raises real `Pagy::OverflowError` exceptions that you can rescue from _(see [how...](https://ddnexus.github.io/pagy/how-to#handling-pagyoutofrangeerror-exception))_ or use the [overflow extra](http://ddnexus.github.io/pagy/extras/overflow) for a few ready to use common behaviors
- It does not impose any difficult-to-override logic or output _(see [why...](https://ddnexus.github.io/pagy/index#really-easy-to-customize))_
- It also works on legacy systems starting from ruby 1.9+ and jruby 1.7+

### Easy to use

After installing and including Pagy _(see [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start))_, you can use it in a quite familiar way:

Paginate your collection in some controller:

```ruby
@pagy, @records = pagy(Product.some_scope)
```

Render the navigation links with a super-fast helper in some view:

```erb
<%== pagy_nav(@pagy) %>
```

Or - if you prefer - render the navigation links with a template:

```erb
<%== render partial: 'pagy/nav', locals: {pagy: @pagy} %>
```

## Easy to customize

Use the official extras, or write your own in just a few lines. Extras add special options and manage different components, behaviors, Frontend or Backend environments... usually by just requiring them:

### Backend Extras

- [array](http://ddnexus.github.io/pagy/extras/array): Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
- [countless](http://ddnexus.github.io/pagy/extras/countless): Paginate without the need of any count, saving one query per rendering
- [elasticsearch_rails](http://ddnexus.github.io/pagy/extras/elasticsearch_rails): Paginate `ElasticsearchRails` response objects
- [searchkick](http://ddnexus.github.io/pagy/extras/searchkick): Paginate `Searchkick::Results` objects

### Frontend Extras

- [bootstrap](http://ddnexus.github.io/pagy/extras/bootstrap): Add nav, nav_js and combo_nav_js helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination)
- [bulma](http://ddnexus.github.io/pagy/extras/bulma): Add nav, nav_js and combo_nav_js helpers for the Bulma CSS [pagination component](https://bulma.io/documentation/components/pagination)
- [uikit](http://ddnexus.github.io/pagy/extras/uikit): Add nav helper for the UIkit [pagination component](https://getuikit.com/docs/pagination)
- [foundation](http://ddnexus.github.io/pagy/extras/foundation): Add nav, nav_js and combo_nav_js helpers for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html)
- [materialize](http://ddnexus.github.io/pagy/extras/materialize): Add nav, nav_js and combo_nav_js helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html)
- [navs](http://ddnexus.github.io/pagy/extras/navs): Add nav_js and combo_nav_js unstyled helpers
- [semantic](http://ddnexus.github.io/pagy/extras/semantic): Add nav, nav_js and combo_nav_js helpers for the Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html)

### Feature Extras

- [headers](http://ddnexus.github.io/pagy/extras/headers): Add RFC-8288 compliant http response headers (and other helpers) useful for API pagination
- [i18n](http://ddnexus.github.io/pagy/extras/i18n): Use the `I18n` gem instead of the pagy-i18n implementation
- [items](http://ddnexus.github.io/pagy/extras/items): Allow the client to request a custom number of items per page with an optional selector UI
- [overflow](http://ddnexus.github.io/pagy/extras/overflow): Allow for easy handling of overflowing pages
- [support](http://ddnexus.github.io/pagy/extras/support): Extra support for features like: incremental, auto-incremental and infinite pagination
- [trim](http://ddnexus.github.io/pagy/extras/trim): Remove the `page=1` param from the first page link

### Alternative Components

Besides the classic pagination offered by the `pagy_nav` helpers, you can use a couple of more performant alternatives:

- [pagy_nav_js](http://ddnexus.github.io/pagy/extras/navs#javascript-navs): A faster and lighter classic looking UI, rendered on the client side with optional responsiveness:<br>![bootstrap_nav_js](docs/assets/images/bootstrap_nav_js-w.png)

- [pagy_combo_nav_js](http://ddnexus.github.io/pagy/extras/navs#javascript-combo-navs): The fastest and lightest alternative UI _(48x faster, 48x lighter and 2,270x more efficient than Kaminari)_ that combines navigation and pagination info in a single compact element:<br>![bootstrap_combo_nav_js](docs/assets/images/bootstrap_combo_nav_js-w.png)

## Resources

### GoRails Screencast

[![Objects Chart](docs/assets/images/gorails-thumbnail-w360.png)](https://gorails.com/episodes/pagination-with-pagy-gem?autoplay=1)

**Notice**: the `pagy_nav_bootstrap` helper used in the screencast has been renamed as `pagy_bootstrap_nav` since version 2.0

### Posts and Tutorials

- [Migrating from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/migration-guide) (practical guide)
- [Pagination with Pagy](https://www.imaginarycloud.com/blog/paginating-ruby-on-rails-apps-with-pagy) by Tiago Franco
- [Stateful Tabs with Pagy](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy) by Chris Seelus
- [Quick guide for Pagy with Sinatra and Sequel](https://medium.com/@vfreefly/how-to-use-pagy-with-sequel-and-sinatra-157dfec1c417) by Victor Afanasev
- [Pagy with Templates Minipost](https://www.aloucaslabs.com/miniposts/how-to-install-pagy-gem-with-a-custom-pagination-template-on-a-ruby-on-rails-application) by aloucas
- [Integrating Pagy with Hanami](http://katafrakt.me/2018/06/01/integrating-pagy-with-hanami/) by Paweł Świątkowski
- [Detailed Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html) (charts and analysis)
- [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison) (Rails app repository)
- [日本語の投稿](https://qiita.com/search?q=pagy)

### Docs

- [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start)
- [Documentation](https://ddnexus.github.io/pagy/index)
- [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md)

### Support and Feedback

[Chat on Gitter](https://gitter.im/ruby-pagy/Lobby)

## Repository Info

### Versioning

Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/). Please, check the [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md) for breaking changes introduced by mayor versions.

### Branches

The `master` branch is the latest rubygem-published release. It also contains docs and comment changes that don't affect the published code.

The `dev` branch is the development branch with the new code that will be merged in the next release.

Expect any other branch to be experimental, force-rebased and/or deleted even without merging.

## Credits

Many thanks to:

- [GoRails](https://gorails.com) for the great [Pagy Screencast](https://gorails.com/episodes/pagination-with-pagy-gem?autoplay=1) and their top notch [Rails Episodes](https://gorails.com/episodes)
- [Imaginary Cloud](https://www.imaginarycloud.com) for continually publishing high-interest articles and helping to share Pagy when it just started
- [JetBrains](http://www.jetbrains.com) for their free OpenSource license
- [The Contributors](https://github.com/ddnexus/pagy/graphs/contributors) for all the smart code and suggestions merged in the project
- [The Stargazers](https://github.com/ddnexus/pagy/stargazers) for showing their support

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
