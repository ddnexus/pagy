# Pagy

<span>[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=pagy&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/pagy)</span> <span>
[![ruby](https://img.shields.io/badge/ruby-EOL-ruby.svg?colorA=99004d&colorB=cc0066)](https://endoflife.date/ruby)</span> <span>
[![Build Status](https://img.shields.io/github/actions/workflow/status/ddnexus/pagy/pagy-ci.yml?branch=master)](https://github.com/ddnexus/pagy/actions/workflows/pagy-ci.yml?query=branch%3Amaster)</span> <span>
![Coverage](https://img.shields.io/badge/coverage-100%25-coverage.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)</span> <span>
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/4329/badge)](https://bestpractices.coreinfrastructure.org/projects/4329)</span> <span>
![Commits](https://img.shields.io/github/commit-activity/y/ddnexus/pagy.svg?label=commits&colorA=004d99&colorB=0073e6)</span> <span>
![Downloads](https://img.shields.io/gem/dt/pagy.svg?colorA=004d99&colorB=0073e6)</span> <span>
[![Stars](https://shields.io/github/stars/ddnexus/pagy?style=social)](https://github.com/ddnexus/pagy/stargazers)</span>

## 🏆 The Best Pagination Ruby Gem 🥇

---

### ✴ What's new in 7.0+ ✴

- [JSON:API support](https://ddnexus.github.io/pagy/docs/extras/jsonapi/)
- [ARIA compliance](https://ddnexus.github.io/pagy/docs/api/aria/) and refactoring of dictionary files
- Added a simpler and faster nav without gaps (just pass an integer to the `:size`)
- Pagy follows the [ruby end-of-life](https://endoflife.date/ruby) supported rubies now (3.1+)
- See the [Changelog](https://ddnexus.github.io/pagy/changelog) for possible breaking changes

---

### 🚀 🚀 🚀 🚀 🚀

[<img src="docs/assets/images/ips-chart.png" title="~40x Faster!">](https://ddnexus.github.io/pagination-comparison/gems.html#ips-benchmark) [<img src="docs/assets/images/memory-chart.png" title="~36x Lighter!">](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile) [<img src="docs/assets/images/objects-chart.png" title="~35x Simpler!">](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile) [<img src="docs/assets/images/resource-consumption-chart.png" title="1,410x More Efficient!">](https://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio)

<details>

_Each dot in the visualization above represents the resources that Pagy consumes for one full rendering. The other gems consume
hundreds of times as much for the same rendering._

_The [IPS/Kb ratio](http://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio) is calculated out of speed (IPS)
and Memory (Kb): it shows how well each gem uses each Kb of memory it allocates/consumes._

Notice: the above charts refers to the comparison of the basic `pagy v3.0.0` helper with `will_paginate v3.1.7`
and `kaminari v1.1.1`.

While it's not up-to-date, you can expect roughly similar results with the latest versions, maybe a bit less dramatic in
performance due to the multiple features added to pagy since v3 (e.g. customizable and translated aria-labels). However, consider
that the difference become A LOT bigger in favor of pagy if you use `*nav_js` helpers, `Pagy::Countless` or JSON and client side
pagination that the other gems don't offer and are not part of the comparison.

See the [Detailed Gems Comparison](http://ddnexus.github.io/pagination-comparison/gems.html) for full details.

</details>

<br>

## 🤩 It does it all. Better.

- **It works in any environment**  
  With Rack frameworks (Rails, Sinatra, Padrino, etc.) or in pure ruby without Rack
- **It works with any collection**  
  With any ORM, any DB, any search
  gem, [elasticsearch_rails](https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails), [meilisearch](https://ddnexus.github.io/pagy/docs/extras/meilisearch), [searchkick](https://ddnexus.github.io/pagy/docs/extras/searchkick), `ransack`,
  and just about any list, even if you cannot count it
- **It supports all kinds of pagination**  
  [calendar](https://ddnexus.github.io/pagy/docs/extras/calendar "paginates by dates, rather than numbers"), [countless](https://ddnexus.github.io/pagy/docs/extras/countless "skips an extra 'count' query"), [geared](https://ddnexus.github.io/pagy/docs/extras/gearbox "varies the items fetched depending on the page number e.g. page 1: x items, but page 2: y items etc."), [incremental, auto-incremental, infinite](https://ddnexus.github.io/pagy/docs/extras/pagy), [headers](https://ddnexus.github.io/pagy/docs/extras/headers "useful for API pagination"), [JSON](https://ddnexus.github.io/pagy/docs/extras/metadata "provides pagination metadata - especially useful with frameworks like Vue, React etc. and you want to render your own pagination links"), [cursor](https://github.com/Uysim/pagy-cursor "Useful with large data sets, where performance becomes a concern (separate repository)")
- **It supports all kinds of CSS Frameworks**  
  [bootstrap](https://ddnexus.github.io/pagy/docs/extras/bootstrap), [bulma](https://ddnexus.github.io/pagy/docs/extras/bulma), [foundation](https://ddnexus.github.io/pagy/docs/extras/foundation), [materialize](https://ddnexus.github.io/pagy/docs/extras/materialize), [semantic](https://ddnexus.github.io/pagy/docs/extras/semantic), [uikit](https://ddnexus.github.io/pagy/docs/extras/uikit), [tailwind](https://ddnexus.github.io/pagy/docs/extras/tailwind)
- **It supports faster client-side rendering**  
  With classic or innovative UI components (see [Javascript Components](https://ddnexus.github.io/pagy/docs/api/javascript/)) or
  by
  serving [JSON](https://ddnexus.github.io/pagy/docs/extras/metadata) to your favorite Javascript framework
- **It has 100% of test coverage** for Ruby, HTML and Javascript E2E (
  see [Pagy Workflows CI](https://github.com/ddnexus/pagy/actions))

<details>

### Code Structure

- **Pagy has a very slim core code** very easy to understand and use.
- **It has a quite fat set of optional extras** that you can explicitly require for very efficient and modular customization _(
  see [extras](https://ddnexus.github.io/pagy/categories/extra/))_
- **It has no dependencies**: it produces its own HTML, URLs, i18n with its own specialized and fast code
- **Its methods are accessible and overridable** right where you use them (no pesky monkey-patching needed)

### Unlike the other gems

- Pagy is very modular and does not load any unnecessary code (
  see [why...](https://ddnexus.github.io/pagy/quick-start#configure))_
- It doesn't impose limits even with collections|scopes that already used `limit` and `offset` _(
  see [how...](https://ddnexus.github.io/pagy/docs/how-to/#paginate-pre-offset-and-pre-limited-collections))_
- It raises `Pagy::OverflowError` exceptions that you can rescue from _(
  see [how...](https://ddnexus.github.io/pagy/docs/how-to/#handle-pagyoverflowerror-exceptions))_ or use
  the [overflow extra](https://ddnexus.github.io/pagy/docs/extras/overflow) for a few ready to use common behaviors
- It does not impose any difficult-to-override logic or output

</details>

<br>

## 😎 It's easy to use and customize

<details open>

<summary>Code for basic pagination...</summary>

```rb
# Include it in the controllers (e.g. application_controller.rb)
include Pagy::Backend

# Include it in the helpers (e.g. application_helper.rb)
include Pagy::Frontend

# Wrap your collections with pagy in your actions
@pagy, @records = pagy(Product.all)
```

Optionally set your defaults in the pagy initializer:

```rb
# Optionally override some pagy default with your own in the pagy initializer
Pagy::DEFAULT[:items] = 10 # items per page
Pagy::DEFAULT[:size]  = [1, 4, 4, 1] # nav bar links
# Better user experience handled automatically
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page
```

```erb
<%# Render a view helper in your views (skipping nav links for empty pages) %>
<%== pagy_nav(@pagy) if @pagy.pages > 1 %>
```

Or, choose from the following view helpers:

| View Helper Name                                                                                                                                                                                                                          | Preview (Bootstrap Style shown)                                        |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|
| [`pagy_nav(@pagy)`](https://ddnexus.github.io/pagy/docs/api/frontend)                                                                                                                                                                     | ![`pagy_nav`](/docs/assets/images/bootstrap_nav.png)                   |
| [`pagy_nav_js(@pagy)`](https://ddnexus.github.io/pagy/docs/api/javascript/)                                                                                                                                                               | ![`pagy_nav_js`](/docs/assets/images/bootstrap_nav_js.png)             |
| [`pagy_info(@pagy)`](https://ddnexus.github.io/pagy/docs/api/frontend)                                                                                                                                                                    | ![`pagy_info`](/docs/assets/images/pagy_info.png)                      |
| [`pagy_combo_nav_js(@pagy)`](https://ddnexus.github.io/pagy/docs/api/javascript/)                                                                                                                                                         | ![`pagy_combo_nav_js`](/docs/assets/images/bootstrap_combo_nav_js.png) |
| [`pagy_items_selector_js`](https://ddnexus.github.io/pagy/docs/api/javascript/)                                                                                                                                                           | ![`pagy_items_selector_js`](/docs/assets/images/items_selector_js.png) |
| [`pagy_nav(@calendar[:year])`](https://ddnexus.github.io/pagy/docs/extras/calendar/)<br/>[`pagy_nav(@calendar[:month])`](https://ddnexus.github.io/pagy/docs/extras/calendar/)<br/> (other units: `:quarter`, `:week`, `:day` and custom) | ![calendar extra](/docs/assets/images/calendar-app.png)                |

_(See the [Quick Start](https://ddnexus.github.io/pagy/quick-start))_

</details>

<details>

<summary>Customization for CSS frameworks...</summary>

```rb
# Require a CSS framework extra in the pagy initializer (e.g. bootstrap)
require 'pagy/extras/bootstrap'
```

```erb
<%# Use it in your views %>
<%== pagy_bootstrap_nav(@pagy) %>
```

_(See all the [CSS Framework Extras](https://ddnexus.github.io/pagy/categories/frontend/))_

</details>

<details>

<summary>Customization for special collections...</summary>

```rb
# Require some special backend extra in the pagy initializer (e.g. elasticsearch_rails)
require 'pagy/extras/elasticsearch_rails'

# Extend your models (e.g. application_record.rb)
extend Pagy::ElasticsearchRails

# Use it in your actions
response         = Article.pagy_search(params[:q])
@pagy, @response = pagy_elasticsearch_rails(response)
```

_(See all the [Search Extras](https://ddnexus.github.io/pagy/categories/search/))_

</details>

<details>

<summary>Customization for client-side|JSON rendering...</summary>

```ruby
# Require the metadata extra in the pagy initializer
require 'pagy/extras/metadata'

# Use it in your actions
pagy, records = pagy(Product.all)
render json: { data: records,
               pagy: pagy_metadata(pagy) }
```

_(See all the [Backend Tools](https://ddnexus.github.io/pagy/categories/backend/))_

</details>

<details>

<summary>Customization for headers pagination for APIs...</summary>

```ruby
# Require the headers extra in the pagy initializer
require 'pagy/extras/headers'

# Use it in your actions
pagy, records = pagy(Product.all)
pagy_headers_merge(pagy)
render json: records
```

_(See all the [Backend Tools](https://ddnexus.github.io/pagy/categories/backend/))_

</details>

<details>

<summary>Customization for JSON:API pagination...</summary>

```ruby
# Require the jsonapi extra in the pagy initializer
require 'pagy/extras/jsonapi'

# Use it in your actions
pagy, records = pagy(Product.all)
render json: { data:  records,
               links: pagy_jsonapi_links(pagy) }
# besides the query params will be nested. E.g.: ?page[number]=2&page[size]=100
```

_(See all the [Backend Tools](https://ddnexus.github.io/pagy/categories/backend/))_

</details>

<details>

<summary>More customization with extras...</summary><br>

Extras add special options and manage different components, behaviors, Frontend or Backend environments... usually by just
requiring them (and optionally overriding some default).

### Backend Extras

- [arel](https://ddnexus.github.io/pagy/docs/extras/arel): Provides better performance of grouped ActiveRecord collections
- [array](https://ddnexus.github.io/pagy/docs/extras/array): Paginate arrays efficiently.
- [calendar](https://ddnexus.github.io/pagy/docs/extras/calendar): Add pagination filtering by calendar time unit (year, quarter,
  month, week, day, custom)
- [countless](https://ddnexus.github.io/pagy/docs/extras/countless): Paginate without the need of any count, saving one query per
  rendering
- [elasticsearch_rails](https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails): Paginate `ElasticsearchRails` response
  objects
- [headers](https://ddnexus.github.io/pagy/docs/extras/headers): Add RFC-8288 compliant http response headers (and other helpers)
  useful for API pagination
- [jsonapi](https://ddnexus.github.io/pagy/docs/extras/jsonapi): Implement the [JSON:API](https://jsonapi.org) specifications for
  pagination
- [meilisearch](https://ddnexus.github.io/pagy/docs/extras/meilisearch): Paginate `Meilisearch` results
- [metadata](https://ddnexus.github.io/pagy/docs/extras/metadata): Provides the pagination metadata to Javascript frameworks like
  Vue.js, react.js, etc.
- [searchkick](https://ddnexus.github.io/pagy/docs/extras/searchkick): Paginate `Searchkick::Results` objects

### Frontend Extras

- [bootstrap](https://ddnexus.github.io/pagy/docs/extras/bootstrap): Add nav helpers for the
  Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination)
- [bulma](https://ddnexus.github.io/pagy/docs/extras/bulma): Add nav helpers for the Bulma
  CSS [pagination component](https://bulma.io/documentation/components/pagination)
- [foundation](https://ddnexus.github.io/pagy/docs/extras/foundation): Add nav helpers for the
  Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html)
- [materialize](https://ddnexus.github.io/pagy/docs/extras/materialize): Add nav helpers for the Materialize
  CSS [pagination component](https://materializecss.com/pagination.html)
- [pagy](https://ddnexus.github.io/pagy/docs/extras/pagy): Adds the pagy styled versions of the javascript-powered nav helpers and
  other components to support countless or navless pagination (incremental,
  auto-incremental, infinite pagination).
- [semantic](https://ddnexus.github.io/pagy/docs/extras/semantic): Add nav helpers for the Semantic UI
  CSS [pagination component](https://semantic-ui.com/collections/menu.html)
- [tailwind](https://ddnexus.github.io/pagy/docs/extras/tailwind): Ready to use style snippet
  for [Tailwind CSS](https://tailwindcss.com)
- [uikit](https://ddnexus.github.io/pagy/docs/extras/uikit): Add nav helpers for the
  UIkit [pagination component](https://getuikit.com/docs/pagination)

### Extra Features and Tools

- [Pagy::Console](https://ddnexus.github.io/pagy/docs/api/console/): Use pagy in the irb/rails console even without any app nor
  configuration
- [gearbox](https://ddnexus.github.io/pagy/docs/extras/gearbox/): Automatically change the number of items per page depending on
  the page number
- [i18n](https://ddnexus.github.io/pagy/docs/extras/i18n): Use the `I18n` gem instead of the faster pagy-i18n implementation
- [items](https://ddnexus.github.io/pagy/docs/extras/items): Allow the client to request a custom number of items per page with an
  optional selector UI
- [overflow](https://ddnexus.github.io/pagy/docs/extras/overflow): Allow easy handling of overflowing pages
- [standalone](https://ddnexus.github.io/pagy/docs/extras/standalone): Use pagy without any request object, nor Rack
  environment/gem, nor any defined `params` method
- [trim](https://ddnexus.github.io/pagy/docs/extras/trim): Remove the `page=1` param from the first page link

</details>

See also the [How To Page](https://ddnexus.github.io/pagy/docs/how-to)

## 🤓 It's well documented and supported

### Documentation

- [Migrate from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/docs/migration-guide) (practical guide)
- [Quick Start](https://ddnexus.github.io/pagy/quick-start)
- [Documentation](https://ddnexus.github.io/pagy)
- [How To (quick recipes)](https://ddnexus.github.io/pagy/docs/how-to/)
- [Changelog](https://ddnexus.github.io/pagy/changelog)
- [Deprecations](https://ddnexus.github.io/pagy/changelog#deprecations)
- [How Pagy's Docs work?](https://github.com/ddnexus/pagy/blob/master/docs/README.md)

### Support

- [Discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a)
- [Issues](https://github.com/ddnexus/pagy/issues)

### Posts and tutorials

- [Migrate from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/docs/migration-guide) (practical guide)
- [Detailed Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html) (charts and analysis)
- [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison) (Rails app repository)
- [Faster Pagination with Pagy](https://viblo.asia/p/faster-pagination-with-pagy-Eb85ok9W52G) introductory tutorial by Sirajus
  Salekin
- [Pagination with Pagy](https://www.imaginarycloud.com/blog/paginating-ruby-on-rails-apps-with-pagy) by Tiago Franco
- [Quick guide for Pagy with Sinatra and Sequel](https://medium.com/@vfreefly/how-to-use-pagy-with-sequel-and-sinatra-157dfec1c417)
  by Victor Afanasev
- [Integrating Pagy with Hanami](http://katafrakt.me/2018/06/01/integrating-pagy-with-hanami/) by Paweł Świątkowski
- [Stateful Tabs with Pagy](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy) by Chris Seelus
- [Endless Scroll / Infinite Loading with Turbo Streams & Stimulus](https://www.stefanwienert.de/blog/2021/04/17/endless-scroll-with-turbo-streams/)
  by Stefan Wienert.
- [Build Load More Pagination with Pagy and Rails Hotwire](https://dev.to/maful/build-load-more-pagination-with-pagy-and-rails-hotwire-2ndb) [by Maful](https://dev.to/maful). (
  This tutorial shows how you can turbo_stream with GET requests).
- [Pagination with Hotwire](https://www.beflagrant.com/blog/pagination-with-hotwire) by Jonathan Greenberg
- [Pagination and infinite scrolling with Rails and the Hotwire stack](https://www.colby.so/posts/pagination-and-infinite-scrolling-with-hotwire)
  by David Colby
- [Building a dynamic data grid with search and filters using rails, hotwire and ransack](https://bhserna.com/building-data-grid-with-search-rails-hotwire-ransack.html)
  by Benito Serna.
- [Pagination for Beginners: What is it? Why bother?](https://benkoshy.github.io/2021/11/03/pagination-basics.html) by Ben Koshy.
- [Handling Pagination When POSTing Complex Search Forms](https://benkoshy.github.io/2019/10/09/paginating-search-results-with-a-post-request.html)
  by Ben Koshy.
- [How to Override pagy methods only in specific circumstances](https://benkoshy.github.io/2020/02/01/overriding-pagy-methods.html)
  by Ben Koshy.
- [How to make your pagination links sticky + bounce at the bottom of your page](https://benkoshy.github.io/2020/09/15/sticky-menu.html)
  by Ben Koshy.
- [日本語の投稿](https://qiita.com/search?q=pagy)
- [한국어 튜토리얼](https://kbs4674.tistory.com/72)

### Screencasts

[<img src="https://img.youtube.com/vi/1tsWL4EjhMo/0.jpg" width="150" title="15 min - Beginner friendly - Shows installation and use of some pagy extras">](https://www.youtube.com/watch?v=1tsWL4EjhMo) [<img src="https://img.youtube.com/vi/ScxUqW29F7E/0.jpg" width="150" title="18 min - Intermediate Skill Level - 'Load More' pagination using Turbo Streams">](https://www.youtube.com/watch?v=ScxUqW29F7E) [<img src="https://img.youtube.com/vi/A9q6YwhLCyI/0.jpg" title="17 min - Intermediate Skill Level - Pagination with Search (Ransack) and Hotwire + Infinite (Countless) Pagination" width="150">](https://www.youtube.com/watch?v=A9q6YwhLCyI) [<img src="https://img.youtube.com/vi/Qoq6HZ8gdDE/0.jpg" title="12:52 min - Intermediate Skill Level - API based pagination + using pagy_metadata" width="150">](https://www.youtube.com/watch?v=Qoq6HZ8gdDE) [<img src="https://img.youtube.com/vi/EDyZIB8FU-g/0.jpg" title="12:52 min - Intermediate Skill Level - Calendar sarch with Pagy" width="150">](https://www.youtube.com/watch?v=EDyZIB8FU-g) [<img src="https://img.youtube.com/vi/K4fob588tfM/0.jpg" width="150" title="11 min - Beginner - How to Install + 'Hello world' example">](https://www.youtube.com/watch?v=K4fob588tfM) [<img src="https://img.youtube.com/vi/1sNpvTMrxl4/0.jpg" width="150" title="31 min - Beginner - Basic Pagy Use (Tailwind, Overflow, Common Use cases) + Deep dive into building a sample Blogging Application">](https://www.youtube.com/watch?v=1sNpvTMrxl4) [<img src="https://img.youtube.com/vi/0RtYhDIKmBY/0.jpg" width="150" title="5:44 min - Beginner - How to Install Pagy + Using Tailwind CSS to create a page of 'listing'">](https://www.youtube.com/watch?v=0RtYhDIKmBY) [<img src="https://img.youtube.com/vi/aILtxj_LVuA/0.jpg" width="150" title="7:23 min - Beginner - Installing Pagy + Working through errors (step-by-step)">](https://www.youtube.com/watch?v=aILtxj_LVuA) [<img src="https://img.youtube.com/vi/ArBUAxEA6vM/0.jpg" width="150" title="30:00 min - Advanced - Using Pagy In the Context of a Chat Room (Infinite Scroll, Hotwire, Stimulus JS + Using Pagy APIs)">](https://www.youtube.com/watch?v=ArBUAxEA6vM) [<img src="https://img.youtube.com/vi/4nrmf5KfD8Y/0.jpg" width="150" title="14:28 min - Intermediate - Infinite Scrolling with Turbo Streams (Rails 7)">](https://www.youtube.com/watch?v=4nrmf5KfD8Y) [<img src="https://img.youtube.com/vi/HURqvNJF4T0/0.jpg" width="150" title="5:21 min - Intermediate - Using Pagy - with a strong focus on Hotwire and filtering search results">](https://www.youtube.com/watch?v=HURqvNJF4T0) [<img src="https://img.youtube.com/vi/_j3gtKf5rRs/0.jpg" width="150" title="10:45 - Spanish Language">](https://www.youtube.com/watch?v=_j3gtKf5rRs) [<img src="https://img.youtube.com/vi/zni3nMA5_AY/0.jpg" width="150" title="10:53 - Urdu Language">](https://www.youtube.com/watch?v=zni3nMA5_AY)

<br>

## Top 💯 Contributors

<!-- top100 start -->
[<img src="https://avatars.githubusercontent.com/u/100721?v=4" width="60" title="@ddnexus: 1391 contributions">](https://github.com/ddnexus)[<img src="https://avatars.githubusercontent.com/u/15097447?v=4" width="60" title="@benkoshy: 71 contributions">](https://github.com/benkoshy)[<img src="https://avatars.githubusercontent.com/in/29110?v=4" width="60" title="@dependabot[bot]: 36 contributions">](https://github.com/dependabot[bot])[<img src="https://avatars.githubusercontent.com/u/11367?v=4" width="60" title="@grosser: 9 contributions">](https://github.com/grosser)[<img src="https://avatars.githubusercontent.com/u/9843321?v=4" width="60" title="@workgena: 4 contributions">](https://github.com/workgena)[<img src="https://avatars.githubusercontent.com/u/22333?v=4" width="60" title="@bquorning: 3 contributions">](https://github.com/bquorning)[<img src="https://avatars.githubusercontent.com/u/235048?v=4" width="60" title="@molfar: 3 contributions">](https://github.com/molfar)[<img src="https://avatars.githubusercontent.com/u/132?v=4" width="60" title="@sunny: 3 contributions">](https://github.com/sunny)[<img src="https://avatars.githubusercontent.com/u/26239269?v=4" width="60" title="@enzinia: 3 contributions">](https://github.com/enzinia)[<img src="https://avatars.githubusercontent.com/u/32258?v=4" width="60" title="@espen: 3 contributions">](https://github.com/espen)[<img src="https://avatars.githubusercontent.com/u/14981592?v=4" width="60" title="@Earlopain: 3 contributions">](https://github.com/Earlopain)[<img src="https://avatars.githubusercontent.com/u/2749593?v=4" width="60" title="@berniechiu: 2 contributions">](https://github.com/berniechiu)[<img src="https://avatars.githubusercontent.com/u/7076736?v=4" width="60" title="@renshuki: 2 contributions">](https://github.com/renshuki)[<img src="https://avatars.githubusercontent.com/u/112558900?v=4" width="60" title="@wimdavies: 2 contributions">](https://github.com/wimdavies)[<img src="https://avatars.githubusercontent.com/u/500826?v=4" width="60" title="@tiagotex: 2 contributions">](https://github.com/tiagotex)[<img src="https://avatars.githubusercontent.com/u/37790?v=4" width="60" title="@gamafranco: 2 contributions">](https://github.com/gamafranco)[<img src="https://avatars.githubusercontent.com/u/1100176?v=4" width="60" title="@thomasklemm: 2 contributions">](https://github.com/thomasklemm)[<img src="https://avatars.githubusercontent.com/u/195636?v=4" width="60" title="@tersor: 2 contributions">](https://github.com/tersor)[<img src="https://avatars.githubusercontent.com/u/8125726?v=4" width="60" title="@simonneutert: 2 contributions">](https://github.com/simonneutert)[<img src="https://avatars.githubusercontent.com/u/101501?v=4" width="60" title="@rainerborene: 2 contributions">](https://github.com/rainerborene)[<img src="https://avatars.githubusercontent.com/u/421488?v=4" width="60" title="@petergoldstein: 2 contributions">](https://github.com/petergoldstein)[<img src="https://avatars.githubusercontent.com/u/50970645?v=4" width="60" title="@sabljak: 2 contributions">](https://github.com/sabljak)[<img src="https://avatars.githubusercontent.com/u/3188392?v=4" width="60" title="@cseelus: 2 contributions">](https://github.com/cseelus)[<img src="https://avatars.githubusercontent.com/u/12479464?v=4" width="60" title="@ashmaroli: 2 contributions">](https://github.com/ashmaroli)[<img src="https://avatars.githubusercontent.com/u/3427854?v=4" width="60" title="@747: 2 contributions">](https://github.com/747)[<img src="https://avatars.githubusercontent.com/u/43544760?v=4" width="60" title="@WilliamHorel: 1 contribution">](https://github.com/WilliamHorel)[<img src="https://avatars.githubusercontent.com/u/1012014?v=4" width="60" title="@okuramasafumi: 1 contribution">](https://github.com/okuramasafumi)[<img src="https://avatars.githubusercontent.com/u/211?v=4" width="60" title="@olleolleolle: 1 contribution">](https://github.com/olleolleolle)[<img src="https://avatars.githubusercontent.com/u/2815199?v=4" width="60" title="@pedrocarmona: 1 contribution">](https://github.com/pedrocarmona)[<img src="https://avatars.githubusercontent.com/u/32079912?v=4" width="60" title="@rafaeelaudibert: 1 contribution">](https://github.com/rafaeelaudibert)[<img src="https://avatars.githubusercontent.com/u/7660738?v=4" width="60" title="@rafaelmontas: 1 contribution">](https://github.com/rafaelmontas)[<img src="https://avatars.githubusercontent.com/u/4824537?v=4" width="60" title="@yenshirak: 1 contribution">](https://github.com/yenshirak)[<img src="https://avatars.githubusercontent.com/u/1478773?v=4" width="60" title="@Tolchi: 1 contribution">](https://github.com/Tolchi)[<img src="https://avatars.githubusercontent.com/u/310909?v=4" width="60" title="@serghost: 1 contribution">](https://github.com/serghost)[<img src="https://avatars.githubusercontent.com/u/6059188?v=4" width="60" title="@sliminas: 1 contribution">](https://github.com/sliminas)[<img src="https://avatars.githubusercontent.com/u/9060346?v=4" width="60" title="@artplan1: 1 contribution">](https://github.com/artplan1)[<img src="https://avatars.githubusercontent.com/u/23448075?v=4" width="60" title="@woller: 1 contribution">](https://github.com/woller)[<img src="https://avatars.githubusercontent.com/u/30351533?v=4" width="60" title="@sk8higher: 1 contribution">](https://github.com/sk8higher)[<img src="https://avatars.githubusercontent.com/u/58137134?v=4" width="60" title="@muhammadnawzad: 1 contribution">](https://github.com/muhammadnawzad)[<img src="https://avatars.githubusercontent.com/u/69295?v=4" width="60" title="@ronald: 1 contribution">](https://github.com/ronald)[<img src="https://avatars.githubusercontent.com/u/10906059?v=4" width="60" title="@achmiral: 1 contribution">](https://github.com/achmiral)[<img src="https://avatars.githubusercontent.com/u/1393996?v=4" width="60" title="@mauro-ni: 1 contribution">](https://github.com/mauro-ni)[<img src="https://avatars.githubusercontent.com/u/462701?v=4" width="60" title="@borama: 1 contribution">](https://github.com/borama)[<img src="https://avatars.githubusercontent.com/u/24856?v=4" width="60" title="@creativetags: 1 contribution">](https://github.com/creativetags)[<img src="https://avatars.githubusercontent.com/u/24826?v=4" width="60" title="@mcary: 1 contribution">](https://github.com/mcary)[<img src="https://avatars.githubusercontent.com/u/93276?v=4" width="60" title="@marckohlbrugge: 1 contribution">](https://github.com/marckohlbrugge)[<img src="https://avatars.githubusercontent.com/u/18153165?v=4" width="60" title="@tr4b4nt: 1 contribution">](https://github.com/tr4b4nt)[<img src="https://avatars.githubusercontent.com/u/4953187?v=4" width="60" title="@tiejianluo: 1 contribution">](https://github.com/tiejianluo)[<img src="https://avatars.githubusercontent.com/u/28652?v=4" width="60" title="@szTheory: 1 contribution">](https://github.com/szTheory)[<img src="https://avatars.githubusercontent.com/u/22420?v=4" width="60" title="@smoothdvd: 1 contribution">](https://github.com/smoothdvd)[<img src="https://avatars.githubusercontent.com/u/87665329?v=4" width="60" title="@rhodes-david: 1 contribution">](https://github.com/rhodes-david)[<img src="https://avatars.githubusercontent.com/u/5484758?v=4" width="60" title="@radinreth: 1 contribution">](https://github.com/radinreth)[<img src="https://avatars.githubusercontent.com/u/884634?v=4" width="60" title="@okliv: 1 contribution">](https://github.com/okliv)[<img src="https://avatars.githubusercontent.com/u/5013677?v=4" width="60" title="@nedimdz: 1 contribution">](https://github.com/nedimdz)[<img src="https://avatars.githubusercontent.com/u/468744?v=4" width="60" title="@msdundar: 1 contribution">](https://github.com/msdundar)[<img src="https://avatars.githubusercontent.com/u/59817964?v=4" width="60" title="@m-abdurrehman: 1 contribution">](https://github.com/m-abdurrehman)[<img src="https://avatars.githubusercontent.com/u/831536?v=4" width="60" title="@dwieringa: 1 contribution">](https://github.com/dwieringa)[<img src="https://avatars.githubusercontent.com/u/29891001?v=4" width="60" title="@jyuvaraj03: 1 contribution">](https://github.com/jyuvaraj03)[<img src="https://avatars.githubusercontent.com/u/6220668?v=4" width="60" title="@YutoYasunaga: 1 contribution">](https://github.com/YutoYasunaga)[<img src="https://avatars.githubusercontent.com/u/65494027?v=4" width="60" title="@iamyujinwon: 1 contribution">](https://github.com/iamyujinwon)[<img src="https://avatars.githubusercontent.com/u/13119624?v=4" width="60" title="@yhk1038: 1 contribution">](https://github.com/yhk1038)[<img src="https://avatars.githubusercontent.com/u/6612882?v=4" width="60" title="@ya-s-u: 1 contribution">](https://github.com/ya-s-u)[<img src="https://avatars.githubusercontent.com/u/13472945?v=4" width="60" title="@yshmarov: 1 contribution">](https://github.com/yshmarov)[<img src="https://avatars.githubusercontent.com/u/190269?v=4" width="60" title="@thattimc: 1 contribution">](https://github.com/thattimc)[<img src="https://avatars.githubusercontent.com/u/7021119?v=4" width="60" title="@thomaschauffour: 1 contribution">](https://github.com/thomaschauffour)[<img src="https://avatars.githubusercontent.com/u/361323?v=4" width="60" title="@snkashis: 1 contribution">](https://github.com/snkashis)[<img src="https://avatars.githubusercontent.com/u/1753398?v=4" width="60" title="@fluser: 1 contribution">](https://github.com/fluser)[<img src="https://avatars.githubusercontent.com/u/149513?v=4" width="60" title="@tulak: 1 contribution">](https://github.com/tulak)[<img src="https://avatars.githubusercontent.com/u/6208777?v=4" width="60" title="@Federico-G: 1 contribution">](https://github.com/Federico-G)[<img src="https://avatars.githubusercontent.com/u/18742365?v=4" width="60" title="@egimenos: 1 contribution">](https://github.com/egimenos)[<img src="https://avatars.githubusercontent.com/u/73437?v=4" width="60" title="@elliotlarson: 1 contribution">](https://github.com/elliotlarson)[<img src="https://avatars.githubusercontent.com/u/17459154?v=4" width="60" title="@hungdiep97: 1 contribution">](https://github.com/hungdiep97)[<img src="https://avatars.githubusercontent.com/u/17091381?v=4" width="60" title="@djpremier: 1 contribution">](https://github.com/djpremier)[<img src="https://avatars.githubusercontent.com/u/6763624?v=4" width="60" title="@davidwessman: 1 contribution">](https://github.com/davidwessman)[<img src="https://avatars.githubusercontent.com/u/813150?v=4" width="60" title="@david-a-wheeler: 1 contribution">](https://github.com/david-a-wheeler)[<img src="https://avatars.githubusercontent.com/u/83706?v=4" width="60" title="@MrMoins: 1 contribution">](https://github.com/MrMoins)[<img src="https://avatars.githubusercontent.com/u/67093?v=4" width="60" title="@excid3: 1 contribution">](https://github.com/excid3)[<img src="https://avatars.githubusercontent.com/u/5347394?v=4" width="60" title="@cellvinchung: 1 contribution">](https://github.com/cellvinchung)[<img src="https://avatars.githubusercontent.com/u/4116980?v=4" width="60" title="@brunoocasali: 1 contribution">](https://github.com/brunoocasali)[<img src="https://avatars.githubusercontent.com/u/19940878?v=4" width="60" title="@BrandonKlotz: 1 contribution">](https://github.com/BrandonKlotz)[<img src="https://avatars.githubusercontent.com/u/3390330?v=4" width="60" title="@Atul9: 1 contribution">](https://github.com/Atul9)[<img src="https://avatars.githubusercontent.com/u/1328587?v=4" width="60" title="@amenon: 1 contribution">](https://github.com/amenon)[<img src="https://avatars.githubusercontent.com/u/482867?v=4" width="60" title="@artinboghosian: 1 contribution">](https://github.com/artinboghosian)[<img src="https://avatars.githubusercontent.com/u/58791514?v=4" width="60" title="@antonzaharia: 1 contribution">](https://github.com/antonzaharia)[<img src="https://avatars.githubusercontent.com/u/1060?v=4" width="60" title="@andrew: 1 contribution">](https://github.com/andrew)[<img src="https://avatars.githubusercontent.com/u/7662492?v=4" width="60" title="@AliOsm: 1 contribution">](https://github.com/AliOsm)[<img src="https://avatars.githubusercontent.com/u/147130?v=4" width="60" title="@AbelToy: 1 contribution">](https://github.com/AbelToy)[<img src="https://avatars.githubusercontent.com/u/6563823?v=4" width="60" title="@maful: 1 contribution">](https://github.com/maful)[<img src="https://avatars.githubusercontent.com/u/1453563?v=4" width="60" title="@loed-idzinga: 1 contribution">](https://github.com/loed-idzinga)[<img src="https://avatars.githubusercontent.com/u/283251?v=4" width="60" title="@epeirce: 1 contribution">](https://github.com/epeirce)[<img src="https://avatars.githubusercontent.com/u/3071529?v=4" width="60" title="@kobusjoubert: 1 contribution">](https://github.com/kobusjoubert)[<img src="https://avatars.githubusercontent.com/u/2381771?v=4" width="60" title="@KevinColemanInc: 1 contribution">](https://github.com/KevinColemanInc)[<img src="https://avatars.githubusercontent.com/u/7414827?v=4" width="60" title="@neontuna: 1 contribution">](https://github.com/neontuna)[<img src="https://avatars.githubusercontent.com/u/6528?v=4" width="60" title="@xuanxu: 1 contribution">](https://github.com/xuanxu)[<img src="https://avatars.githubusercontent.com/u/24403129?v=4" width="60" title="@jpgarritano: 1 contribution">](https://github.com/jpgarritano)[<img src="https://avatars.githubusercontent.com/u/588846?v=4" width="60" title="@archonic: 1 contribution">](https://github.com/archonic)[<img src="https://avatars.githubusercontent.com/u/752766?v=4" width="60" title="@jonasMirendo: 1 contribution">](https://github.com/jonasMirendo)[<img src="https://avatars.githubusercontent.com/u/437470?v=4" width="60" title="@lostapathy: 1 contribution">](https://github.com/lostapathy)[<img src="https://avatars.githubusercontent.com/u/2506436?v=4" width="60" title="@jivko-chobanov: 1 contribution">](https://github.com/jivko-chobanov)[<img src="https://avatars.githubusercontent.com/u/2069021?v=4" width="60" title="@whithajess: 1 contribution">](https://github.com/whithajess)
<!-- top100 end -->

<br/>

## 👏 Credits

Many thanks to:

- [Ben Koshy](https://github.com/benkoshy) for his contributions to the documentation, user support and interaction with external
  frameworks
- [GoRails](https://gorails.com) for the great [Pagy Screencast](https://gorails.com/episodes/pagination-with-pagy-gem?autoplay=1)
  and their top notch [Rails Episodes](https://gorails.com/episodes)
- [Imaginary Cloud](https://www.imaginarycloud.com) for continually publishing high-interest articles and helping to share Pagy
  when it just started
- [JetBrains](http://www.jetbrains.com?from=https%3A%2F%2Fgithub.com%2Fddnexus%2Fpagy) for their free OpenSource license
  project
- [The Stargazers](https://github.com/ddnexus/pagy/stargazers) for showing their support

## 📦 Repository Info

<details>

<summary>How to contribute</summary>

- Pull Requests are welcome!
- Please base your PR against the master branch.
- For simple contribution you can quickly check your changes with one of the apps in
  the [Pagy Playground](https://ddnexus.github.io/pagy/playground) and/or
  the [Pagy::Console](https://ddnexus.github.io/pagy/docs/api/console/).
- If you Create A Pull Request, please ensure that the "All checks have passed" indicator gets green light on the Pull Request
  page (if it's not enabled, a maintainer will enable it for you).

</details>

<details>

<summary>Versioning</summary>

- Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/). Please, check
  the [Changelog](https://ddnexus.github.io/pagy/changelog) for breaking changes introduced by mayor versions.
  Using [pessimistic version constraint](https://guides.rubygems.org/patterns/#pessimistic-version-constraint) in your Gemfile
  will ensure smooth upgrades.

</details>

<details>

<summary>Branches</summary>

- The `master` branch is the latest rubygem-published release. It also contains docs and comment changes that don't affect the
  published code. It is never force-pushed.
- The `dev` branch is the development branch with the new code that will be merged in the next release. It could be force-pushed.
- Expect any other branch to be internal, experimental, force-pushed, rebased and/or deleted even without merging.

</details>

<br>

## 💞 Related Projects

Search [rubygems.org - pagy](https://rubygems.org/search?query=pagy)

## 📃 License

[MIT](https://opensource.org/licenses/MIT)
