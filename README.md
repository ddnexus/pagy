# Pagy

<span>[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=Pagy&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/pagy)</span> <span>
[![Ruby](https://img.shields.io/badge/Ruby-EOL-ruby.svg?colorA=99004d&colorB=cc0066)](https://endoflife.date/ruby)</span> <span>
[![Ruby Test](https://github.com/ddnexus/pagy/actions/workflows/ruby-test.yml/badge.svg?branch=master)](https://github.com/ddnexus/pagy/actions/workflows/ruby-test.yml)</span> <span>
[![E2E Test](https://github.com/ddnexus/pagy/actions/workflows/e2e-test.yml/badge.svg?branch=master)](https://github.com/ddnexus/pagy/actions/workflows/e2e-test.yml)</span> <span>
![Coverage](https://img.shields.io/badge/Coverage-100%25-coverage.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
![Rubocop Status](https://img.shields.io/badge/Rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
[![MIT license](https://img.shields.io/badge/License-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)</span> <span>
[![Commits](https://img.shields.io/github/commit-activity/y/ddnexus/pagy.svg?label=Commits&colorA=004d99&colorB=0073e6)](https://github.com/ddnexus/pagy/commits/master/)</span> <span>
[![Downloads](https://img.shields.io/gem/dt/pagy.svg?label=Downloads&colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/pagy)</span> <span>
[![Stars](https://shields.io/github/stars/ddnexus/pagy?style=social)](https://github.com/ddnexus/pagy/stargazers)</span> <span>
[![Gurubase](https://img.shields.io/badge/Gurubase-Ask%20Pagy%20Guru-006BFF)](https://gurubase.io/g/pagy)</span>

## 🏆 The Best Pagination Ruby Gem 🥇

---
<!-- whats_new_start -->
### ✴ What's new in 9.0+ ✴
- Wicked-fast [Keyset Pagination](https://ddnexus.github.io/pagy/docs/api/keyset/) for big data! It works with `ActiveRecord::Relation` and `Sequel::Dataset` sets.
- More [Playground Apps](https://ddnexus.github.io/pagy/playground/) to showcase, clone and develop pagy APPs without any setup on your side
- Lots of refactorings and optimizations  
- See the [Changelog](https://ddnexus.github.io/pagy/changelog) for possible breaking changes
<!-- whats_new_end -->
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
pagination that are not part of the comparison because missing in the other gems.

For full details about the charts above:
- [Detailed Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html) (charts and analysis)
- [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison) (Rails app repository)

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
  [calendar](https://ddnexus.github.io/pagy/docs/extras/calendar "paginates by dates, rather than numbers"),
  [countless](https://ddnexus.github.io/pagy/docs/extras/countless "skips an extra 'count' query"),
  [geared](https://ddnexus.github.io/pagy/docs/extras/gearbox "varies the fetched items depending on the page number e.g. page 1: x items, but page 2: y items etc."),
  [incremental, auto-incremental, infinite](https://ddnexus.github.io/pagy/docs/extras/pagy),
  [headers](https://ddnexus.github.io/pagy/docs/extras/headers "useful for API pagination"),
  [JSON](https://ddnexus.github.io/pagy/docs/extras/metadata "provides pagination metadata - especially useful with frameworks like Vue, React etc. and you want to render your own pagination links"),
  [Keyset Pagination](https://ddnexus.github.io/pagy/docs/extras/keyset/ "Useful with large data sets, where performance becomes a concern")
- **It supports the most popular CSS Frameworks and APIs** like [bootstrap](https://ddnexus.github.io/pagy/docs/extras/bootstrap),
  [bulma](https://ddnexus.github.io/pagy/docs/extras/bulma),
  [tailwind](https://ddnexus.github.io/pagy/docs/extras/tailwind),
  [JSON:API](https://ddnexus.github.io/pagy/docs/extras/jsonapi/)
- **It supports faster client-side rendering**
  With classic or innovative UI components (see [Javascript Components](https://ddnexus.github.io/pagy/docs/api/javascript/)) or
  by
  serving [JSON](https://ddnexus.github.io/pagy/docs/extras/metadata) to your favorite Javascript framework
- **It has 100% of test coverage** for Ruby, HTML and Javascript E2E (
  see [Pagy Workflows CI](https://github.com/ddnexus/pagy/actions))

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
Pagy::DEFAULT[:limit] = 10 # items per page
Pagy::DEFAULT[:size]  = 9  # nav bar links
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
| [`pagy_limit_selector_js`](https://ddnexus.github.io/pagy/docs/api/javascript/)                                                                                                                                                           | ![`pagy_limit_selector_js`](/docs/assets/images/limit_selector_js.png) |
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

<br> 

**More customization with** [Extras](https://ddnexus.github.io/pagy/categories/extra/) that add special options and manage different components, behaviors, Frontend or Backend environments... usually by just
requiring them (and optionally overriding some default).

See also the [How To Page](https://ddnexus.github.io/pagy/docs/how-to)

## 🤓 It's well documented and supported

### Documentation

- [Migrate from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/docs/migration-guide) (practical guide)
- [Quick Start](https://ddnexus.github.io/pagy/quick-start)
- [Documentation](https://ddnexus.github.io/pagy)
- [How To (quick recipes)](https://ddnexus.github.io/pagy/docs/how-to/)
- [Changelog](https://ddnexus.github.io/pagy/changelog)
- [How Pagy's Docs work?](https://github.com/ddnexus/pagy/blob/master/docs/README.md)

### Support

- [Discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a)
- [Issues](https://github.com/ddnexus/pagy/issues)

### Recent Posts and Tutorials

- [Build Load More Pagination with Pagy and Rails Hotwire](https://maful.web.id/posts/build-load-more-pagination-with-pagy-and-rails-hotwire/ '2023-09-17') by Maful. (This tutorial shows how you can turbo_stream with GET requests)
- [Pagination and infinite scrolling with Rails and the Hotwire stack](https://www.colby.so/posts/infinite-scroll-with-turbo-streams-and-stimulus '2022-04-19') by David Colby
- [Pagination with Hotwire](https://www.beflagrant.com/blog/pagination-with-hotwire '2021-09-23') by Jonathan Greenberg
- [Pagination for Beginners: What is it? Why bother?](https://benkoshy.github.io/2021/11/03/pagination-basics.html '2021-11-03') by Ben Koshy
- [Endless Scroll / Infinite Loading with Turbo Streams & Stimulus](https://www.stefanwienert.de/blog/2021/04/17/endless-scroll-with-turbo-streams/ '2021-04-17') by Stefan Wienert
- [How to make your pagination links sticky + bounce at the bottom of your page](https://benkoshy.github.io/2020/09/15/sticky-menu.html '2020-09-15') by Ben Koshy
- [How to Override pagy methods only in specific circumstances](https://benkoshy.github.io/2020/02/01/overriding-pagy-methods.html  '2020-02-01') by Ben Koshy
- [Handling Pagination When POSTing Complex Search Forms](https://benkoshy.github.io/2019/10/09/paginating-search-results-with-a-post-request.html '2019-10-09') by Ben Koshy
- [Pagination with Pagy](https://www.imaginarycloud.com/blog/paginating-ruby-on-rails-apps-with-pagy '2018-04-19') by Tiago Franco
- [日本語の投稿](https://qiita.com/search?q=pagy)

### Recent Screencasts

[<img src="https://img.youtube.com/vi/bVvLNpJyZuw/0.jpg" width="150" title="9:29 min - Intermediate - Infinite Scrolling with Pagy Keyset, Turbo (Rails 8) (2024-10-19)">](https://www.youtube.com/watch?v=bVvLNpJyZuw) 
[<img src="https://img.youtube.com/vi/EDyZIB8FU-g/0.jpg" title="12:52 min - Intermediate Skill Level - Calendar sarch with Pagy (2024-01-21)" width="150">](https://www.youtube.com/watch?v=EDyZIB8FU-g)
[<img src="https://img.youtube.com/vi/zni3nMA5_AY/0.jpg" width="150" title="10:53 - Urdu Language (2024-01-15)">](https://www.youtube.com/watch?v=zni3nMA5_AY)
[<img src="https://img.youtube.com/vi/4nrmf5KfD8Y/0.jpg" width="150" title="14:28 min - Intermediate - Infinite Scrolling with Turbo Streams (Rails 7) (2023-06-09)">](https://www.youtube.com/watch?v=4nrmf5KfD8Y)
[<img src="https://img.youtube.com/vi/Qoq6HZ8gdDE/0.jpg" title="12:52 min - Intermediate Skill Level - API based pagination + using pagy_metadata (2023-05-18)" width="150">](https://www.youtube.com/watch?v=Qoq6HZ8gdDE) 
[<img src="https://img.youtube.com/vi/1sNpvTMrxl4/0.jpg" width="150" title="31 min - Beginner - Basic Pagy Use (Tailwind, Overflow, Common Use cases) + Deep dive into building a sample Blogging Application (2023-04-05)">](https://www.youtube.com/watch?v=1sNpvTMrxl4) 
[<img src="https://img.youtube.com/vi/A9q6YwhLCyI/0.jpg" title="17 min - Intermediate Skill Level - Pagination with Search (Ransack) and Hotwire + Infinite (Countless) Pagination (2022-12-09)" width="150">](https://www.youtube.com/watch?v=A9q6YwhLCyI)
[<img src="https://img.youtube.com/vi/HURqvNJF4T0/0.jpg" width="150" title="5:21 min - Intermediate - Using Pagy - with a strong focus on Hotwire and filtering search results (2022-04-20)">](https://www.youtube.com/watch?v=HURqvNJF4T0)
[<img src="https://img.youtube.com/vi/ScxUqW29F7E/0.jpg" width="150" title="18 min - Intermediate Skill Level - 'Load More' pagination using Turbo Streams (2022-03-22)">](https://www.youtube.com/watch?v=ScxUqW29F7E)
[<img src="https://img.youtube.com/vi/0RtYhDIKmBY/0.jpg" width="150" title="5:44 min - Beginner - How to Install Pagy + Using Tailwind CSS to create a page of 'listing' (2022-03-18)">](https://www.youtube.com/watch?v=0RtYhDIKmBY)
[<img src="https://img.youtube.com/vi/ArBUAxEA6vM/0.jpg" width="150" title="30:00 min - Advanced - Using Pagy In the Context of a Chat Room (Infinite Scroll, Hotwire, Stimulus JS + Using Pagy APIs) (2022-03-04)">](https://www.youtube.com/watch?v=ArBUAxEA6vM) 
[<img src="https://img.youtube.com/vi/1tsWL4EjhMo/0.jpg" width="150" title="15 min - Beginner friendly - Shows installation and use of some pagy extras (2021-05-05)">](https://www.youtube.com/watch?v=1tsWL4EjhMo)
[<img src="https://img.youtube.com/vi/aILtxj_LVuA/0.jpg" width="150" title="7:23 min - Beginner - Installing Pagy + Working through errors (step-by-step) (2021-03-12)">](https://www.youtube.com/watch?v=aILtxj_LVuA)
[<img src="https://img.youtube.com/vi/_j3gtKf5rRs/0.jpg" width="150" title="10:45 - Spanish Language (2020-09-11)">](https://www.youtube.com/watch?v=_j3gtKf5rRs)

<br>

## Top 💯 Contributors

<!-- top100_start -->

[<img src="https://avatars.githubusercontent.com/u/100721?v=4" width="40" title="@ddnexus: 1750 contributions">](https://github.com/ddnexus/pagy/commits?author=ddnexus)[<img src="https://avatars.githubusercontent.com/u/15097447?v=4" width="40" title="@benkoshy: 78 contributions">](https://github.com/ddnexus/pagy/commits?author=benkoshy)[<img src="https://avatars.githubusercontent.com/u/11367?v=4" width="40" title="@grosser: 9 contributions">](https://github.com/ddnexus/pagy/commits?author=grosser)[<img src="https://avatars.githubusercontent.com/u/14981592?v=4" width="40" title="@Earlopain: 4 contributions">](https://github.com/ddnexus/pagy/commits?author=Earlopain)[<img src="https://avatars.githubusercontent.com/u/9843321?v=4" width="40" title="@workgena: 4 contributions">](https://github.com/ddnexus/pagy/commits?author=workgena)[<img src="https://avatars.githubusercontent.com/u/17091381?v=4" width="40" title="@djpremier: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=djpremier)[<img src="https://avatars.githubusercontent.com/u/22333?v=4" width="40" title="@bquorning: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=bquorning)[<img src="https://avatars.githubusercontent.com/u/235048?v=4" width="40" title="@molfar: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=molfar)[<img src="https://avatars.githubusercontent.com/u/132?v=4" width="40" title="@sunny: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=sunny)[<img src="https://avatars.githubusercontent.com/u/26239269?v=4" width="40" title="@enzinia: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=enzinia)[<img src="https://avatars.githubusercontent.com/u/32258?v=4" width="40" title="@espen: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=espen)[<img src="https://avatars.githubusercontent.com/u/2051199?v=4" width="40" title="@rbngzlv: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=rbngzlv)[<img src="https://avatars.githubusercontent.com/u/8125726?v=4" width="40" title="@simonneutert: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=simonneutert)[<img src="https://avatars.githubusercontent.com/u/195636?v=4" width="40" title="@tersor: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=tersor)[<img src="https://avatars.githubusercontent.com/u/1100176?v=4" width="40" title="@thomasklemm: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=thomasklemm)[<img src="https://avatars.githubusercontent.com/u/37790?v=4" width="40" title="@gamafranco: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=gamafranco)[<img src="https://avatars.githubusercontent.com/u/500826?v=4" width="40" title="@tiagotex: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=tiagotex)[<img src="https://avatars.githubusercontent.com/u/112558900?v=4" width="40" title="@wimdavies: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=wimdavies)[<img src="https://avatars.githubusercontent.com/u/7076736?v=4" width="40" title="@renshuki: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=renshuki)[<img src="https://avatars.githubusercontent.com/u/2749593?v=4" width="40" title="@berniechiu: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=berniechiu)[<img src="https://avatars.githubusercontent.com/u/4824537?v=4" width="40" title="@yenshirak: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=yenshirak)[<img src="https://avatars.githubusercontent.com/u/101501?v=4" width="40" title="@rainerborene: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=rainerborene)[<img src="https://avatars.githubusercontent.com/u/421488?v=4" width="40" title="@petergoldstein: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=petergoldstein)[<img src="https://avatars.githubusercontent.com/u/50970645?v=4" width="40" title="@sabljak: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=sabljak)[<img src="https://avatars.githubusercontent.com/u/3188392?v=4" width="40" title="@cseelus: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=cseelus)[<img src="https://avatars.githubusercontent.com/u/12526288?v=4" width="40" title="@benjaminwols: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=benjaminwols)[<img src="https://avatars.githubusercontent.com/u/12479464?v=4" width="40" title="@ashmaroli: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=ashmaroli)[<img src="https://avatars.githubusercontent.com/u/3427854?v=4" width="40" title="@747: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=747)[<img src="https://avatars.githubusercontent.com/u/43544760?v=4" width="40" title="@WilliamHorel: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=WilliamHorel)[<img src="https://avatars.githubusercontent.com/u/1012014?v=4" width="40" title="@okuramasafumi: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=okuramasafumi)[<img src="https://avatars.githubusercontent.com/u/12237543?v=4" width="40" title="@olieidel: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=olieidel)[<img src="https://avatars.githubusercontent.com/u/211?v=4" width="40" title="@olleolleolle: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=olleolleolle)[<img src="https://avatars.githubusercontent.com/u/43936240?v=4" width="40" title="@PedroAugustoRamalhoDuarte: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=PedroAugustoRamalhoDuarte)[<img src="https://avatars.githubusercontent.com/u/2815199?v=4" width="40" title="@pedrocarmona: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=pedrocarmona)[<img src="https://avatars.githubusercontent.com/u/891109?v=4" width="40" title="@peter50216: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=peter50216)[<img src="https://avatars.githubusercontent.com/u/32079912?v=4" width="40" title="@rafaeelaudibert: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rafaeelaudibert)[<img src="https://avatars.githubusercontent.com/u/7660738?v=4" width="40" title="@rafaelmontas: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rafaelmontas)[<img src="https://avatars.githubusercontent.com/u/412056?v=4" width="40" title="@rogermarlow: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rogermarlow)[<img src="https://avatars.githubusercontent.com/u/1478773?v=4" width="40" title="@Tolchi: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Tolchi)[<img src="https://avatars.githubusercontent.com/u/310909?v=4" width="40" title="@serghost: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=serghost)[<img src="https://avatars.githubusercontent.com/u/9060346?v=4" width="40" title="@artplan1: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=artplan1)[<img src="https://avatars.githubusercontent.com/u/23448075?v=4" width="40" title="@woller: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=woller)[<img src="https://avatars.githubusercontent.com/u/30351533?v=4" width="40" title="@sk8higher: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=sk8higher)[<img src="https://avatars.githubusercontent.com/u/58137134?v=4" width="40" title="@muhammadnawzad: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=muhammadnawzad)[<img src="https://avatars.githubusercontent.com/u/69295?v=4" width="40" title="@ronald: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=ronald)[<img src="https://avatars.githubusercontent.com/u/10906059?v=4" width="40" title="@achmiral: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=achmiral)[<img src="https://avatars.githubusercontent.com/u/1393996?v=4" width="40" title="@mauro-ni: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=mauro-ni)[<img src="https://avatars.githubusercontent.com/u/462701?v=4" width="40" title="@borama: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=borama)[<img src="https://avatars.githubusercontent.com/u/24856?v=4" width="40" title="@creativetags: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=creativetags)[<img src="https://avatars.githubusercontent.com/u/24826?v=4" width="40" title="@mcary: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=mcary)[<img src="https://avatars.githubusercontent.com/u/93276?v=4" width="40" title="@marckohlbrugge: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=marckohlbrugge)[<img src="https://avatars.githubusercontent.com/u/1753398?v=4" width="40" title="@fluser: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=fluser)[<img src="https://avatars.githubusercontent.com/u/6563823?v=4" width="40" title="@maful: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=maful)[<img src="https://avatars.githubusercontent.com/u/7241024?v=4" width="40" title="@AngelGuerra: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=AngelGuerra)[<img src="https://avatars.githubusercontent.com/u/18153165?v=4" width="40" title="@tr4b4nt: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tr4b4nt)[<img src="https://avatars.githubusercontent.com/u/4953187?v=4" width="40" title="@tiejianluo: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tiejianluo)[<img src="https://avatars.githubusercontent.com/u/28652?v=4" width="40" title="@szTheory: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=szTheory)[<img src="https://avatars.githubusercontent.com/u/22420?v=4" width="40" title="@smoothdvd: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=smoothdvd)[<img src="https://avatars.githubusercontent.com/u/87665329?v=4" width="40" title="@rhodes-david: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rhodes-david)[<img src="https://avatars.githubusercontent.com/u/5484758?v=4" width="40" title="@radinreth: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=radinreth)[<img src="https://avatars.githubusercontent.com/u/54139019?v=4" width="40" title="@pranavbabu: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=pranavbabu)[<img src="https://avatars.githubusercontent.com/u/884634?v=4" width="40" title="@okliv: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=okliv)[<img src="https://avatars.githubusercontent.com/u/5013677?v=4" width="40" title="@nedimdz: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=nedimdz)[<img src="https://avatars.githubusercontent.com/u/468744?v=4" width="40" title="@msdundar: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=msdundar)[<img src="https://avatars.githubusercontent.com/u/59817964?v=4" width="40" title="@m-abdurrehman: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=m-abdurrehman)[<img src="https://avatars.githubusercontent.com/u/831536?v=4" width="40" title="@dwieringa: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=dwieringa)[<img src="https://avatars.githubusercontent.com/u/29891001?v=4" width="40" title="@jyuvaraj03: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=jyuvaraj03)[<img src="https://avatars.githubusercontent.com/u/6220668?v=4" width="40" title="@YutoYasunaga: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=YutoYasunaga)[<img src="https://avatars.githubusercontent.com/u/65494027?v=4" width="40" title="@iamyujinwon: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=iamyujinwon)[<img src="https://avatars.githubusercontent.com/u/13119624?v=4" width="40" title="@yhk1038: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=yhk1038)[<img src="https://avatars.githubusercontent.com/u/6612882?v=4" width="40" title="@ya-s-u: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=ya-s-u)[<img src="https://avatars.githubusercontent.com/u/13472945?v=4" width="40" title="@yshmarov: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=yshmarov)[<img src="https://avatars.githubusercontent.com/u/9436230?v=4" width="40" title="@Davidzhu001: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Davidzhu001)[<img src="https://avatars.githubusercontent.com/u/190269?v=4" width="40" title="@thattimc: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=thattimc)[<img src="https://avatars.githubusercontent.com/u/7021119?v=4" width="40" title="@thomaschauffour: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=thomaschauffour)[<img src="https://avatars.githubusercontent.com/u/361323?v=4" width="40" title="@snkashis: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=snkashis)[<img src="https://avatars.githubusercontent.com/u/6059188?v=4" width="40" title="@sliminas: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=sliminas)[<img src="https://avatars.githubusercontent.com/u/9826538?v=4" width="40" title="@LuukvH: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=LuukvH)[<img src="https://avatars.githubusercontent.com/u/64050?v=4" width="40" title="@gjtorikian: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=gjtorikian)[<img src="https://avatars.githubusercontent.com/u/149513?v=4" width="40" title="@tulak: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tulak)[<img src="https://avatars.githubusercontent.com/u/6208777?v=4" width="40" title="@Federico-G: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Federico-G)[<img src="https://avatars.githubusercontent.com/u/18742365?v=4" width="40" title="@egimenos: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=egimenos)[<img src="https://avatars.githubusercontent.com/u/73437?v=4" width="40" title="@elliotlarson: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=elliotlarson)[<img src="https://avatars.githubusercontent.com/u/17459154?v=4" width="40" title="@hungdiep97: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=hungdiep97)[<img src="https://avatars.githubusercontent.com/u/6763624?v=4" width="40" title="@davidwessman: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=davidwessman)[<img src="https://avatars.githubusercontent.com/u/813150?v=4" width="40" title="@david-a-wheeler: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=david-a-wheeler)[<img src="https://avatars.githubusercontent.com/u/1169363?v=4" width="40" title="@daniel-rikowski: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=daniel-rikowski)[<img src="https://avatars.githubusercontent.com/u/8194848?v=4" width="40" title="@connie-feng: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=connie-feng)[<img src="https://avatars.githubusercontent.com/u/83706?v=4" width="40" title="@MrMoins: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=MrMoins)[<img src="https://avatars.githubusercontent.com/u/67093?v=4" width="40" title="@excid3: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=excid3)[<img src="https://avatars.githubusercontent.com/u/5347394?v=4" width="40" title="@cellvinchung: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=cellvinchung)[<img src="https://avatars.githubusercontent.com/u/4116980?v=4" width="40" title="@brunoocasali: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=brunoocasali)[<img src="https://avatars.githubusercontent.com/u/42350151?v=4" width="40" title="@branson-simplethread: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=branson-simplethread)[<img src="https://avatars.githubusercontent.com/u/19940878?v=4" width="40" title="@BrandonKlotz: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=BrandonKlotz)[<img src="https://avatars.githubusercontent.com/u/3390330?v=4" width="40" title="@Atul9: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Atul9)[<img src="https://avatars.githubusercontent.com/u/1328587?v=4" width="40" title="@amenon: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=amenon)[<img src="https://avatars.githubusercontent.com/u/482867?v=4" width="40" title="@artinboghosian: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=artinboghosian)[<img src="https://avatars.githubusercontent.com/u/58791514?v=4" width="40" title="@antonzaharia: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=antonzaharia)[<img src="https://avatars.githubusercontent.com/u/43855653?v=4" width="40" title="@PyrinAndrii: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=PyrinAndrii)[<img src="https://avatars.githubusercontent.com/u/1060?v=4" width="40" title="@andrew: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=andrew)
<!-- top100_end -->

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

See [Contributing](https://github.com/ddnexus/pagy/blob/master/.github/CONTRIBUTING.md)

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

[Search rubygems.org](https://rubygems.org/search?query=pagy)

## 📃 License

[MIT](https://opensource.org/licenses/MIT)
