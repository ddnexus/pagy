<span>[![Gem Version](https://img.shields.io/gem/v/pagy.svg?label=Pagy&labelColor=1f7a1f&color=2aa22a)](https://rubygems.org/gems/pagy)</span> <span>
[![Ruby](https://img.shields.io/badge/Ruby-EOL-ruby.svg?colorA=99004d&colorB=cc0066)](https://endoflife.date/ruby)</span> <span>
[![Ruby Test](https://github.com/ddnexus/pagy/actions/workflows/ruby-test.yml/badge.svg?branch=master)](https://github.com/ddnexus/pagy/actions/workflows/ruby-test.yml)</span> <span>
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

_Agnostic pagination in plain ruby_

<br/>

<!-- whats_new_start -->

<a href="https://ddnexus.github.io/pagy/sandbox/playground/#demo-app">
  <img src="https://github.com/ddnexus/pagy/raw/dev/assets/images/try-it.svg" width="130">
</a><br><br>

## Version 43.0.0 (leap)

We needed a leap version to unequivocally segnaling that it's not just a major version: it's a complete redesign of the legacy
code at all levels, usage and API included.

**Why 43?** Because it's exactly one step beyond _"The answer to the ultimate question of life, the Universe, and everything."_ 😉

#### Improvements

- **New [Keynav](https://ddnexus.github.io/pagy/toolbox/paginators/keynav_js) Pagination**
  - The pagy-exclusive technique using the fastest [keyset](https://ddnexus.github.io/pagy/toolbox/paginators/keyset) pagination alongside all frontend helpers.
- **New interactive dev-tools**
  - New [PagyWand](https://ddnexus.github.io/pagy/resources/stylesheets/#pagy-wand) to integrate the pagy CSS with your app's themes.
  - New **Pagy AI** available inside docs and your own app.
- **Intelligent automation**
  - [Configuration](https://ddnexus.github.io/pagy/resources/initializer/) requirements reduced by 99%.
  - Simplified [JavaScript](https://ddnexus.github.io/pagy/resources/javascript) setup.
  - Automatic [I18n](https://ddnexus.github.io/pagy/resources/i18n) loading.
- **[Simpler API](https://github.com/ddnexus/pagy#examples)**
  - You solely need the [pagy](https://ddnexus.github.io/pagy/toolbox/paginators) method and the [@pagy](https://ddnexus.github.io/pagy/toolbox/helpers) instance to paginate any collection and
    use any navigation tag and helper.
  - Methods are autoloaded only if used and consume no memory otherwise.
  - Methods have narrower scopes and can be [overridden](https://ddnexus.github.io/pagy/guides/how-to#override-pagy-methods) without deep knowledge.
- **New [documentation](https://ddnexus.github.io/pagy/guides/quick-start)**
  - Very concise, straightforward, easy to navigate and understand.

Take a look at the [Examples](#examples) for a quick overview.
<!-- whats_new_end -->

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> v3 was already quite good...

[<img src="assets/images/ips-chart.png" title="~40x Faster!">](https://ddnexus.github.io/pagination-comparison/gems.html#ips-benchmark) [<img src="assets/images/memory-chart.png" title="~36x Lighter!">](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile) [<img src="assets/images/objects-chart.png" title="~35x Simpler!">](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile) [<img src="assets/images/resource-consumption-chart.png" title="1,410x More Efficient!">](https://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio)

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Now it's more... with less

- Compatible with all environments and collection types
- It can use OFFSET, COUNTLESS, KEYSET, KEYNAV, CALENDAR pagination techniques
- It supports server-side rendering or faster client-side rendering for popular CSS frameworks and APIs.
- It autoloads ONLY the methods that you actually use, with almost zero config
- It boasts 100% test coverage for Ruby, HTML, and JavaScript end-to-end (E2E)

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

```rb
# Extend your models (e.g. application_record.rb)
extend Pagy::Search

# Paginate with pagy:
search           = Product.pagy_search(params[:q])
@pagy, @response = pagy(:elasticsearch_rails, search)
@pagy, @results  = pagy(:meilisearch, search)
@pagy, @results  = pagy(:searchkick, search)

# Or get pagy from paginated results:
@results = Product.search(params[:q])
@pagy    = pagy(:elasticsearch_rails, @results)
@pagy    = pagy(:meilisearch, @results)
@pagy    = pagy(:searchkick, @results)
```

##### Calendar pagination

Combines `time-range` and `offset` pagination.

_(Available time units: year, quarter, month, week, and day)_

<img src="assets/images/calendar-app.png" width="721"><br/>

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
<!-- Render client side nav bar helpers with different html and styles -->
<%== @pagy.series_nav %> <!-- pagy style -->
<%== @pagy.series_nav(:bootstrap) %>
<%== @pagy.series_nav(:bulma) %>
```

##### Client side rendering

```rb
# pagy.rb initializer
javascript_dir = Rails.root.join('app/javascripts')
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
<!-- Render client side nav inout helpers with different html and styles -->
<%== @pagy.input_nav_js %> <!-- pagy style -->
<%== @pagy.input_nav_js(:bootstrap) %>
<%== @pagy.input_nav_js(:bulma) %>
```

### Pagy Wand

Integrate pagy with your app's themes interactively. You need only a single line in your page/layout `head` to get the Pagy Wand and the Pagy AI:

```erb
<%== Pagy.dev_tags %>
```

<img src="assets/images/pagy-wand.png" width="606"><br/>

<a href="https://ddnexus.github.io/pagy/sandbox/playground/#demo-app">
  <img src="https://github.com/ddnexus/pagy/raw/dev/assets/images/try-it.svg" width="130">
</a><br><br>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Support and Docs

- [Quick Start](https://ddnexus.github.io/pagy/guides/quick-start)
- [How To (quick recipes)](https://ddnexus.github.io/pagy/guides/how-to/)
- [Migrate from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/guides/migration-guide) (practical guide)
- [Discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a)
- [Issues](https://github.com/ddnexus/pagy/issues)
- [Changelog](https://ddnexus.github.io/pagy/changelog)

<br/>

### Top 💯 Contributors

<!-- top100_start -->

[<img src="https://avatars.githubusercontent.com/u/100721?v=4" width="40" title="@ddnexus: 1750 contributions">](https://github.com/ddnexus/pagy/commits?author=ddnexus)[<img src="https://avatars.githubusercontent.com/u/15097447?v=4" width="40" title="@benkoshy: 78 contributions">](https://github.com/ddnexus/pagy/commits?author=benkoshy)[<img src="https://avatars.githubusercontent.com/u/11367?v=4" width="40" title="@grosser: 9 contributions">](https://github.com/ddnexus/pagy/commits?author=grosser)[<img src="https://avatars.githubusercontent.com/u/14981592?v=4" width="40" title="@Earlopain: 4 contributions">](https://github.com/ddnexus/pagy/commits?author=Earlopain)[<img src="https://avatars.githubusercontent.com/u/9843321?v=4" width="40" title="@workgena: 4 contributions">](https://github.com/ddnexus/pagy/commits?author=workgena)[<img src="https://avatars.githubusercontent.com/u/32258?v=4" width="40" title="@espen: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=espen)[<img src="https://avatars.githubusercontent.com/u/26239269?v=4" width="40" title="@enzinia: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=enzinia)[<img src="https://avatars.githubusercontent.com/u/132?v=4" width="40" title="@sunny: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=sunny)[<img src="https://avatars.githubusercontent.com/u/235048?v=4" width="40" title="@molfar: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=molfar)[<img src="https://avatars.githubusercontent.com/u/22333?v=4" width="40" title="@bquorning: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=bquorning)[<img src="https://avatars.githubusercontent.com/u/17091381?v=4" width="40" title="@djpremier: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=djpremier)[<img src="https://avatars.githubusercontent.com/u/8125726?v=4" width="40" title="@simonneutert: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=simonneutert)[<img src="https://avatars.githubusercontent.com/u/195636?v=4" width="40" title="@tersor: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=tersor)[<img src="https://avatars.githubusercontent.com/u/1100176?v=4" width="40" title="@thomasklemm: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=thomasklemm)[<img src="https://avatars.githubusercontent.com/u/37790?v=4" width="40" title="@gamafranco: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=gamafranco)[<img src="https://avatars.githubusercontent.com/u/500826?v=4" width="40" title="@tiagotex: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=tiagotex)[<img src="https://avatars.githubusercontent.com/u/112558900?v=4" width="40" title="@wimdavies: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=wimdavies)[<img src="https://avatars.githubusercontent.com/u/7076736?v=4" width="40" title="@renshuki: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=renshuki)[<img src="https://avatars.githubusercontent.com/u/2749593?v=4" width="40" title="@berniechiu: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=berniechiu)[<img src="https://avatars.githubusercontent.com/u/3427854?v=4" width="40" title="@747: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=747)[<img src="https://avatars.githubusercontent.com/u/12479464?v=4" width="40" title="@ashmaroli: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=ashmaroli)[<img src="https://avatars.githubusercontent.com/u/3188392?v=4" width="40" title="@cseelus: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=cseelus)[<img src="https://avatars.githubusercontent.com/u/50970645?v=4" width="40" title="@sabljak: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=sabljak)[<img src="https://avatars.githubusercontent.com/u/421488?v=4" width="40" title="@petergoldstein: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=petergoldstein)[<img src="https://avatars.githubusercontent.com/u/101501?v=4" width="40" title="@rainerborene: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=rainerborene)[<img src="https://avatars.githubusercontent.com/u/4824537?v=4" width="40" title="@yenshirak: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=yenshirak)[<img src="https://avatars.githubusercontent.com/u/2051199?v=4" width="40" title="@rbngzlv: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=rbngzlv)[<img src="https://avatars.githubusercontent.com/u/43544760?v=4" width="40" title="@WilliamHorel: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=WilliamHorel)[<img src="https://avatars.githubusercontent.com/u/1012014?v=4" width="40" title="@okuramasafumi: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=okuramasafumi)[<img src="https://avatars.githubusercontent.com/u/12237543?v=4" width="40" title="@olieidel: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=olieidel)[<img src="https://avatars.githubusercontent.com/u/211?v=4" width="40" title="@olleolleolle: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=olleolleolle)[<img src="https://avatars.githubusercontent.com/u/43936240?v=4" width="40" title="@PedroAugustoRamalhoDuarte: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=PedroAugustoRamalhoDuarte)[<img src="https://avatars.githubusercontent.com/u/2815199?v=4" width="40" title="@pedrocarmona: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=pedrocarmona)[<img src="https://avatars.githubusercontent.com/u/891109?v=4" width="40" title="@peter50216: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=peter50216)[<img src="https://avatars.githubusercontent.com/u/32079912?v=4" width="40" title="@rafaeelaudibert: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rafaeelaudibert)[<img src="https://avatars.githubusercontent.com/u/7660738?v=4" width="40" title="@rafaelmontas: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rafaelmontas)[<img src="https://avatars.githubusercontent.com/u/412056?v=4" width="40" title="@rogermarlow: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rogermarlow)[<img src="https://avatars.githubusercontent.com/u/1478773?v=4" width="40" title="@Tolchi: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Tolchi)[<img src="https://avatars.githubusercontent.com/u/310909?v=4" width="40" title="@serghost: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=serghost)[<img src="https://avatars.githubusercontent.com/u/9060346?v=4" width="40" title="@artplan1: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=artplan1)[<img src="https://avatars.githubusercontent.com/u/23448075?v=4" width="40" title="@woller: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=woller)[<img src="https://avatars.githubusercontent.com/u/30351533?v=4" width="40" title="@sk8higher: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=sk8higher)[<img src="https://avatars.githubusercontent.com/u/58137134?v=4" width="40" title="@muhammadnawzad: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=muhammadnawzad)[<img src="https://avatars.githubusercontent.com/u/69295?v=4" width="40" title="@ronald: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=ronald)[<img src="https://avatars.githubusercontent.com/u/10906059?v=4" width="40" title="@achmiral: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=achmiral)[<img src="https://avatars.githubusercontent.com/u/1393996?v=4" width="40" title="@mauro-ni: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=mauro-ni)[<img src="https://avatars.githubusercontent.com/u/462701?v=4" width="40" title="@borama: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=borama)[<img src="https://avatars.githubusercontent.com/u/24856?v=4" width="40" title="@creativetags: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=creativetags)[<img src="https://avatars.githubusercontent.com/u/24826?v=4" width="40" title="@mcary: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=mcary)[<img src="https://avatars.githubusercontent.com/u/93276?v=4" width="40" title="@marckohlbrugge: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=marckohlbrugge)[<img src="https://avatars.githubusercontent.com/u/1753398?v=4" width="40" title="@fluser: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=fluser)[<img src="https://avatars.githubusercontent.com/u/6563823?v=4" width="40" title="@maful: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=maful)[<img src="https://avatars.githubusercontent.com/u/7241024?v=4" width="40" title="@AngelGuerra: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=AngelGuerra)[<img src="https://avatars.githubusercontent.com/u/18153165?v=4" width="40" title="@tr4b4nt: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tr4b4nt)[<img src="https://avatars.githubusercontent.com/u/4953187?v=4" width="40" title="@tiejianluo: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tiejianluo)[<img src="https://avatars.githubusercontent.com/u/28652?v=4" width="40" title="@szTheory: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=szTheory)[<img src="https://avatars.githubusercontent.com/u/22420?v=4" width="40" title="@smoothdvd: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=smoothdvd)[<img src="https://avatars.githubusercontent.com/u/87665329?v=4" width="40" title="@rhodes-david: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rhodes-david)[<img src="https://avatars.githubusercontent.com/u/5484758?v=4" width="40" title="@radinreth: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=radinreth)[<img src="https://avatars.githubusercontent.com/u/54139019?v=4" width="40" title="@pranavbabu: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=pranavbabu)[<img src="https://avatars.githubusercontent.com/u/884634?v=4" width="40" title="@okliv: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=okliv)[<img src="https://avatars.githubusercontent.com/u/5013677?v=4" width="40" title="@nedimdz: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=nedimdz)[<img src="https://avatars.githubusercontent.com/u/468744?v=4" width="40" title="@msdundar: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=msdundar)[<img src="https://avatars.githubusercontent.com/u/59817964?v=4" width="40" title="@m-abdurrehman: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=m-abdurrehman)[<img src="https://avatars.githubusercontent.com/u/831536?v=4" width="40" title="@dwieringa: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=dwieringa)[<img src="https://avatars.githubusercontent.com/u/29891001?v=4" width="40" title="@jyuvaraj03: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=jyuvaraj03)[<img src="https://avatars.githubusercontent.com/u/6220668?v=4" width="40" title="@YutoYasunaga: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=YutoYasunaga)[<img src="https://avatars.githubusercontent.com/u/65494027?v=4" width="40" title="@iamyujinwon: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=iamyujinwon)[<img src="https://avatars.githubusercontent.com/u/13119624?v=4" width="40" title="@yhk1038: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=yhk1038)[<img src="https://avatars.githubusercontent.com/u/6612882?v=4" width="40" title="@ya-s-u: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=ya-s-u)[<img src="https://avatars.githubusercontent.com/u/13472945?v=4" width="40" title="@yshmarov: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=yshmarov)[<img src="https://avatars.githubusercontent.com/u/9436230?v=4" width="40" title="@Davidzhu001: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Davidzhu001)[<img src="https://avatars.githubusercontent.com/u/190269?v=4" width="40" title="@thattimc: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=thattimc)[<img src="https://avatars.githubusercontent.com/u/7021119?v=4" width="40" title="@thomaschauffour: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=thomaschauffour)[<img src="https://avatars.githubusercontent.com/u/361323?v=4" width="40" title="@snkashis: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=snkashis)[<img src="https://avatars.githubusercontent.com/u/6059188?v=4" width="40" title="@sliminas: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=sliminas)[<img src="https://avatars.githubusercontent.com/u/9826538?v=4" width="40" title="@LuukvH: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=LuukvH)[<img src="https://avatars.githubusercontent.com/u/149513?v=4" width="40" title="@tulak: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tulak)[<img src="https://avatars.githubusercontent.com/u/6208777?v=4" width="40" title="@Federico-G: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Federico-G)[<img src="https://avatars.githubusercontent.com/u/18742365?v=4" width="40" title="@egimenos: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=egimenos)[<img src="https://avatars.githubusercontent.com/u/73437?v=4" width="40" title="@elliotlarson: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=elliotlarson)[<img src="https://avatars.githubusercontent.com/u/17459154?v=4" width="40" title="@hungdiep97: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=hungdiep97)[<img src="https://avatars.githubusercontent.com/u/6763624?v=4" width="40" title="@davidwessman: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=davidwessman)[<img src="https://avatars.githubusercontent.com/u/813150?v=4" width="40" title="@david-a-wheeler: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=david-a-wheeler)[<img src="https://avatars.githubusercontent.com/u/1169363?v=4" width="40" title="@daniel-rikowski: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=daniel-rikowski)[<img src="https://avatars.githubusercontent.com/u/8194848?v=4" width="40" title="@connie-feng: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=connie-feng)[<img src="https://avatars.githubusercontent.com/u/83706?v=4" width="40" title="@MrMoins: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=MrMoins)[<img src="https://avatars.githubusercontent.com/u/67093?v=4" width="40" title="@excid3: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=excid3)[<img src="https://avatars.githubusercontent.com/u/5347394?v=4" width="40" title="@cellvinchung: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=cellvinchung)[<img src="https://avatars.githubusercontent.com/u/4116980?v=4" width="40" title="@brunoocasali: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=brunoocasali)[<img src="https://avatars.githubusercontent.com/u/42350151?v=4" width="40" title="@branson-simplethread: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=branson-simplethread)[<img src="https://avatars.githubusercontent.com/u/19940878?v=4" width="40" title="@BrandonKlotz: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=BrandonKlotz)[<img src="https://avatars.githubusercontent.com/u/12526288?v=4" width="40" title="@benjaminwols: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=benjaminwols)[<img src="https://avatars.githubusercontent.com/u/3390330?v=4" width="40" title="@Atul9: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Atul9)[<img src="https://avatars.githubusercontent.com/u/1328587?v=4" width="40" title="@amenon: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=amenon)[<img src="https://avatars.githubusercontent.com/u/482867?v=4" width="40" title="@artinboghosian: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=artinboghosian)[<img src="https://avatars.githubusercontent.com/u/58791514?v=4" width="40" title="@antonzaharia: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=antonzaharia)[<img src="https://avatars.githubusercontent.com/u/43855653?v=4" width="40" title="@PyrinAndrii: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=PyrinAndrii)[<img src="https://avatars.githubusercontent.com/u/1060?v=4" width="40" title="@andrew: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=andrew)[<img src="https://avatars.githubusercontent.com/u/7662492?v=4" width="40" title="@AliOsm: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=AliOsm)
<!-- top100_end -->

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Credits

Special thanks to:

- [Ben Koshy](https://github.com/benkoshy) for his contributions to the documentation, user support and interaction with external
  frameworks
- [JetBrains](http://www.jetbrains.com?from=https%3A%2F%2Fgithub.com%2Fddnexus%2Fpagy) for their free OpenSource license.
- [The Stargazers](https://github.com/ddnexus/pagy/stargazers) for showing their support

<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> Repository Info

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

<br/>
<br/>

### <span style="font-size: .65em; vertical-align: middle">💚</span> License

[MIT](https://opensource.org/licenses/MIT)
