# Pagy

[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=pagy&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/pagy)
![ruby](https://img.shields.io/badge/ruby-2.5+-ruby.svg?colorA=99004d&colorB=cc0066)
[![Build Status](https://img.shields.io/github/workflow/status/ddnexus/pagy/Pagy%20CI/master)](https://github.com/ddnexus/pagy/actions?query=branch:master)
[![CodeCov](https://img.shields.io/codecov/c/github/ddnexus/pagy.svg?colorA=1f7a1f&colorB=2aa22a)](https://codecov.io/gh/ddnexus/pagy)
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)
 [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/4329/badge)](https://bestpractices.coreinfrastructure.org/projects/4329)
![Commits](https://img.shields.io/github/commit-activity/y/ddnexus/pagy.svg?label=commits&colorA=004d99&colorB=0073e6)
![Downloads](https://img.shields.io/gem/dt/pagy.svg?colorA=004d99&colorB=0073e6)
[![Chat](http://img.shields.io/badge/gitter-ruby--pagy-purple.svg?colorA=800080&colorB=b300b3)](https://gitter.im/ruby-pagy/Lobby)

## 🤠 The kick-ass pagination gem!

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

## 🤩 It does it all. Better.

- **It works in any environment**<br>With Rack frameworks like Rails, Sinatra, Padrino, ecc. or in pure ruby even without Rack
- **It works with any collection**<br>With any ORM, any DB, any search gem, [elasticsearch_rails](http://ddnexus.github.io/pagy/extras/elasticsearch_rails), [meilisearch](http://ddnexus.github.io/pagy/extras/meilisearch), [searchkick](http://ddnexus.github.io/pagy/extras/searchkick), `ransack`, and just any list, even if you cannot count it
- **It supports all kinds of pagination**<br>[countless](http://ddnexus.github.io/pagy/extras/countless), [geared](http://ddnexus.github.io/pagy/extras/gearbox), [incremental, auto-incremental, infinite](http://ddnexus.github.io/pagy/extras/support), [headers](http://ddnexus.github.io/pagy/extras/headers), [JSON](http://ddnexus.github.io/pagy/extras/metadata), [cursor](https://github.com/Uysim/pagy-cursor)
- **It supports all kinds of CSS Frameworks**<br>[bootstrap](http://ddnexus.github.io/pagy/extras/bootstrap), [bulma](http://ddnexus.github.io/pagy/extras/bulma), [foundation](http://ddnexus.github.io/pagy/extras/foundation), [materialize](http://ddnexus.github.io/pagy/extras/materialize), [semantic](http://ddnexus.github.io/pagy/extras/semantic), [uikit](http://ddnexus.github.io/pagy/extras/uikit), [tailwind](http://ddnexus.github.io/pagy/extras/tailwind)
- **It supports faster client-side rendering**<br>With classic or innovative UI components (see [Javascript Navs](https://ddnexus.github.io/pagy/api/javascript#javascript-navs) and [Javascript Combo Navs](https://ddnexus.github.io/pagy/api/javascript#javascript-combo-navs)) or by serving [JSON](http://ddnexus.github.io/pagy/extras/metadata) to your favorite Javascript framework
- **It has 100% of test coverage** for Ruby, HTML and Javascript E2E (see [Pagy Workflows CI](https://github.com/ddnexus/pagy/actions))

<details>

### Code Structure

- **Pagy has a very slim core code** very easy to understand and use _(see [more...](https://ddnexus.github.io/pagy/api))_
- **It has a quite fat set of optional extras** that you can explicitly require for very efficient and modular customization _(see [extras](https://ddnexus.github.io/pagy/extras))_
- **It has no dependencies**: it produces its own HTML, URLs, i18n with its own specialized and fast code _(see [why...](https://ddnexus.github.io/pagy/index#specialized-code-instead-of-generic-helpers))_
- **Its methods are accessible and overridable** right where you use them (no pesky monkey-patching needed)

### Unlike the other gems

- Pagy is very modular and does not load any unnecessary code in your app _(see [why...](https://ddnexus.github.io/pagy/how-to#global-configuration))_
- It doesn't impose limits on your code even with collections|scopes that already used `limit` and `offset` _(see [how...](https://ddnexus.github.io/pagy/how-to#paginate-a-pre-offsetted-and-pre-limited-collection))_
- It works with fast helpers OR easy to edit templates _(see [more...](https://ddnexus.github.io/pagy/how-to#using-templates))_
- It raises real `Pagy::OverflowError` exceptions that you can rescue from _(see [how...](https://ddnexus.github.io/pagy/how-to#handling-pagyoutofrangeerror-exception))_ or use the [overflow extra](http://ddnexus.github.io/pagy/extras/overflow) for a few ready to use common behaviors
- It does not impose any difficult-to-override logic or output _(see [why...](https://ddnexus.github.io/pagy/index#really-easy-to-customize))_

### Better Components

Besides the classic pagination offered by the `pagy_nav` helpers, you can also use a couple of more performant alternatives:

- [pagy_nav_js](http://ddnexus.github.io/pagy/api/javascript#javascript-navs): A faster and lighter classic looking UI, rendered on the client side with optional responsiveness:<br>![bootstrap_nav_js](docs/assets/images/bootstrap_nav_js-w.png)

- [pagy_combo_nav_js](http://ddnexus.github.io/pagy/api/javascript#javascript-combo-navs): The fastest and lightest alternative UI _(48x faster, 48x lighter and 2,270x more efficient than Kaminari)_ that combines navigation and pagination info in a single compact element:<br>![bootstrap_combo_nav_js](docs/assets/images/bootstrap_combo_nav_js-w.png)

</details>

## 😎 It's easy to use and customize

<details>

<summary>Code for basic pagination...</summary>

```rb
# Override the pagy default with your own in the pagy initializer...
Pagy::DEFAULT[:items] = 10        # items per page
Pagy::DEFAULT[:size]  = [1,4,4,1] # nav bar links

# In some controller...
include Pagy::Backend

# In some helper...
include Pagy::Frontend

# Wrap your collection with pagy in some action...
@pagy, @records = pagy(Product.my_collection)
# Or override some default only for that instance...
@pagy, @records = pagy(Product.my_collection, items: 15)
```

```erb
<%# Render the navigation bar in some view with a fast helper... %>
<%== pagy_nav(@pagy) %>

<%# Or render it with your own template... %>
<%== render partial: 'pagy/my_nav', locals: {pagy: @pagy} %>
```

_(See [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start))_

</details>

<details>

<summary>Code for CSS frameworks...</summary>

```rb
# Require a CSS framework extra in the initializer (e.g. bootstrap)...
require 'pagy/extras/bootstrap'
```

```erb
<%# Use it in some view in place of the unstyled helper... %>
<%== pagy_bootstrap_nav(@pagy) %>
```

_(See the [bootstrap extra](http://ddnexus.github.io/pagy/extras/bootstrap))_

</details>

<details>

<summary>Code for special collections...</summary>

```rb
# Require a backend extra in the initializer (e.g. elasticsearch_rails)...
require 'pagy/extras/elasticsearch_rails'

# In some model...
extend Pagy::ElasticsearchRails

# In some action...
response         = Article.pagy_search(params[:q])
@pagy, @response = pagy_elasticsearch_rails(response)
```

_(See the [elasticsearch_rails extra](http://ddnexus.github.io/pagy/extras/elasticsearch_rails))_

</details>

<details>

<summary>Code for client-side|JSON rendering...</summary>

```ruby
# Require the metadata extra in the initializer...
require 'pagy/extras/metadata'

# in some action...
pagy, records = pagy(Product.all)
render json: { data: records,
               pagy: pagy_metadata(pagy, ...) }
```

_(See the [metadata extra](http://ddnexus.github.io/pagy/extras/metadata))_

</details>

<details>

<summary>Code for headers pagination for APIs...</summary>

```ruby
# Require the headers extra in the initializer...
require 'pagy/extras/headers'

# in some action...
pagy, records = pagy(Product.all)
pagy_headers_merge(pagy)
render json: records
```

_(See the [headers extra](http://ddnexus.github.io/pagy/extras/headers))_

</details>

<details>

<summary>List of all the extras...</summary><br>

Extras add special options and manage different components, behaviors, Frontend or Backend environments... usually by just requiring them (and optionally overriding some default).

### Backend Extras

- [arel](http://ddnexus.github.io/pagy/extras/arel): Better performance of grouped ActiveRecord collections
- [array](http://ddnexus.github.io/pagy/extras/array): Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
- [countless](http://ddnexus.github.io/pagy/extras/countless): Paginate without the need of any count, saving one query per rendering
- [elasticsearch_rails](http://ddnexus.github.io/pagy/extras/elasticsearch_rails): Paginate `ElasticsearchRails` response objects
- [headers](http://ddnexus.github.io/pagy/extras/headers): Add RFC-8288 compliant http response headers (and other helpers) useful for API pagination
- [meilisearch](http://ddnexus.github.io/pagy/extras/meilisearch): Paginate `Meilisearch` results
- [metadata](http://ddnexus.github.io/pagy/extras/metadata): Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.
- [searchkick](http://ddnexus.github.io/pagy/extras/searchkick): Paginate `Searchkick::Results` objects

### Frontend Extras

- [bootstrap](http://ddnexus.github.io/pagy/extras/bootstrap): Add nav, nav_js and combo_nav_js helpers for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination)
- [bulma](http://ddnexus.github.io/pagy/extras/bulma): Add nav, nav_js and combo_nav_js helpers for the Bulma CSS [pagination component](https://bulma.io/documentation/components/pagination)
- [foundation](http://ddnexus.github.io/pagy/extras/foundation): Add nav, nav_js and combo_nav_js helpers for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html)
- [materialize](http://ddnexus.github.io/pagy/extras/materialize): Add nav, nav_js and combo_nav_js helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html)
- [navs](http://ddnexus.github.io/pagy/extras/navs): Add nav_js and combo_nav_js unstyled helpers
- [semantic](http://ddnexus.github.io/pagy/extras/semantic): Add nav, nav_js and combo_nav_js helpers for the Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html)
- [tailwind](http://ddnexus.github.io/pagy/extras/tailwind): Extra styles for [Tailwind CSS](https://tailwindcss.com)
- [uikit](http://ddnexus.github.io/pagy/extras/uikit): Add nav, nav_js and combo_nav_js helpers for the UIkit [pagination component](https://getuikit.com/docs/pagination)

### Extra Features and Tools

- [Pagy::Console](https://ddnexus.github.io/pagy/api/console): Try any pagy feature or helper right in the irb/rails console even without any app or config
- [gearbox](https://ddnexus.github.io/pagy/extras/gearbox): Automatically change the number of items per page depending on the page number
- [i18n](http://ddnexus.github.io/pagy/extras/i18n): Use the `I18n` gem instead of the pagy-i18n implementation
- [items](http://ddnexus.github.io/pagy/extras/items): Allow the client to request a custom number of items per page with an optional selector UI
- [overflow](http://ddnexus.github.io/pagy/extras/overflow): Allow for easy handling of overflowing pages
- [standalone](http://ddnexus.github.io/pagy/extras/standalone): Use pagy without any request object, nor Rack environment/gem, nor any defined `params` method
- [support](http://ddnexus.github.io/pagy/extras/support): Extra support for features like: incremental, auto-incremental and infinite pagination
- [trim](http://ddnexus.github.io/pagy/extras/trim): Remove the `page=1` param from the first page link

</details>

See also the [How To Page](http://ddnexus.github.io/pagy/how-to)

## 🤓 It's very well documented and supported

<details>

<summary><b>Watch some great screencast...</b></summary>

### GoRails Screencast

[![GoRails Screencast](docs/assets/images/gorails-thumbnail-w360.png)](https://gorails.com/episodes/pagination-with-pagy-gem?autoplay=1)

**Notice**: the `pagy_nav_bootstrap` helper used in the screencast has been renamed as `pagy_bootstrap_nav` since version 2.0

### Mike Rogers Screencast

[![How To Paginate A Collection Using Pagy](docs/assets/images/mike-rogers-w360.jpg)](https://youtu.be/aILtxj_LVuA)

### SupeRails Screencast

[![Ruby on Rails #19 gem Pagy - Ultimate Guide](docs/assets/images/superails-w360.jpg)](https://youtu.be/1tsWL4EjhMo)

### Raul Palacio Screencast (Spanish)

[![Raul Palacio Screncast](docs/assets/images/raul-palacio-w360.jpg)](https://youtu.be/_j3gtKf5rRs)

</details>

<details>

<summary><b>Read some interesting post and tutorial...</b></summary>

- [Migrating from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/migration-guide) (practical guide)
- [Detailed Gems Comparison](https://ddnexus.github.io/pagination-comparison/gems.html) (charts and analysis)
- [Benchmarks and Memory Profiles Source](http://github.com/ddnexus/pagination-comparison) (Rails app repository)
- [Faster Pagination with Pagy](https://viblo.asia/p/faster-pagination-with-pagy-Eb85ok9W52G) introductory tutorial by Sirajus Salekin
- [Pagy with Templates Minipost](https://www.aloucaslabs.com/miniposts/how-to-install-pagy-gem-with-a-custom-pagination-template-on-a-ruby-on-rails-application) by aloucas
- [Pagination with Pagy](https://www.imaginarycloud.com/blog/paginating-ruby-on-rails-apps-with-pagy) by Tiago Franco
- [Quick guide for Pagy with Sinatra and Sequel](https://medium.com/@vfreefly/how-to-use-pagy-with-sequel-and-sinatra-157dfec1c417) by Victor Afanasev
- [Integrating Pagy with Hanami](http://katafrakt.me/2018/06/01/integrating-pagy-with-hanami/) by Paweł Świątkowski
- [Stateful Tabs with Pagy](https://www.imaginarycloud.com/blog/how-to-paginate-ruby-on-rails-apps-with-pagy) by Chris Seelus
- [Handling Pagination When POSTing Complex Search Forms](https://benkoshy.github.io/2019/10/09/paginating-search-results-with-a-post-request.html) by Ben Koshy.
- [How to Override pagy methods only in specific circumstances](https://benkoshy.github.io/2020/02/01/overriding-pagy-methods.html) by Ben Koshy.
- [How to make your pagination links sticky + bounce at the bottom of your page](https://benkoshy.github.io/2020/09/15/sticky-menu.html) by Ben Koshy.
- [Endless Scroll / Infinite Loading with Turbo Streams & Stimulus](https://www.stefanwienert.de/blog/2021/04/17/endless-scroll-with-turbo-streams/) by Stefan Wienert
- [日本語の投稿](https://qiita.com/search?q=pagy)
- [한국어 튜토리얼](https://kbs4674.tistory.com/72)

</details>

<details>

<summary><b>Read the documentation...</b></summary>

- [Quick Start](https://ddnexus.github.io/pagy/how-to#quick-start)
- [Documentation](https://ddnexus.github.io/pagy/index)
- [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md)

</details>

<details>

<summary><b>Ask for support...</b></summary>

- [Live Support on Gitter](https://gitter.im/ruby-pagy/Lobby)
- [Pagy Issues](https://github.com/ddnexus/pagy/issues)

</details>

<details>

<summary><b>FAQs (Frequently Asked Questions)</b></summary>
<br>

**What is pagination? Why do I need it?**

There is a hard limit on the number of records a server can deliver:

```rb
def index
    @users = User.all # all 10,000,000 users
                      # haha good luck!
end
```

Pagination allows you to break-up records (or any collection) into small digestable chunks - i.e. "pages". i.e. it is highly unlikely that human beings will want to review all 10,000,000 records all at once, or be capable of doing so. We can ask them to thumb through all the user records as if they were pages in a book, split up by, say, 25 users per page. `Pagy` allows you to do this, writing barely a lick of code on back and front ends.

**What do I get if I use `Pagy`?**

This depends on whether you want HTML returned, or json returned.

![Pagy-end-result](docs/assets/images/pagination-example.png)

**1. HTML returned:** The image above shows pagination links styled according to the bootstrap framework. The UI is eminently customisable (according to your framework of choice: bulma, semantic, bootstrap etc.), or otherwise. Functionality, is also very customisable.

**2. JSON returned:** If you are developing a back-end API with a front-end framework like React / Vue you can choose between the following to help display or handle pagination: 

(i) using a [client-side javascript navigation component](https://ddnexus.github.io/pagy/api/javascript), or 

(ii) you can roll your own using the [meta-data extra](https://ddnexus.github.io/pagy/extras/metadata) (which allows you to easily write your own code to go to which ever page you want etc.). This is an option if your client is non-human.

(iii) Finally, if you do not want pagination logic to exist in response bodies, you can choose to put them in response headers using the [headers extra](https://ddnexus.github.io/pagy/extras/headers). This is also an option for non-human clients.

</details>

## 📦 Repository Info

<details>

<summary><b>What's new in 5.0</b></summary>

- __This version requires `ruby 2.5+`. For `ruby <2.5` use `pagy 3+` (see the [pagy3 branch](https://github.com/ddnexus/pagy/tree/pagy3))__
- **New**: added `gearbox` extra to automatically change the number of items depending on the page number.
- Removed support for 4.0 deprecations (see the [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md))
- Big code restyling with improved performance, readability and rubocop compliance.

</details>

<details>

<summary><b>How to contribute</b></summary>

- Pull Requests are welcome!
- For simple contribution you can quickly check your changes with the [Pagy::Console](https://ddnexus.github.io/pagy/api/console) or with the single file [pagy_standalone_app.ru](https://github.com/ddnexus/pagy/blob/master/apps/pagy_standalone_app.ru).
- For more complex contributions you can use the [docker development environment](https://github.com/ddnexus/pagy/tree/master/docker) or your own environment of course.
- If you Create A Pull Request, please ensure that the "All checks have passed" indicator gets green light on the Pull Request page. That means that the tests passed and Codecov and Rubocop are happy.

</details>

<details>

<summary><b>Versioning</b></summary>

- Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/). Please, check the [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md) for breaking changes introduced by mayor versions.

</details>

<details>

<summary><b>Branches</b></summary>

- The `master` branch is the latest rubygem-published release. It also contains docs and comment changes that don't affect the published code. It is never force-pushed.
- The `dev` branch is the development branch with the new code that will be merged in the next release. It could be force-pushed.
- Expect any other branch to be experimental, force-pushed, rebased and/or deleted even without merging.

</details>

## 💞 Related Projects

- [pagy-cursor](https://github.com/Uysim/pagy-cursor) An early stage project that implements cursor pagination for AR
- [grape-pagy](https://github.com/bsm/grape-pagy) Pagy pagination for the [grape](https://github.com/ruby-grape/grape) API framework

## 👏 Credits

Many thanks to:

- [GoRails](https://gorails.com) for the great [Pagy Screencast](https://gorails.com/episodes/pagination-with-pagy-gem?autoplay=1) and their top notch [Rails Episodes](https://gorails.com/episodes)
- [Imaginary Cloud](https://www.imaginarycloud.com) for continually publishing high-interest articles and helping to share Pagy when it just started
- [JetBrains](http://www.jetbrains.com?from=https%3A%2F%2Fgithub.com%2Fddnexus%2Fpagy) for their free OpenSource license
- [The Contributors](https://github.com/ddnexus/pagy/graphs/contributors) for all the smart code and suggestions merged in the project
- [The Stargazers](https://github.com/ddnexus/pagy/stargazers) for showing their support

## 📃 License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
