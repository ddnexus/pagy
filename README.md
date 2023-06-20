# Pagy

<span>[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=pagy&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/pagy)</span> <span>
[![ruby](https://img.shields.io/badge/ruby-2.5+%20*-ruby.svg?colorA=99004d&colorB=cc0066)](https://ddnexus.github.io/pagy/docs/prerequisites/#ruby)</span> <span>
[![Build Status](https://img.shields.io/github/actions/workflow/status/ddnexus/pagy/pagy-ci.yml?branch=master)](https://github.com/ddnexus/pagy/actions/workflows/pagy-ci.yml?query=branch%3Amaster)</span> <span>
[![CodeCov](https://img.shields.io/codecov/c/github/ddnexus/pagy.svg?colorA=1f7a1f&colorB=2aa22a)](https://codecov.io/gh/ddnexus/pagy)</span> <span>
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)</span> <span>
 [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/4329/badge)](https://bestpractices.coreinfrastructure.org/projects/4329)</span> <span>
![Commits](https://img.shields.io/github/commit-activity/y/ddnexus/pagy.svg?label=commits&colorA=004d99&colorB=0073e6)</span> <span>
![Downloads](https://img.shields.io/gem/dt/pagy.svg?colorA=004d99&colorB=0073e6)</span> <span>
[![Stars](https://shields.io/github/stars/ddnexus/pagy?style=social)](https://github.com/ddnexus/pagy/stargazers)</span>

## 🏆 The Best Pagination Ruby Gem 🥇

Pagy is focused on performance and flexibility.

### ~ 40x Faster!

[![IPS Chart](docs/assets/images/ips-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#ips-benchmark)

### ~ 36x Lighter!

[![Memory Chart](docs/assets/images/memory-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)

### ~ 35x Simpler!

[![Objects Chart](docs/assets/images/objects-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)

### ~ 1,410x More Efficient!

[![Resource Consumption Chart](docs/assets/images/resource-consumption-chart.png)](https://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio)

<details>

_Each dot in the visualization above represents the resources that Pagy consumes for one full rendering. The other gems consume hundreds of times as much for the same rendering._

_The [IPS/Kb ratio](http://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio) is calculated out of speed (IPS) and Memory (Kb): it shows how well each gem uses each Kb of memory it allocates/consumes._

See the [Detailed Gems Comparison](http://ddnexus.github.io/pagination-comparison/gems.html) for full details.

</details>

<br>

## 🤩 It does it all. Better.

- **It works in any environment**<br>With Rack frameworks (Rails, Sinatra, Padrino, etc.) or in pure ruby without Rack
- **It works with any collection**<br>With any ORM, any DB, any search gem, [elasticsearch_rails](https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails), [meilisearch](https://ddnexus.github.io/pagy/docs/extras/meilisearch), [searchkick](https://ddnexus.github.io/pagy/docs/extras/searchkick), `ransack`, and just any list, even if you cannot count it
- **It supports all kinds of pagination**<br>[calendar](https://ddnexus.github.io/pagy/docs/extras/calendar "paginates by dates, rather than numbers"), [countless](https://ddnexus.github.io/pagy/docs/extras/countless "skips an extra 'count' query"), [geared](https://ddnexus.github.io/pagy/docs/extras/gearbox "varies the items fetched depending on the page number e.g. page 1: x items, but page 2: y items etc."), [incremental, auto-incremental, infinite](https://ddnexus.github.io/pagy/docs/extras/support), [headers](https://ddnexus.github.io/pagy/docs/extras/headers "useful for API pagination"), [JSON](https://ddnexus.github.io/pagy/docs/extras/metadata "provides pagination metadata - especially useful with frameworks like Vue, React etc. and you want to render your own pagination links"), [cursor](https://github.com/Uysim/pagy-cursor "Useful with large data sets, where performance becomes a concern (separate repository)")
- **It supports all kinds of CSS Frameworks**<br>[bootstrap](https://ddnexus.github.io/pagy/docs/extras/bootstrap), [bulma](https://ddnexus.github.io/pagy/docs/extras/bulma), [foundation](https://ddnexus.github.io/pagy/docs/extras/foundation), [materialize](https://ddnexus.github.io/pagy/docs/extras/materialize), [semantic](https://ddnexus.github.io/pagy/docs/extras/semantic), [uikit](https://ddnexus.github.io/pagy/docs/extras/uikit), [tailwind](https://ddnexus.github.io/pagy/docs/extras/tailwind)
- **It supports faster client-side rendering**<br>With classic or innovative UI components (see [Javascript Components](https://ddnexus.github.io/pagy/docs/api/javascript/)) or by serving [JSON](https://ddnexus.github.io/pagy/docs/extras/metadata) to your favorite Javascript framework
- **It has 100% of test coverage** for Ruby, HTML and Javascript E2E (see [Pagy Workflows CI](https://github.com/ddnexus/pagy/actions))

<details>

### Code Structure

- **Pagy has a very slim core code** very easy to understand and use.
- **It has a quite fat set of optional extras** that you can explicitly require for very efficient and modular customization _(see [extras](https://ddnexus.github.io/pagy/categories/extra/))_
- **It has no dependencies**: it produces its own HTML, URLs, i18n with its own specialized and fast code
- **Its methods are accessible and overridable** right where you use them (no pesky monkey-patching needed)

### Unlike the other gems

- Pagy is very modular and does not load any unnecessary code (see [why...](https://ddnexus.github.io/pagy/quick-start#configure))_
- It doesn't impose limits even with collections|scopes that already used `limit` and `offset` _(see [how...](https://ddnexus.github.io/pagy/docs/how-to/#paginate-pre-offset-and-pre-limited-collections))_
- It works with fast helpers OR easy to edit templates _(see [more...](https://ddnexus.github.io/pagy/docs/how-to/#use-templates))_
- It raises `Pagy::OverflowError` exceptions that you can rescue from _(see [how...](https://ddnexus.github.io/pagy/docs/how-to/#handle-pagyoverflowerror-exceptions))_ or use the [overflow extra](https://ddnexus.github.io/pagy/docs/extras/overflow) for a few ready to use common behaviors
- It does not impose any difficult-to-override logic or output

### Better Components

Besides the classic pagination offered by the `pagy_nav` helpers, you can also use a couple of more performant alternatives:

- [pagy_nav_js](https://ddnexus.github.io/pagy/docs/api/javascript): A faster and lighter classic looking UI, rendered on the client side with optional responsiveness:<br>![bootstrap_nav_js](docs/assets/images/bootstrap_nav_js.png)

- [pagy_combo_nav_js](https://ddnexus.github.io/pagy/docs/api/javascript): The fastest and lightest alternative UI _(48x faster, 48x lighter and 2,270x more efficient than Kaminari)_ that combines navigation and pagination info in a single compact element:<br>![bootstrap_combo_nav_js](docs/assets/images/bootstrap_combo_nav_js.png)

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
Pagy::DEFAULT[:items] = 10        # items per page
Pagy::DEFAULT[:size]  = [1,4,4,1] # nav bar links
# Better user experience handled automatically
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page
```

```erb
<%# Render a view helper in your views (skipping nav links for empty pages) %>
<%== pagy_nav(@pagy) if @pagy.pages > 1 %>
```

Or, choose from the following view helpers:

| View Helper Name                                                                                                                                                                        | Preview (Bootstrap Style shown)                                        |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|
| [`pagy_nav(@pagy)`](/docs/api/frontend)                                                                                                                                                 | ![`pagy_nav`](/docs/assets/images/bootstrap_nav.png)                   |
| [`pagy_nav_js(@pagy)`](/pagy/docs/api/javascript/)                                                                                                                                      | ![`pagy_nav_js`](/docs/assets/images/bootstrap_nav_js.png)             |
| [`pagy_info(@pagy)`](/docs/api/frontend)                                                                                                                                                | ![`pagy_info`](/docs/assets/images/pagy_info.png)                      |
| [`pagy_combo_nav_js(@pagy)`](/pagy/docs/api/javascript/)                                                                                                                                | ![`pagy_combo_nav_js`](/docs/assets/images/bootstrap_combo_nav_js.png) |
| [`pagy_items_selector_js`](/pagy/docs/api/javascript/)                                                                                                                                  | ![`pagy_items_selector_js`](/docs/assets/images/items_selector_js.png) |
| [`pagy_nav(@calendar[:year])`](/pagy/docs/extras/calendar/)<br/>[`pagy_nav(@calendar[:month])`](/pagy/docs/extras/calendar/)<br/> (other units: `:quarter`, `:week`, `:day` and custom) | ![calendar extra](/docs/assets/images/calendar-app.png)                |

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

<summary>More customization with extras...</summary><br>

Extras add special options and manage different components, behaviors, Frontend or Backend environments... usually by just requiring them (and optionally overriding some default).

### Backend Extras

- [arel](https://ddnexus.github.io/pagy/docs/extras/arel): Provides better performance of grouped ActiveRecord collections
- [array](https://ddnexus.github.io/pagy/docs/extras/array): Paginate arrays efficiently.
- [calendar](https://ddnexus.github.io/pagy/docs/extras/calendar): Add pagination filtering by calendar time unit (year, quarter, month, week, day, custom)
- [countless](https://ddnexus.github.io/pagy/docs/extras/countless): Paginate without the need of any count, saving one query per rendering
- [elasticsearch_rails](https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails): Paginate `ElasticsearchRails` response objects
- [headers](https://ddnexus.github.io/pagy/docs/extras/headers): Add RFC-8288 compliant http response headers (and other helpers) useful for API pagination
- [meilisearch](https://ddnexus.github.io/pagy/docs/extras/meilisearch): Paginate `Meilisearch` results
- [metadata](https://ddnexus.github.io/pagy/docs/extras/metadata): Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.
- [searchkick](https://ddnexus.github.io/pagy/docs/extras/searchkick): Paginate `Searchkick::Results` objects

### Frontend Extras

- [bootstrap](https://ddnexus.github.io/pagy/docs/extras/bootstrap):  Add nav helpers and templates for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination)
- [bulma](https://ddnexus.github.io/pagy/docs/extras/bulma): Add nav helpers and templates for the Bulma CSS [pagination component](https://bulma.io/documentation/components/pagination)
- [foundation](https://ddnexus.github.io/pagy/docs/extras/foundation): Add nav helpers and templates for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html)
- [materialize](https://ddnexus.github.io/pagy/docs/extras/materialize): Add nav helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html)
- [navs](https://ddnexus.github.io/pagy/docs/extras/navs): Adds the unstyled versions of the javascript-powered nav helpers.
- [semantic](https://ddnexus.github.io/pagy/docs/extras/semantic): Add nav helpers for the Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html)
- [tailwind](https://ddnexus.github.io/pagy/docs/extras/tailwind): Ready to use style snippet for [Tailwind CSS](https://tailwindcss.com)
- [uikit](https://ddnexus.github.io/pagy/docs/extras/uikit): Add nav helpers and templates for the UIkit [pagination component](https://getuikit.com/docs/pagination)

### Extra Features and Tools

- [Pagy::Console](https://ddnexus.github.io/pagy/docs/api/console/): Use pagy in the irb/rails console even without any app nor configuration
- [gearbox](https://ddnexus.github.io/pagy/docs/extras/gearbox/): Automatically change the number of items per page depending on the page number
- [i18n](https://ddnexus.github.io/pagy/docs/extras/i18n): Use the `I18n` gem instead of the faster pagy-i18n implementation
- [items](https://ddnexus.github.io/pagy/docs/extras/items): Allow the client to request a custom number of items per page with an optional selector UI
- [overflow](https://ddnexus.github.io/pagy/docs/extras/overflow): Allow easy handling of overflowing pages
- [standalone](https://ddnexus.github.io/pagy/docs/extras/standalone): Use pagy without any request object, nor Rack environment/gem, nor any defined `params` method
- [support](https://ddnexus.github.io/pagy/docs/extras/support): Add support for countless or navless pagination (incremental, auto-incremental, infinite pagination).
- [trim](https://ddnexus.github.io/pagy/docs/extras/trim): Remove the `page=1` param from the first page link

</details>

See also the [How To Page](https://ddnexus.github.io/pagy/docs/how-to)

## 🤓 It's well documented and supported

<details open>

<summary> Documentation</summary>

- [Migrate from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/docs/migration-guide) (practical guide)
- [Quick Start](https://ddnexus.github.io/pagy/quick-start)
- [Documentation](https://ddnexus.github.io/pagy)
- [How To (quick recipes)](https://ddnexus.github.io/pagy/docs/how-to/)
- [Changelog](https://ddnexus.github.io/pagy/changelog)
- [Deprecations](https://ddnexus.github.io/pagy/changelog#deprecations)

</details>

<details open>

<summary> Support</summary>

- [Discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a)
- [Issues](https://github.com/ddnexus/pagy/issues)

</details>

<details>

<summary> Screencasts (12 entries)</summary>

### SupeRails

[<img src="https://img.youtube.com/vi/1tsWL4EjhMo/0.jpg" width="360" title="15 min - Beginner friendly - Shows installation and use of some pagy extras">](https://www.youtube.com/watch?v=1tsWL4EjhMo)

[<img src="https://img.youtube.com/vi/ScxUqW29F7E/0.jpg" width="360" title="18 min - Intermediate Skill Level - 'Load More' pagination using Turbo Streams">](https://www.youtube.com/watch?v=ScxUqW29F7E)

[<img src="https://img.youtube.com/vi/A9q6YwhLCyI/0.jpg" title="17 min - Intermediate Skill Level - Pagination with Search (Ransack) and Hotwire + Infinite (Countless) Pagination" width="360">](https://www.youtube.com/watch?v=A9q6YwhLCyI)

[<img src="https://img.youtube.com/vi/Qoq6HZ8gdDE/0.jpg" title="12:52 min - Intermediate Skill Level - API based pagination + using pagy_metadata" width="360">](https://www.youtube.com/watch?v=Qoq6HZ8gdDE)

### GoRails

[<img src="https://img.youtube.com/vi/K4fob588tfM/0.jpg" width="360" title="11 min - Beginner - How to Install + 'Hello world' example">](https://www.youtube.com/watch?v=K4fob588tfM)

[<img src="https://img.youtube.com/vi/1sNpvTMrxl4/0.jpg" width="360" title="31 min - Beginner - Basic Pagy Use (Tailwind, Overflow, Common Use cases) + Deep dive into building a sample Blogging Application">](https://www.youtube.com/watch?v=1sNpvTMrxl4)

### CJ Avilla

[<img src="https://img.youtube.com/vi/0RtYhDIKmBY/0.jpg" width="360" title="5:44 min - Beginner - How to Install Pagy + Using Tailwind CSS to create a page of 'listing'">](https://www.youtube.com/watch?v=0RtYhDIKmBY)

### Mike Rogers

[<img src="https://img.youtube.com/vi/aILtxj_LVuA/0.jpg" width="360">](https://www.youtube.com/watch?v=aILtxj_LVuA)

### Deanin

[<img src="https://img.youtube.com/vi/ArBUAxEA6vM/0.jpg" width="360">](https://www.youtube.com/watch?v=ArBUAxEA6vM)

[<img src="https://img.youtube.com/vi/4nrmf5KfD8Y/0.jpg" width="360" title="14:28 min - Intermediate - Infinite Scrolling with Turbo Streams (Rails 7)">](https://www.youtube.com/watch?v=4nrmf5KfD8Y)

### Mix & Go

[<img src="https://img.youtube.com/vi/HURqvNJF4T0/0.jpg" width="360">](https://www.youtube.com/watch?v=HURqvNJF4T0)

### Raul Palacio (Spanish)

[<img src="https://img.youtube.com/vi/_j3gtKf5rRs/0.jpg" width="360">](https://www.youtube.com/watch?v=_j3gtKf5rRs)

</details>

<details>

<summary> Posts and tutorials (19 entries)</summary>

- [Migrate from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/docs/migration-guide) (practical guide)
- [Detailed Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html) (charts and analysis)
- [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison) (Rails app repository)
- [Faster Pagination with Pagy](https://viblo.asia/p/faster-pagination-with-pagy-Eb85ok9W52G) introductory tutorial by Sirajus Salekin
- [Pagy with Templates Minipost](https://www.aloucaslabs.com/miniposts/how-to-install-pagy-gem-with-a-custom-pagination-template-on-a-ruby-on-rails-application) by aloucas
- [Pagination with Pagy](https://www.imaginarycloud.com/blog/paginating-ruby-on-rails-apps-with-pagy) by Tiago Franco
- [Quick guide for Pagy with Sinatra and Sequel](https://medium.com/@vfreefly/how-to-use-pagy-with-sequel-and-sinatra-157dfec1c417) by Victor Afanasev
- [Integrating Pagy with Hanami](http://katafrakt.me/2018/06/01/integrating-pagy-with-hanami/) by Paweł Świątkowski
- [Stateful Tabs with Pagy](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy) by Chris Seelus
- [Endless Scroll / Infinite Loading with Turbo Streams & Stimulus](https://www.stefanwienert.de/blog/2021/04/17/endless-scroll-with-turbo-streams/) by Stefan Wienert
- [Pagination with Hotwire](https://www.beflagrant.com/blog/pagination-with-hotwire) by Jonathan Greenberg
- [Pagination and infinite scrolling with Rails and the Hotwire stack](https://www.colby.so/posts/pagination-and-infinite-scrolling-with-hotwire) by David Colby
- [Building a dynamic data grid with search and filters using rails, hotwire and ransack](https://bhserna.com/building-data-grid-with-search-rails-hotwire-ransack.html) by Benito Serna.
- [Pagination for Beginners: What is it? Why bother?](https://benkoshy.github.io/2021/11/03/pagination-basics.html) by Ben Koshy.
- [Handling Pagination When POSTing Complex Search Forms](https://benkoshy.github.io/2019/10/09/paginating-search-results-with-a-post-request.html) by Ben Koshy.
- [How to Override pagy methods only in specific circumstances](https://benkoshy.github.io/2020/02/01/overriding-pagy-methods.html) by Ben Koshy.
- [How to make your pagination links sticky + bounce at the bottom of your page](https://benkoshy.github.io/2020/09/15/sticky-menu.html) by Ben Koshy.
- [日本語の投稿](https://qiita.com/search?q=pagy)
- [한국어 튜토리얼](https://kbs4674.tistory.com/72)

</details>

<br>

## 📦 Repository Info

<details>

<summary><b>What's new in 6.0</b></summary>

- New improved [documentation](https://ddnexus.github.io/pagy)
- New finite pagination for [meilisearch extra](https://ddnexus.github.io/pagy/docs/extras/meilisearch)
- New `:request_path` [variable](https://ddnexus.github.io/pagy/docs/api/pagy/#other-variables) allows overriding the request path for pagination links (turbo frames)
- Fix for the args forwarding in the `Pagy::Countless#series` for Ruby 3
- Removed support for 5.0 deprecations (see the [Changelog](https://ddnexus.github.io/pagy/changelog))

</details>

<details>

<summary>How to contribute</summary>

- Pull Requests are welcome!
- For simple contribution you can quickly check your changes with the [Pagy::Console](https://ddnexus.github.io/pagy/docs/api/console/) or with the single file [pagy_standalone_app.ru](https://github.com/ddnexus/pagy/blob/master/apps/pagy_standalone_app.ru).
- If you Create A Pull Request, please ensure that the "All checks have passed" indicator gets green light on the Pull Request page (if it's not enabled, a maintainer will enable it for you).

</details>

<details>

<summary>Versioning</summary>

- Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/). Please, check the [Changelog](https://ddnexus.github.io/pagy/changelog) for breaking changes introduced by mayor versions. Using [pessimistic version constraint](https://guides.rubygems.org/patterns/#pessimistic-version-constraint) in your Gemfile will ensure smooth upgrades.

</details>

<details>

<summary>Branches</summary>

- The `master` branch is the latest rubygem-published release. It also contains docs and comment changes that don't affect the published code. It is never force-pushed.
- The `dev` branch is the development branch with the new code that will be merged in the next release. It could be force-pushed.
- Expect any other branch to be internal, experimental, force-pushed, rebased and/or deleted even without merging.

</details>

<br>

## 💞 Related Projects

- [pagy-cursor](https://github.com/Uysim/pagy-cursor) An early stage project that implements cursor pagination for AR
- [grape-pagy](https://github.com/bsm/grape-pagy) Pagy pagination for the [grape](https://github.com/ruby-grape/grape) API framework

## 👏 Credits

Many thanks to:

- [Ben Koshy](https://github.com/benkoshy) for his contributions to the documentation, user support and interaction with external frameworks
- [GoRails](https://gorails.com) for the great [Pagy Screencast](https://gorails.com/episodes/pagination-with-pagy-gem?autoplay=1) and their top notch [Rails Episodes](https://gorails.com/episodes)
- [Imaginary Cloud](https://www.imaginarycloud.com) for continually publishing high-interest articles and helping to share Pagy when it just started
- [JetBrains](http://www.jetbrains.com?from=https%3A%2F%2Fgithub.com%2Fddnexus%2Fpagy) for their free OpenSource license
- [The Contributors](https://github.com/ddnexus/pagy/graphs/contributors) for all the smart code and suggestions merged in the project
- [The Stargazers](https://github.com/ddnexus/pagy/stargazers) for showing their support

## 📃 License

[MIT](https://opensource.org/licenses/MIT)
