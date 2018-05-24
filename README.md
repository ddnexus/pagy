# Pagy

[![Gem Version](https://badge.fury.io/rb/pagy.svg)](https://badge.fury.io/rb/pagy)

Pagy is the ultimate pagination gem that outperforms the others in each and every benchmark and comparison.

### Benchmarks

The best way to quickly get an idea about its features is comparing it to the other well known gems.

The values shown in the charts below have been recorded while each gem was producing the exact same output: same environment conditions, same task, just different gems _(see the complete [Gems Comparison](http://ddnexus.github.io/pagination-comparison/gems.html))_

#### Pagy is a lot faster

![IPS Chart](docs/assets/images/ips-chart.png)

#### Pagy uses a lot less memory

![Memory Chart](docs/assets/images/memory-chart.png)

#### Pagy is a lot simpler

![Objects Chart](docs/assets/images/objects-chart.png)

#### Pagy is a lot more efficient

![Efficiency Table](docs/assets/images/efficiency-table.png)

_The [IPS/Kb ratio](http://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio) is calculated out of speed (IPS) and Memory (Kb): it shows how well each gem uses any Kb of memory it allocates/consumes._

#### Pagy does not suffer the typical limitations of the other gems

- it works with collections/scopes that already used `limit` and `offset`
- it works with both helpers or templates (your choice)
- it raises real `Pagy::OutOfRangeError` exceptions that you can rescue from
- it does not impose any difficult-to-override logic or output

## Features

### Straightforward code

- Pagy is just ~100 lines of simple ruby, organized in 3 flat modules very easy to understand and use
- it produces its own HTML, URLs, pluralization and interpolation with its own specialized and fast code
- 100% of its methods are public API, accessible and overridable **right where you use them** (no need of monkey patching or subclassing)

### Totally agnostic

- it doesn't need to know anything about your models, ORM or Storage, so it doesn't add any code to them
- it works with all kinds of collections, even pre-paginated, records, Arrays, JSON data... and just whatever you can count
- it works with all Rack frameworks (Rails, Sinatra, Padrino, ecc.) out of the box
- it works with any possible non-Rack envoronment by just overriding one or two one-liner methods

### Easy to use

You can use pagy in a quite familiar way:

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

### Easy to extend

Use the official extras contained in the [pagy-extras](https://github.com/ddnexus/pagy-extras) gem, or write your own in just a few lines:

#### Bootstrap Extra

This extra adds a nav helper and a few templates compatible with the Bootstrap pagination ([more info...](http://ddnexus.github.io/pagy/pagy-extras/bootstrap)).

#### Responsive Extra

This extra adds responsiveness to the pagination UI. The number of page links will adapt in real-time to the available window or container width. Here is an example of how the same pagination nav will look like by resizing the browser window:

![pagy-responsive](docs/assets/images/pagy-responsive-w.png)

([more info...](http://ddnexus.github.io/pagy/pagy-extras/responsive))

#### Compact Extra

This extra adds an alternative pagination UI that joins the pagination feature with the navigation info in one compact element. It is especially useful for small size screens.

![pagy-compact](docs/assets/images/pagy-compact-w.png)

([more info...](http://ddnexus.github.io/pagy/pagy-extras/compact))

## Support, Comments and Feature Requests

[![Join the chat at https://gitter.im/ruby-pagy/Lobby](https://badges.gitter.im/ruby-pagy/Lobby.svg)](https://gitter.im/ruby-pagy/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Useful Links

- [Documentation](https://ddnexus.github.io/pagy/index)
- [Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html)
- [Pagination Comparison App Repository](http://github.com/ddnexus/pagination-comparison)

## Help Wanted

Pagy is a fresh project and your help would be great. If you like it, you have a few options to contribute:

- write a tutorial or a post or even just a tweet (pagy is young and needs to be known)
- write a "How To" topic (the documentation is covering the basics and there is a lot of space for additions)
- submit some cool extra
- submit a pull request to make pagy even faster, save more memory or improve its usability
- create an issue if anything should be improved/fixed

## Branches and Pull Requests

`master` is the latest rubygem-published release: you should use it as the base branch for pull requests, because it will not be force-rebased. `dev` is the development branch that will receive your pull requests, and that get merged into `master` before a new release. Expect `dev` to be force-rebased, so it's probably wise not to use it as the base for your commits.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
