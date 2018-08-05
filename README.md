# Pagy

[![Gem Version](https://badge.fury.io/rb/pagy.svg)](https://badge.fury.io/rb/pagy) [![Build Status](https://travis-ci.org/ddnexus/pagy.svg?branch=master)](https://travis-ci.org/ddnexus/pagy)

Pagy is the ultimate pagination gem that outperforms the others in each and every benchmark and comparison.

## Benchmarks

The best way to quickly get an idea about Pagy is comparing it to the other well known gems.

The values shown in the charts below have been recorded while each gem was producing the exact same output: same environment conditions, same task, just different gems _(see the [Detailed Gems Comparison](http://ddnexus.github.io/pagination-comparison/gems.html))_

### Faster

[![IPS Chart](docs/assets/images/ips-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#ips-benchmark)

### Less Memory

[![Memory Chart](docs/assets/images/memory-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)

### Simpler

[![Objects Chart](docs/assets/images/objects-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)

### More Efficient

[![Efficiency Table](docs/assets/images/efficiency-table.png)](https://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio)

_The [IPS/Kb ratio](http://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio) is calculated out of speed (IPS) and Memory (Kb): it shows how well each gem uses any Kb of memory it allocates/consumes._

## Features

### Straightforward Code

- Pagy is just ~100 lines of simple ruby, organized in 3 flat modules very easy to understand and use _(see [more...](https://ddnexus.github.io/pagy/api))_
- No dependencies: it produces its own HTML, URLs, pluralization and interpolation with its own specialized and fast code _(see [why...](https://ddnexus.github.io/pagy/index#specialized-code-instead-of-generic-helpers))_
- 100% of its methods are public API, accessible and overridable **right where you use them** (no need of monkey-patching)
- 100% test coverage for core code and extras

### Totally Agnostic

- It doesn't need to know anything about your models, ORM or storage, so it doesn't add any code to them _(see [why...](https://ddnexus.github.io/pagy/index#stay-away-from-the-models))_
- It works with all kinds of collections, even pre-paginated, records, Arrays, JSON data... and just whatever you can count _(see [how...](https://ddnexus.github.io/pagy/how-to#paginate-any-collection))_
- It works with all Rack frameworks (Rails, Sinatra, Padrino, ecc.) out of the box _(see [more...](https://ddnexus.github.io/pagy/how-to#environment-assumptions))_
- It works with any possible non-Rack environment by just overriding one or two two-lines methods _(see [more...](https://ddnexus.github.io/pagy/how-to#environment-assumptions))_

### Unlike the other gems

- It works with collections/scopes that already used `limit` and `offset` _(see [how...](https://ddnexus.github.io/pagy/how-to#paginate-a-pre-offsetted-and-pre-limited-collection))_
- It works with helpers or templates _(see [more...](https://ddnexus.github.io/pagy/how-to#using-templates))_
- It raises real `Pagy::OutOfRangeError` exceptions that you can rescue from _(see [how...](https://ddnexus.github.io/pagy/how-to#handling-pagyoutofrangeerror-exception))_ or use the [out_of_range extra](http://ddnexus.github.io/pagy/extras/out_of_range) for a few ready to use common behaviors
- It does not impose any difficult-to-override logic or output _(see [why...](https://ddnexus.github.io/pagy/index#really-easy-to-customize))_

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

### Component Extras

- [compact](http://ddnexus.github.io/pagy/extras/compact): An alternative UI that combines the pagination feature with the navigation info in one compact element: ![pagy-compact](docs/assets/images/pagy-compact-w.png)
- [responsive](http://ddnexus.github.io/pagy/extras/responsive): On resize, the number of page links adapts in real-time to the available window or container width: ![pagy-responsive](docs/assets/images/pagy-responsive-w.png)

### Backend Extras

- [array](http://ddnexus.github.io/pagy/extras/array): Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
- [searchkick](http://ddnexus.github.io/pagy/extras/searchkick): Paginate `Searchkick::Results` objects efficiently, avoiding expensive oject-wrapping and without overriding

### Frontend Extras

- [bootstrap](http://ddnexus.github.io/pagy/extras/bootstrap): Nav helpers and templates for Bootstrap pagination
- [bulma](http://ddnexus.github.io/pagy/extras/bulma): Nav helpers and templates for Bulma CSS pagination
- [materialize](http://ddnexus.github.io/pagy/extras/materialize): Nav helpers for Materialize CSS pagination

### Feature Extras

- [I18n](http://ddnexus.github.io/pagy/extras/i18n): Use the `I18n` gem instead of the pagy implementation
- [items](http://ddnexus.github.io/pagy/extras/items): Allow the client to request a custom number of items per page with a ready to use selector UI
- [out_of_range](http://ddnexus.github.io/pagy/extras/out_of_range): Allow for easy handling of out of range pages
- [trim](http://ddnexus.github.io/pagy/extras/trim): Remove the `page=1` param from the first page link

## Chat Support and Feedback

[Chat on Gitter](https://gitter.im/ruby-pagy/Lobby)

## Useful Links

### Docs

- [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start)
- [Documentation](https://ddnexus.github.io/pagy/index)
- [Migrating from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/migration-tips)
- [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md)
- [Detailed Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html)
- [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison)

### Posts and Tutorials

- [Pagination with Pagy](https://www.imaginarycloud.com/blog/paginating-ruby-on-rails-apps-with-pagy) by Tiago Franco
- [Stateful Tabs Pagination](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy) by Chris Seelus
- [Quick guide for Sinatra and Sequel](https://medium.com/@vfreefly/how-to-use-pagy-with-sequel-and-sinatra-157dfec1c417) by Victor Afanasev

## Please Star and Share!

Pagy is young and needs to be known, and **you** can really help, even with just a click on the star, or sharing a tweet with friends and collegues. A big thank you for your help!

## Help Wanted

Pagy is a fresh project and your help would be great. If you like it, you have a few options to contribute:

- Create an issue if anything should be improved/fixed
- Submit a pull request to improve Pagy
- Write a Tutorial or a "How To" topic
- Submit some cool extra

## Branches and Pull Requests

`master` is the latest rubygem-published release (plus changes that don't affect the actual gem behavior, e.g. doc, tests). You should use it as the base branch for pull requests, because it will not be force-rebased.

`dev` is the development branch that is kept rebased on top of `master`, so expect it to be force-rebased (i.e. do not use it as the base for your commits). Use `dev` as a preview for trying the new code that will be merged in the next release, but please, don't use it as the base branch for pull requests.

## Credits

Many thansk to:

- [Imaginary Cloud](https://www.imaginarycloud.com), for continually publishing high-interest articles and helping share Pagy through their fantastic blog
- [JetBrains](http://www.jetbrains.com) for their free OpenSource license
- [The Contributors](https://github.com/ddnexus/pagy/graphs/contributors) for all the smart code and suggestions merged in the project
- [The Stargazers](https://github.com/ddnexus/pagy/stargazers) for showing their support

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
