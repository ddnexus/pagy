# Pagy

[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=pagy&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/pagy)
![ruby](https://img.shields.io/badge/ruby-v1.9+-ruby.svg?colorA=99004d&colorB=cc0066)
![jruby](https://img.shields.io/badge/jruby-v1.7+-jruby.svg?colorA=99004d&colorB=cc0066)
[![Build Status](https://img.shields.io/travis/ddnexus/pagy/master.svg?colorA=1f7a1f&colorB=2aa22a)](https://travis-ci.org/ddnexus/pagy/branches)
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)
![Commits](https://img.shields.io/github/commit-activity/y/ddnexus/pagy.svg?label=commits&colorA=004d99&colorB=0073e6)
![Downloads](https://img.shields.io/gem/dt/pagy.svg?colorA=004d99&colorB=0073e6)
[![Chat](http://img.shields.io/badge/gitter-ruby--pagy-purple.svg?colorA=800080&colorB=b300b3)](https://gitter.im/ruby-pagy/Lobby)

Pagy is the ultimate pagination gem that outperforms the others in each and every benchmark and comparison.

## Improvements in v2.0+

- Lower ruby requirements (ruby v1.9+ || jruby v1.7+) make Pagy very convenient also on older systems
- The i18n internal implementation now includes full dynamic support for multi-language apps, it's ~18x faster and uses ~10x less memory than the i18n gem
- The `searchkick` and `elasticsearch_rails` extras have been refactored with more and better options
- Pagy v2.0+ is even faster and lighter than v1.0+ (see charts below)

## Comparison with other gems

The best way to quickly get an idea about Pagy is comparing it to the other well known gems.

The values shown in the charts below have been recorded while each gem was producing the exact same output in the exact same environment. _(see the [Detailed Gems Comparison](http://ddnexus.github.io/pagination-comparison/gems.html))_

### ~ 33x Faster!

[![IPS Chart](docs/assets/images/ips-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#ips-benchmark)

### ~ 26x Lighter!

[![Memory Chart](docs/assets/images/memory-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)

### ~ 25x Simpler!

[![Objects Chart](docs/assets/images/objects-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)

### ~ 850x More Efficient!

[![Resource Consumption Chart](docs/assets/images/resource-consumption-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio)

_Each dot in the chart represents the resources that Pagy consumes for one full rendering. The other gems consume hundreds of times as much for the same rendering._

_The [IPS/Kb ratio](http://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio) is calculated out of speed (IPS) and Memory (Kb): it shows how well each gem uses each Kb of memory it allocates/consumes._

#### Disclaimer

Please, notice that benchmarking and profiling the pagination gems in a working app environment may be a quite a tricky task.

If you compare Pagy in your own app and don't notice much of a difference, your benchmarks are most likely not isolating the pagination code from the rest of your app.

Please check the [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison) for a working example about how to properly compare the gems. Feel free to ask [here](https://gitter.im/ruby-pagy/Lobby) if you need help.

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

- Pagy is very modular and does not load nor execute unnecessary code in your app _(see [why...](https://ddnexus.github.io/pagy/how-to#global-configuration))_
- It works even with collections/scopes that already used `limit` and `offset` _(see [how...](https://ddnexus.github.io/pagy/how-to#paginate-a-pre-offsetted-and-pre-limited-collection))_
- It works with helpers or templates _(see [more...](https://ddnexus.github.io/pagy/how-to#using-templates))_
- It raises real `Pagy::OverflowError` exceptions that you can rescue from _(see [how...](https://ddnexus.github.io/pagy/how-to#handling-pagyoutofrangeerror-exception))_ or use the [overflow extra](http://ddnexus.github.io/pagy/extras/overflow) for a few ready to use common behaviors
- It does not impose any difficult-to-override logic or output _(see [why...](https://ddnexus.github.io/pagy/index#really-easy-to-customize))_
- It also works on legacy systems starting from ruby v1.9+ and jruby v1.7+

### Easy to use

You can use Pagy in a quite familiar way:

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
<%== render 'pagy/nav', locals: {pagy: @pagy} %>
```

_(see [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start) for more details)_

## Easy to extend

Use the official extras, or write your own in just a few lines. Extras add special options and manage different components, behaviors, Frontend or Backend environments... usually by just requiring them:

### Backend Extras

- [array](http://ddnexus.github.io/pagy/extras/array): Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
- [countless](http://ddnexus.github.io/pagy/extras/countless): Paginate without the need of any count, saving one query per rendering
- [elasticsearch_rails](http://ddnexus.github.io/pagy/extras/elasticsearch_rails): Paginate `ElasticsearchRails` response objects
- [searchkick](http://ddnexus.github.io/pagy/extras/searchkick): Paginate `Searchkick::Results` objects

### Frontend Extras

- [bootstrap](http://ddnexus.github.io/pagy/extras/bootstrap): Add nav, responsive and compact helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination)
- [bulma](http://ddnexus.github.io/pagy/extras/bulma): Add nav, responsive and compact helpers for the Bulma CSS [pagination component](https://bulma.io/documentation/components/pagination)
- [foundation](http://ddnexus.github.io/pagy/extras/foundation): Add nav, responsive and compact helpers for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html)
- [materialize](http://ddnexus.github.io/pagy/extras/materialize): Add nav responsive and compact helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html)
- [plain](http://ddnexus.github.io/pagy/extras/plain): Add responsive and compact plain/unstyled helpers
- [semantic](http://ddnexus.github.io/pagy/extras/semantic): Add nav, responsive and compact helpers for the Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html)

### Feature Extras

- [headers](http://ddnexus.github.io/pagy/extras/headers): Add [RFC-8288](https://tools.ietf.org/html/rfc8288) compilant http response headers (and other helpers) useful for API pagination
- [i18n](http://ddnexus.github.io/pagy/extras/i18n): Use the `I18n` gem instead of the pagy implementation
- [items](http://ddnexus.github.io/pagy/extras/items): Allow the client to request a custom number of items per page with an optional selector UI
- [overflow](http://ddnexus.github.io/pagy/extras/overflow): Allow for easy handling of overflowing pages
- [support](http://ddnexus.github.io/pagy/extras/support): Extra support for features like: incremental, infinite, auto-scroll pagination
- [trim](http://ddnexus.github.io/pagy/extras/trim): Remove the `page=1` param from the first page link

### Alternative Components

Besides the classic pagination `nav`, Pagy offers a few ready to use alternatives like:

- [compact nav](http://ddnexus.github.io/pagy/extras/plain#compact-navs): An alternative UI that combines the pagination feature with the navigation info in one compact element:<br>![pagy-compact](docs/assets/images/pagy-compact-w.png)

- [responsive nav](http://ddnexus.github.io/pagy/extras/plain#responsive-navs): On resize, the number of page links adapts in real-time to the available window or container width:<br>![pagy-responsive](docs/assets/images/pagy-responsive-w.png)

## Resources

### GoRails Screencast

[![Objects Chart](docs/assets/images/gorails-thumbnail-w360.png)](https://gorails.com/episodes/pagination-with-pagy-gem?autoplay=1)

**Notice**: the `pagy_nav_bootstrap` helper used in the screencast has been renamed to `pagy_bootstrap_nav` in version 2.0

### Posts and Tutorials

- [Migrating from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/migration-tips) (practical guide)
- [Pagination with Pagy](https://www.imaginarycloud.com/blog/paginating-ruby-on-rails-apps-with-pagy) by Tiago Franco
- [Stateful Tabs with Pagy](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy) by Chris Seelus
- [Quick guide for Pagy with Sinatra and Sequel](https://medium.com/@vfreefly/how-to-use-pagy-with-sequel-and-sinatra-157dfec1c417) by Victor Afanasev
- [Integrating Pagy with Hanami](http://katafrakt.me/2018/06/01/integrating-pagy-with-hanami/) by Paweł Świątkowski
- [Detailed Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html) (charts and analysis)
- [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison) (Rails app repository)

### Docs

- [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start)
- [Documentation](https://ddnexus.github.io/pagy/index)
- [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md)

### Support and Feedback

[Chat on Gitter](https://gitter.im/ruby-pagy/Lobby)


## Please Star and Share!

Pagy is young and needs to be known, and **you** can really help, even with just a click on the star, or sharing a tweet with friends and colleagues. A big thank you for your support!

## Help Wanted

Pagy is a fresh project and your help would be great. If you like it, you have a few options to contribute:

- Create an issue if anything should be improved/fixed
- Submit a pull request to improve Pagy
- Submit some cool extra
- Submit your translation if your language is missing from the [dictionary files](https://github.com/ddnexus/pagy/blob/master/lib/locales)
- Write a Tutorial or a "How To" topic

## Repository Info

### Versioning

Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/). Please, check the [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md) for breaking changes introduced by mayor versions.

### Branching

Pagy follows the [GitFlow](https://datasift.github.io/gitflow/IntroducingGitFlow.html) branching model with `master` and `dev`.

The `master` branch is the latest rubygem-published release.

The `dev` branch is the development branch with the new code that will be merged in the next release.

Expect any other branch to be experimental, force-rebased and/or deleted even without merging.

## Credits

Many thanks to:

- [Imaginary Cloud](https://www.imaginarycloud.com), for continually publishing high-interest articles and helping share Pagy through their fantastic blog
- [JetBrains](http://www.jetbrains.com) for their free OpenSource license
- [The Contributors](https://github.com/ddnexus/pagy/graphs/contributors) for all the smart code and suggestions merged in the project
- [The Stargazers](https://github.com/ddnexus/pagy/stargazers) for showing their support

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
