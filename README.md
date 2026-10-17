<span>[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=Pagy&labelColor=1f7a1f&color=2aa22a)](https://rubygems.org/gems/pagy)</span> <span>
[![Supported Rubies](https://img.shields.io/badge/Ruby-EOL-ruby.svg?colorA=99004d&colorB=cc0066)](https://endoflife.date/ruby)</span> <span>
[![API Test](https://github.com/ddnexus/pagy/actions/workflows/api-test.yml/badge.svg?branch=master)](https://github.com/ddnexus/pagy/actions/workflows/api-test.yml)</span> <span>
[![E2E Test](https://github.com/ddnexus/pagy/actions/workflows/e2e-test.yml/badge.svg?branch=master)](https://github.com/ddnexus/pagy/actions/workflows/e2e-test.yml)</span> <span>
![Coverage](https://img.shields.io/badge/Coverage-100%25-coverage.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
![Rubocop Status](https://img.shields.io/badge/Rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
[![MIT license](https://img.shields.io/badge/License-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)</span> <span>
[![Commits](https://img.shields.io/github/commit-activity/y/ddnexus/pagy.svg?label=Commits&colorA=004d99&colorB=0073e6)](https://github.com/ddnexus/pagy/commits/master/)</span> <span>
[![Downloads](https://img.shields.io/gem/dt/pagy.svg?label=Downloads&colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/pagy)</span> <span>
[![Stars](https://shields.io/github/stars/ddnexus/pagy?style=social)](https://github.com/ddnexus/pagy/stargazers)</span> <span>
[![Gurubase](https://img.shields.io/badge/Gurubase-Ask%20Pagy%20AI-006BFF)](https://gurubase.io/g/pagy)</span>

#

<h2><img src="assets/images/pagy-the-frog.png" alt="💚" width="75" style="vertical-align:bottom;"><br/>Pagy the leaping gem!</h2>

_Agnostic pagination in plain Ruby_

<br/>

> [!TIP]
> ⭐ If you like Pagy, please support it with a Star! ⭐

<br/>

<!-- whats_new_start -->

### Version 43

We needed a leap version to unequivocally signal that it's not just a major version: it's a complete redesign of the legacy code at all levels, usage and API included.

**Why 43?** Because it's exactly one step beyond _"The answer to the ultimate question of life, the Universe, and everything."_ 😉

#### Improvements

This version introduces several enhancements, such as new `:countish` and `:keynav_js` paginators and improved automation and configuration processes, reducing setup requirements by 99%. The update also includes a simpler API and new interactive development tools, making it a comprehensive upgrade from previous versions.

- **New [:countish](https://ddnexus.github.io/pagy/toolbox/paginators/countish) Paginator**
  - Faster than OFFSET and supporting the full UI
- **New [Keynav](https://ddnexus.github.io/pagy/toolbox/paginators/keynav_js) Pagination**
  - The pagy-exclusive technique using the fastest [keyset](https://ddnexus.github.io/pagy/toolbox/paginators/keyset) pagination alongside all frontend helpers.
- **New interactive dev-tools**
  - New [PagyWand](https://ddnexus.github.io/pagy/resources/stylesheets/#pagy-wand) to integrate the pagy CSS with your app themes.
  - New **Pagy AI** available right inside your own app.
- **Intelligent automation**
  - [Configuration](https://ddnexus.github.io/pagy/toolbox/configuration/initializer) requirements reduced by 99%.
  - Simplified [JavaScript](https://ddnexus.github.io/pagy/resources/javascript) setup.
  - Automatic [I18n](https://ddnexus.github.io/pagy/resources/i18n) loading.
- **[Simpler API](https://github.com/ddnexus/pagy#examples)**
  - You solely need the [pagy](https://ddnexus.github.io/pagy/toolbox/paginators) method and the [@pagy](https://ddnexus.github.io/pagy/toolbox/helpers) instance to paginate any collection and use any navigation tag and helper.
  - Methods are autoloaded only if used, and consume no memory otherwise.
  - Methods have narrower scopes and can be [overridden](https://ddnexus.github.io/pagy/guides/how-to#override-pagy-methods) without deep knowledge.
- **New [documentation](https://ddnexus.github.io/pagy/guides/quick-start)**
  - Very concise, straightforward, and easy to navigate and understand.

### Upgrade to 43

See the [Upgrade Guide](https://ddnexus.github.io/pagy/guides/upgrade-guide/)

<!-- whats_new_end -->

Take a look at the [Examples](#-examples) for a quick overview of the new API.

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> v3 was already quite snappy...

[<img src="assets/images/ips-chart.png" title="~40x Faster!" width="500">](https://ddnexus.github.io/pagination-comparison/gems.html#ips-benchmark)<br>
[<img src="assets/images/memory-chart.png" title="~36x Lighter!" width="500">](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)<br>
[<img src="assets/images/objects-chart.png" title="~35x Simpler!" width="500">](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile)<br>
[<img src="assets/images/resource-consumption-chart.png" title="1,410x More Efficient!" width="500">](https://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio)

<br/>

### ... and now it's more, with less.

- Compatible with all environments and collection types
- It can use OFFSET, COUNTISH, COUNTLESS, KEYSET, KEYNAV, SEARCH, and CALENDAR pagination techniques
- It supports server-side rendering or faster client-side rendering for popular CSS frameworks and APIs
- It autoloads ONLY the methods that you actually use, with almost zero configuration
- It boasts 100% test coverage for Ruby, HTML, and JavaScript end-to-end (E2E)

<br/>

> [!TIP]
> ⭐ If you like Pagy, please support it with a Star! ⭐

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Examples

##### Pagination code

```rb
# Include pagy in your code (usually application_controller.rb)
include Pagy::Method

# Offset-based pagination
@pagy, @records = pagy(:offset, Product.all)

# Keyset-based pagination (fastest technique)
@pagy, @records = pagy(:keyset, Product.order(my_order).all)

# Paginate your collection with one of several paginators
@pagy, @records = pagy(...)
```

_See all the available [paginators](https://ddnexus.github.io/pagy/toolbox/paginators/#paginators)_

##### JSON:API pagination

```ruby
# JSON:API nested query string. E.g.: ?page[number]=2&page[size]=100
@pagy, @records = pagy(:offset, Product.all, jsonapi: true)
@pagy, @records = pagy(:keyset, Product.order(my_order).all, jsonapi: true)
render json: { links: @pagy.urls_hash, data: @records }
```

##### JSON-client pagination

```ruby
render json: { pagy: @pagy.data_hash, data: @records }
```

##### Search server pagination

Available paginators: `:elasticsearch_rails`, `:meilisearch`, `:rails_active_search`, `:searchkick`, `:typesense_rails`

```rb
# Extend your models (e.g. application_record.rb)
extend Pagy::Search

# Paginate with pagy:
search           = Product.pagy_search(params[:q])
@pagy, @response = pagy(:a_search_paginator, search)

# Or get pagy from paginated results:
@results = Product.search(params[:q])
@pagy    = pagy(:a_search_paginator, @results)
```

##### Calendar pagination

Combine `time-range` and `offset` pagination.

_(Available time units: year, quarter, month, week, and day)_

<img src="assets/images/calendar-app.png" width="450"><br/>

```ruby
@calendar, @pagy, @records = pagy(:calendar, collection, year: {}, month: {}, offset: {})
```

```ERB
<%== @calendar[:year].series_nav(:bootstrap) %>
<%== @calendar[:month].series_nav(:bootstrap) %>
<%== @pagy.info_tag %>
...
<%== @pagy.series_nav(:bootstrap) %>
```

##### Server side rendering

##### `series_nav`

Default `:pagy`, `:bootstrap` and `:bulma` styles shown.

<img src="assets/images/pagy-series_nav.png" width="310"><br/>
<img src="assets/images/bootstrap-series_nav.png" width="255"><br/>
<img src="assets/images/bulma-series_nav.png" width="342"><br/>

```erb
<!-- Render server side nav bar helpers with different html and styles -->
<%== @pagy.series_nav %> <!-- pagy style -->
<%== @pagy.series_nav(:bootstrap) %>
<%== @pagy.series_nav(:bulma) %>
```

##### Client side rendering

```rb
# pagy.rb initializer
javascript_dir = Rails.root.join('app/javascript')
Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?
```

##### `series_nav_js`

**Faster and responsive**

Dynamically fills the container width.

<img src="assets/images/pagy-series_nav_js-7.png" width="312"><br/>
<img src="assets/images/pagy-series_nav_js-9.png" width="390"><br/>

```erb
<!-- Render client side nav bar helpers with different html and styles -->
<%== @pagy.series_nav_js %> <!-- pagy style -->
<%== @pagy.series_nav_js(:bootstrap) %>
<%== @pagy.series_nav_js(:bulma) %>
```

##### `input_nav_js`

**Fastest!** Combines navigation and info in minimum space.

<img src="assets/images/pagy-input_nav_js.png" width="229"><br/>

```erb
<!-- Render client side nav input helpers with different html and styles -->
<%== @pagy.input_nav_js %> <!-- pagy style -->
<%== @pagy.input_nav_js(:bootstrap) %>
<%== @pagy.input_nav_js(:bulma) %>
```

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Dev Tools

Integrate pagy with your app's themes interactively ([watch demo](https://youtu.be/GhhNRrVG9jg)), and ask specific questions to the Pagy AI __right in your app__! You need only a single line in your page/layout `head` to get the Pagy Wand and the Pagy AI:

```erb
<%== Pagy.dev_tools %>
```

<img src="assets/images/dev-tools.png" width="450"><br/>

See [Dev Tools](https://ddnexus.github.io/pagy/sandbox/dev_tools/)

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Support and Docs

- [Quick Start](https://ddnexus.github.io/pagy/guides/quick-start)
- [How To (quick recipes)](https://ddnexus.github.io/pagy/guides/how-to/)
- [Migrate from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/guides/migration-guide) (practical guide)
- [Discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a)
- [Issues](https://github.com/ddnexus/pagy/issues)
- [Changelog](https://ddnexus.github.io/pagy/changelog)

<br/>

> [!TIP]
> ⭐ If you like Pagy, please support it with a Star! ⭐

<br/>

### Top 🏆 Adopters

<!-- top_adopters_start -->

[<img src="assets/images/top-adopters/docusealco-docuseal.svg" title="Docuseal ⭐ 18,713&#10;Open source DocuSign alternative. Create, fill, and sign digital documents ✍️">](https://github.com/docusealco/docuseal)[<img src="assets/images/top-adopters/opf-openproject.svg" title="Openproject ⭐ 16,411&#10;OpenProject is the leading open source project management software for product, project and portfolio management. A powerful Jira alternative with agile planning, issue tracking, roadmaps, Gantt charts, time tracking, collaboration features, and more. Available on premises or in the cloud. ⭐ Star us on GitHub">](https://github.com/opf/openproject)[<img src="assets/images/top-adopters/spree-spree.svg" title="Spree ⭐ 15,752&#10;Open Source Platform for DTC, B2B Commerce, Marketplaces &amp; Omnichannel. REST APIs, TypeScript SDKs, and production-ready Next.js storefront. Self-host it. Own your data. No vendor lock-in. Zero platform fees.">](https://github.com/spree/spree)[<img src="assets/images/top-adopters/freika-dawarich.svg" title="Dawarich ⭐ 10,669&#10;Your favorite self-hostable alternative to Google Timeline (Google Location History)">](https://github.com/Freika/dawarich)[<img src="assets/images/top-adopters/we-promise-sure.svg" title="Sure ⭐ 10,505&#10;The personal finance app for everyone (by everyone)">](https://github.com/we-promise/sure)[<img src="assets/images/top-adopters/antiwork-gumroad.svg" title="Gumroad ⭐ 9,880&#10;See what sticks">](https://github.com/antiwork/gumroad)[<img src="assets/images/top-adopters/theodinproject-theodinproject.svg" title="Theodinproject ⭐ 4,656&#10;Main website for The Odin Project">](https://github.com/TheOdinProject/theodinproject)[<img src="assets/images/top-adopters/octobox-octobox.svg" title="Octobox ⭐ 4,487&#10;📮 Untangle your GitHub Notifications">](https://github.com/octobox/octobox)[<img src="assets/images/top-adopters/blackcandy-org-blackcandy.svg" title="Blackcandy ⭐ 4,426&#10;A self hosted music streaming server">](https://github.com/blackcandy-org/blackcandy)[<img src="assets/images/top-adopters/pglombardo-passwordpusher.svg" title="PasswordPusher ⭐ 3,220&#10;🔐   Securely share sensitive information with automatic expiration &amp; deletion after a set number of views or duration.  Track who, what and when with full audit logs.">](https://github.com/pglombardo/PasswordPusher)[<img src="assets/images/top-adopters/caninehq-canine.svg" title="Canine ⭐ 2,937&#10;A developer friendly PaaS for your Kubernetes">](https://github.com/CanineHQ/canine)[<img src="assets/images/top-adopters/rubygems-rubygems.org.svg" title="Rubygems.org ⭐ 2,440&#10;The Ruby community&#39;s gem hosting service.">](https://github.com/rubygems/rubygems.org)[<img src="assets/images/top-adopters/otwcode-otwarchive.svg" title="Otwarchive ⭐ 2,266&#10;The Organization for Transformative Works (OTW) - Archive Of Our Own (AO3) Project">](https://github.com/otwcode/otwarchive)[<img src="assets/images/top-adopters/manyfold3d-manyfold.svg" title="Manyfold ⭐ 2,199&#10;A self-hosted digital asset manager for 3d print files.">](https://github.com/manyfold3d/manyfold)[<img src="assets/images/top-adopters/greasyfork-org-greasyfork.svg" title="Greasyfork ⭐ 2,125&#10;An online repository of user scripts.">](https://github.com/greasyfork-org/greasyfork)[<img src="assets/images/top-adopters/openjournals-joss.svg" title="Joss ⭐ 1,926&#10;The Journal of Open Source Software">](https://github.com/openjournals/joss)[<img src="assets/images/top-adopters/bullet-train-co-bullet_train.svg" title="Bullet Train ⭐ 1,890&#10;The Open Source Ruby on Rails SaaS Template">](https://github.com/bullet-train-co/bullet_train)[<img src="assets/images/top-adopters/avo-hq-avo.svg" title="Avo ⭐ 1,811&#10;The Essential Toolkit for building Internal Tools and admin panels with Ruby on Rails">](https://github.com/avo-hq/avo)[<img src="assets/images/top-adopters/ossf-best-practices-badge.svg" title="Best Practices Badge ⭐ 1,366&#10;🏆Open Source Security Foundation (OpenSSF) Best Practices Badge (formerly Core Infrastructure Initiative (CII) Best Practices Badge)">](https://github.com/ossf/best-practices-badge)[<img src="assets/images/top-adopters/shopify-maintenance_tasks.svg" title="Maintenance Tasks ⭐ 1,311&#10;A Rails engine for queueing and managing data migrations.">](https://github.com/Shopify/maintenance_tasks)[<img src="assets/images/top-adopters/openfoodfoundation-openfoodnetwork.svg" title="Openfoodnetwork ⭐ 1,292&#10;Connect suppliers, distributors and consumers to trade local produce.">](https://github.com/openfoodfoundation/openfoodnetwork)[<img src="assets/images/top-adopters/circuitverse-circuitverse.svg" title="CircuitVerse ⭐ 1,275&#10;CircuitVerse Primary Code Base">](https://github.com/CircuitVerse/CircuitVerse)[<img src="assets/images/top-adopters/inertiajs-inertia-rails.svg" title="Inertia Rails ⭐ 1,240&#10;The Rails adapter for Inertia.js.">](https://github.com/inertiajs/inertia-rails)[<img src="assets/images/top-adopters/drhenner-ror_ecommerce.svg" title="Ror Ecommerce ⭐ 1,208&#10;Ruby on Rails Ecommerce platform, perfect for your small business solution.">](https://github.com/drhenner/ror_ecommerce)[<img src="assets/images/top-adopters/tarteelai-quranic-universal-library.svg" title="Quranic Universal Library ⭐ 1,065&#10;A comprehensive collection of Quran resources">](https://github.com/TarteelAI/quranic-universal-library)

…and [13,500+ more public repos](https://github.com/ddnexus/pagy/network/dependents) on GitHub.

<!-- top_adopters_end -->

<br/>

### Top 💯 Contributors

<!-- top100_start -->

[<img src="https://avatars.githubusercontent.com/u/100721?v=4" width="40" title="@ddnexus: 621421 lines in 1876 commits">](https://github.com/ddnexus/pagy/commits?author=ddnexus)[<img src="https://avatars.githubusercontent.com/u/15097447?v=4" width="40" title="@benkoshy: 1725 lines in 84 commits">](https://github.com/ddnexus/pagy/commits?author=benkoshy)[<img src="https://avatars.githubusercontent.com/u/11367?v=4" width="40" title="@grosser: 1426 lines in 11 commits">](https://github.com/ddnexus/pagy/commits?author=grosser)[<img src="https://avatars.githubusercontent.com/u/132?v=4" width="40" title="@sunny: 817 lines in 3 commits">](https://github.com/ddnexus/pagy/commits?author=sunny)[<img src="https://avatars.githubusercontent.com/u/17091381?v=4" width="40" title="@djpremier: 627 lines in 3 commits">](https://github.com/ddnexus/pagy/commits?author=djpremier)[<img src="https://avatars.githubusercontent.com/u/26239269?v=4" width="40" title="@enzinia: 433 lines in 3 commits">](https://github.com/ddnexus/pagy/commits?author=enzinia)[<img src="https://avatars.githubusercontent.com/u/235048?v=4" width="40" title="@molfar: 404 lines in 3 commits">](https://github.com/ddnexus/pagy/commits?author=molfar)[<img src="https://avatars.githubusercontent.com/u/417475?v=4" width="40" title="@lfidnl: 319 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=lfidnl)[<img src="https://avatars.githubusercontent.com/u/9843321?v=4" width="40" title="@workgena: 222 lines in 4 commits">](https://github.com/ddnexus/pagy/commits?author=workgena)[<img src="https://avatars.githubusercontent.com/u/7076736?v=4" width="40" title="@renshuki: 177 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=renshuki)[<img src="https://avatars.githubusercontent.com/u/579103?v=4" width="40" title="@7a6163: 143 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=7a6163)[<img src="https://avatars.githubusercontent.com/u/13472945?v=4" width="40" title="@yshmarov: 130 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=yshmarov)[<img src="https://avatars.githubusercontent.com/u/1169363?v=4" width="40" title="@daniel-rikowski: 109 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=daniel-rikowski)[<img src="https://avatars.githubusercontent.com/u/2749593?v=4" width="40" title="@berniechiu: 107 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=berniechiu)[<img src="https://avatars.githubusercontent.com/u/22333?v=4" width="40" title="@bquorning: 83 lines in 3 commits">](https://github.com/ddnexus/pagy/commits?author=bquorning)[<img src="https://avatars.githubusercontent.com/u/2051199?v=4" width="40" title="@rbngzlv: 82 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=rbngzlv)[<img src="https://avatars.githubusercontent.com/u/1345993?v=4" width="40" title="@lumikcz: 73 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=lumikcz)[<img src="https://avatars.githubusercontent.com/u/3427854?v=4" width="40" title="@747: 66 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=747)[<img src="https://avatars.githubusercontent.com/u/82187643?v=4" width="40" title="@bruno-costanzo: 60 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=bruno-costanzo)[<img src="https://avatars.githubusercontent.com/u/71972054?v=4" width="40" title="@ShyamBorsaniya: 57 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=ShyamBorsaniya)[<img src="https://avatars.githubusercontent.com/u/35310?v=4" width="40" title="@kelso: 48 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=kelso)[<img src="https://avatars.githubusercontent.com/u/9436230?v=4" width="40" title="@Davidzhu001: 48 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=Davidzhu001)[<img src="https://avatars.githubusercontent.com/u/4191494?v=4" width="40" title="@jeffse: 46 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=jeffse)[<img src="https://avatars.githubusercontent.com/u/8354012?v=4" width="40" title="@ikanade: 41 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=ikanade)[<img src="https://avatars.githubusercontent.com/u/195636?v=4" width="40" title="@tersor: 38 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=tersor)[<img src="https://avatars.githubusercontent.com/u/500826?v=4" width="40" title="@tiagotex: 38 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=tiagotex)[<img src="https://avatars.githubusercontent.com/u/3071529?v=4" width="40" title="@kobusjoubert: 38 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=kobusjoubert)[<img src="https://avatars.githubusercontent.com/u/50970645?v=4" width="40" title="@sabljak: 37 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=sabljak)[<img src="https://avatars.githubusercontent.com/u/556268?v=4" width="40" title="@tagliala: 36 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=tagliala)[<img src="https://avatars.githubusercontent.com/u/32258?v=4" width="40" title="@espen: 34 lines in 3 commits">](https://github.com/ddnexus/pagy/commits?author=espen)[<img src="https://avatars.githubusercontent.com/u/29891001?v=4" width="40" title="@jyuvaraj03: 34 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=jyuvaraj03)[<img src="https://avatars.githubusercontent.com/u/9826538?v=4" width="40" title="@LuukvH: 34 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=LuukvH)[<img src="https://avatars.githubusercontent.com/u/1100176?v=4" width="40" title="@thomasklemm: 30 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=thomasklemm)[<img src="https://avatars.githubusercontent.com/u/8125726?v=4" width="40" title="@simonneutert: 29 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=simonneutert)[<img src="https://avatars.githubusercontent.com/u/30351533?v=4" width="40" title="@sk8higher: 26 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=sk8higher)[<img src="https://avatars.githubusercontent.com/u/421488?v=4" width="40" title="@petergoldstein: 25 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=petergoldstein)[<img src="https://avatars.githubusercontent.com/u/147130?v=4" width="40" title="@AbelToy: 22 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=AbelToy)[<img src="https://avatars.githubusercontent.com/u/13119624?v=4" width="40" title="@yhk1038: 22 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=yhk1038)[<img src="https://avatars.githubusercontent.com/u/83706?v=4" width="40" title="@MrMoins: 22 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=MrMoins)[<img src="https://avatars.githubusercontent.com/u/6220668?v=4" width="40" title="@YutoYasunaga: 22 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=YutoYasunaga)[<img src="https://avatars.githubusercontent.com/u/3188392?v=4" width="40" title="@cseelus: 21 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=cseelus)[<img src="https://avatars.githubusercontent.com/u/2506436?v=4" width="40" title="@jivko-chobanov: 21 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=jivko-chobanov)[<img src="https://avatars.githubusercontent.com/u/12526288?v=4" width="40" title="@benjaminwols: 20 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=benjaminwols)[<img src="https://avatars.githubusercontent.com/u/5347394?v=4" width="40" title="@cellvinchung: 20 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=cellvinchung)[<img src="https://avatars.githubusercontent.com/u/752766?v=4" width="40" title="@jonasCyberdude: 20 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=jonasCyberdude)[<img src="https://avatars.githubusercontent.com/u/190269?v=4" width="40" title="@thattimc: 20 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=thattimc)[<img src="https://avatars.githubusercontent.com/u/1418791?v=4" width="40" title="@glenbray: 20 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=glenbray)[<img src="https://avatars.githubusercontent.com/u/58137134?v=4" width="40" title="@muhammadnawzad: 20 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=muhammadnawzad)[<img src="https://avatars.githubusercontent.com/u/7021119?v=4" width="40" title="@thomaschauffour: 19 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=thomaschauffour)[<img src="https://avatars.githubusercontent.com/u/94952098?v=4" width="40" title="@KinWang-2013: 18 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=KinWang-2013)[<img src="https://avatars.githubusercontent.com/u/6527665?v=4" width="40" title="@t0ch1k: 18 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=t0ch1k)[<img src="https://avatars.githubusercontent.com/u/6125?v=4" width="40" title="@Cosmo: 18 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=Cosmo)[<img src="https://avatars.githubusercontent.com/u/14981592?v=4" width="40" title="@Earlopain: 17 lines in 4 commits">](https://github.com/ddnexus/pagy/commits?author=Earlopain)[<img src="https://avatars.githubusercontent.com/u/4824537?v=4" width="40" title="@yenshirak: 16 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=yenshirak)[<img src="https://avatars.githubusercontent.com/u/17851143?v=4" width="40" title="@leonvogt: 16 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=leonvogt)[<img src="https://avatars.githubusercontent.com/u/462701?v=4" width="40" title="@borama: 16 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=borama)[<img src="https://avatars.githubusercontent.com/u/1176145?v=4" width="40" title="@leoplct: 15 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=leoplct)[<img src="https://avatars.githubusercontent.com/u/17837825?v=4" width="40" title="@kursataktas: 14 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=kursataktas)[<img src="https://avatars.githubusercontent.com/u/62210?v=4" width="40" title="@geoffreymcgill: 12 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=geoffreymcgill)[<img src="https://avatars.githubusercontent.com/u/112558900?v=4" width="40" title="@wimdavies: 10 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=wimdavies)[<img src="https://avatars.githubusercontent.com/u/2780?v=4" width="40" title="@andycroll: 8 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=andycroll)[<img src="https://avatars.githubusercontent.com/u/174391530?v=4" width="40" title="@mikepayready: 8 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=mikepayready)[<img src="https://avatars.githubusercontent.com/u/37790?v=4" width="40" title="@gamafranco: 7 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=gamafranco)[<img src="https://avatars.githubusercontent.com/u/67093?v=4" width="40" title="@excid3: 6 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=excid3)[<img src="https://avatars.githubusercontent.com/u/412056?v=4" width="40" title="@rogermarlow: 6 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=rogermarlow)[<img src="https://avatars.githubusercontent.com/u/583995?v=4" width="40" title="@JasonBarnabe: 6 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=JasonBarnabe)[<img src="https://avatars.githubusercontent.com/u/10395940?v=4" width="40" title="@ethancrawford: 6 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=ethancrawford)[<img src="https://avatars.githubusercontent.com/u/32079912?v=4" width="40" title="@rafaeelaudibert: 5 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=rafaeelaudibert)[<img src="https://avatars.githubusercontent.com/u/10076?v=4" width="40" title="@claudiob: 4 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=claudiob)[<img src="https://avatars.githubusercontent.com/u/101501?v=4" width="40" title="@rainerborene: 4 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=rainerborene)[<img src="https://avatars.githubusercontent.com/u/10906059?v=4" width="40" title="@achmiral: 4 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=achmiral)[<img src="https://avatars.githubusercontent.com/u/42350151?v=4" width="40" title="@branson-simplethread: 4 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=branson-simplethread)[<img src="https://avatars.githubusercontent.com/u/16821802?v=4" width="40" title="@jonathanloos: 4 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=jonathanloos)[<img src="https://avatars.githubusercontent.com/u/1530175?v=4" width="40" title="@thedanbob: 4 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=thedanbob)[<img src="https://avatars.githubusercontent.com/u/437470?v=4" width="40" title="@lostapathy: 4 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=lostapathy)[<img src="https://avatars.githubusercontent.com/u/8194848?v=4" width="40" title="@connie-feng: 4 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=connie-feng)[<img src="https://avatars.githubusercontent.com/u/93160109?v=4" width="40" title="@ranvold: 4 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=ranvold)[<img src="https://avatars.githubusercontent.com/u/12479464?v=4" width="40" title="@ashmaroli: 3 lines in 2 commits">](https://github.com/ddnexus/pagy/commits?author=ashmaroli)[<img src="https://avatars.githubusercontent.com/u/87665329?v=4" width="40" title="@rhodes-david: 3 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=rhodes-david)[<img src="https://avatars.githubusercontent.com/u/22420?v=4" width="40" title="@smoothdvd: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=smoothdvd)[<img src="https://avatars.githubusercontent.com/u/1012014?v=4" width="40" title="@okuramasafumi: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=okuramasafumi)[<img src="https://avatars.githubusercontent.com/u/18153165?v=4" width="40" title="@tr4b4nt: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=tr4b4nt)[<img src="https://avatars.githubusercontent.com/u/3390330?v=4" width="40" title="@Atul9: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=Atul9)[<img src="https://avatars.githubusercontent.com/u/7241024?v=4" width="40" title="@AngelGuerra: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=AngelGuerra)[<img src="https://avatars.githubusercontent.com/u/64050?v=4" width="40" title="@gjtorikian: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=gjtorikian)[<img src="https://avatars.githubusercontent.com/u/12237543?v=4" width="40" title="@olieidel: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=olieidel)[<img src="https://avatars.githubusercontent.com/u/54139019?v=4" width="40" title="@pranavbabu: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=pranavbabu)[<img src="https://avatars.githubusercontent.com/u/43936240?v=4" width="40" title="@PedroAugustoRamalhoDuarte: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=PedroAugustoRamalhoDuarte)[<img src="https://avatars.githubusercontent.com/u/891109?v=4" width="40" title="@peter50216: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=peter50216)[<img src="https://avatars.githubusercontent.com/u/632682?v=4" width="40" title="@RyanTG: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=RyanTG)[<img src="https://avatars.githubusercontent.com/u/73866?v=4" width="40" title="@jgarber623: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=jgarber623)[<img src="https://avatars.githubusercontent.com/u/19877847?v=4" width="40" title="@KieraninTehdas: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=KieraninTehdas)[<img src="https://avatars.githubusercontent.com/u/1038959?v=4" width="40" title="@mcauser: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=mcauser)[<img src="https://avatars.githubusercontent.com/u/1322208?v=4" width="40" title="@fkmy: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=fkmy)[<img src="https://avatars.githubusercontent.com/u/86243?v=4" width="40" title="@denny: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=denny)[<img src="https://avatars.githubusercontent.com/u/24856?v=4" width="40" title="@creativetags: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=creativetags)[<img src="https://avatars.githubusercontent.com/u/7660738?v=4" width="40" title="@rafaelmontas: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=rafaelmontas)[<img src="https://avatars.githubusercontent.com/u/7662492?v=4" width="40" title="@AliOsm: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=AliOsm)[<img src="https://avatars.githubusercontent.com/u/43855653?v=4" width="40" title="@PyrinAndrii: 2 lines in 1 commit">](https://github.com/ddnexus/pagy/commits?author=PyrinAndrii)
<!-- top100_end -->

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Credits

Special thanks to:

- [JetBrains](http://www.jetbrains.com?from=https%3A%2F%2Fgithub.com%2Fddnexus%2Fpagy) for their free open source license.
- [Ben Koshy](https://github.com/benkoshy) for his contributions to the documentation, user support and interaction with external frameworks.
- [The Stargazers](https://github.com/ddnexus/pagy/stargazers) for their support.

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Repository Info

<details>

<summary>How to contribute</summary>

See [Contributing](https://github.com/ddnexus/pagy/blob/master/.github/CONTRIBUTING.md)

</details>

<details>

<summary>Versioning</summary>

- Pagy follows the [Semantic Versioning 2.0.0](https://semver.org/). Please check the [Changelog](https://ddnexus.github.io/pagy/changelog) for breaking changes introduced by major versions. Using [pessimistic version constraint](https://guides.rubygems.org/patterns/#pessimistic-version-constraint) in your Gemfile will ensure smooth upgrades.

</details>

<details>

<summary>Branches</summary>

- The `master` branch is the latest rubygem-published release. It also contains docs and comment changes that don't affect the published code. It is never force-pushed.
- The `dev` branch is the development branch with the new code that will be merged in the next release. It could be force-pushed.
- Expect any other branch to be internal, experimental, force-pushed, rebased and/or deleted even without merging.

</details>

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> License

[MIT](https://opensource.org/licenses/MIT)
