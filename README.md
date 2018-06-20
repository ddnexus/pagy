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
- It raises real `Pagy::OutOfRangeError` exceptions that you can rescue from _(see [how...](https://ddnexus.github.io/pagy/how-to#handling-pagyoutofrangeerror-exception))_
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

_(see [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start))_

## Easy to extend

Use the official extras, or write your own in just a few lines.

### Array Extra

Paginate arrays efficiently avoiding expensive array-wrapping and without any overriding. _(see [more...](http://ddnexus.github.io/pagy/extras/array))_

### Bootstrap Extra

Nav helper and templates for Bootstrap pagination. _(see [more...](http://ddnexus.github.io/pagy/extras/bootstrap))_

### Compact Extra

An alternative UI that combines the pagination feature with the navigation info in one compact element. _(see [more...](http://ddnexus.github.io/pagy/extras/compact))_

![pagy-compact](docs/assets/images/pagy-compact-w.png)

### Items Extra

Allow the client to request a custom number of items per page with a ready to use selector UI. _(see [more...](http://ddnexus.github.io/pagy/extras/items))_

### Responsive Extra

On resize, the number of page links will adapt in real-time to the available window or container width. _(see [more...](http://ddnexus.github.io/pagy/extras/responsive))_

![pagy-responsive](docs/assets/images/pagy-responsive-w.png)

## Chat Support and Feedback

[Chat on Gitter](https://gitter.im/ruby-pagy/Lobby)

## Useful Links

- [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start)
- [Documentation](https://ddnexus.github.io/pagy/index)
- [Migrating from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/migration-tips)
- [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md)
- [Contributors](https://github.com/ddnexus/pagy/graphs/contributors)
---
- [Detailed Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html)
- [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison)

## Please Star and Share!

Pagy is young and needs to be known, and **you** can really help, even with just a click on the star, or sharing a tweet with friends and collegues. Thank you!

## Help Wanted

Pagy is a fresh project and your help would be great. If you like it, you have a few options to contribute:

- Create an issue if anything should be improved/fixed
- Submit a pull request to improve Pagy
- Write a Tutorial or a "How To" topic
- Submit some cool extra

## Branches and Pull Requests

`master` is the latest rubygem-published release (plus changes that don't affect the actual gem behavior, e.g. doc, tests). You should use it as the base branch for pull requests, because it will not be force-rebased.

`dev` is the development branch that is kept rebased on top of `master`, so expect it to be force-rebased (i.e. do not use it as the base for your commits). Use `dev` as a preview for trying the new code that will be merged in the next release, but please, don't use it as the base branch for pull requests.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
