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

## The Ruby Gem for Pagination

<!-- whats_new_start -->
### ✴ What's new in 10.0+ ✴

This version is a complete redesign of the legacy code: its API will be stable for a long time.

- We invented the pagy-exclusive `keynav` pagination, that uses the fastest `keyset` technique with all the Frontend helpers. The best
  technique for performance and functionality!
- Wicked-fast [Keyset Pagination](https://ddnexus.github.io/pagy/docs/api/keyset/) for big data and infinite pagination.
- Reduce the required config by 99%: no require, no extras, no DEFAULT
- Reduce and improve all the methods, now autoloaded ONLY if you actually use them
- New docs: short and to the point, easy to browse and understand
- New Pagy AI for valuable real-time support
- See the [Changelog](https://ddnexus.github.io/pagy/changelog) for breaking changes
<!-- whats_new_end -->

---

### 🚀 It was already pretty good in v3...

[<img src="docs/assets/images/ips-chart.png" title="~40x Faster!">](https://ddnexus.github.io/pagination-comparison/gems.html#ips-benchmark) [<img src="docs/assets/images/memory-chart.png" title="~36x Lighter!">](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile) [<img src="docs/assets/images/objects-chart.png" title="~35x Simpler!">](https://ddnexus.github.io/pagination-comparison/gems.html#memory-profile) [<img src="docs/assets/images/resource-consumption-chart.png" title="1,410x More Efficient!">](https://ddnexus.github.io/pagination-comparison/gems.html#efficiency-ratio)

## 👍 Now it's better

- It works with any environment and collection 
- It supports all kinds of pagination techniques, CSS frameworks and APIs
- It implements server side or faster client-side rendering
- It has 100% of test coverage for Ruby, HTML and Javascript E2E

## 🧐 Examples

Pagination code:

```rb
# Include it in the controllers (e.g. application_controller.rb)
include Pagy::Backend

# Include it in the helpers (e.g. application_helper.rb)
include Pagy::Frontend

# Wrap your collections with one of many paginators in your actions. For example:
@pagy, @records = pagy_offset(Product.all)
@pagy, @records = pagy_keyset(Product.order(my_order).all)
``` 
Pagination with JSON:API:

```ruby
# JSON:API nested query_params: E.g.: ?page[number]=2&page[size]=100
@pagy, @records = pagy_offset(Product.all, jsonapi: true)
@pagy, @records = pagy_keyset(Product.all, jsonapi: true)
render json: { data:  @records,
               links: pagy_links_hash(@pagy) }
```

JSON-client pagination:

```ruby
render json: { data: @records,
               pagy: pagy_extract_hash(@pagy) }
```

Search code:

```rb
# Extend your models (e.g. application_record.rb)
extend Pagy::Search

# Paginate with pagy:
search = Product.pagy_search(params[:q])
@pagy, @response = pagy_elasticsearch_rails(search)
@pagy, @results  = pagy_meilisearch(search)
@pagy, @results  = pagy_searchkick(search)

# Or get pagy from paginated results:
@results = Product.search(params[:q])
@pagy    = pagy_elasticsearch_rails(@results)
@pagy    = pagy_meilisearch(@results)
@pagy    = pagy_searchkick(@results)
```

Server side rendering:

```erb
<%# Render nav bar helpers with different styles %>
<%== pagy_nav(@pagy) %> 
<%== pagy_bootstrap_nav(@pagy) %>
<%== pagy_bulma_nav(@pagy) %>
```
Client side rendering:

```rb
# pagy.rb initializer
javascript_dir = Rails.root.join('app/javascript')
Pagy::Javascript.sync_source(javascript_dir, 'pagy.mjs') if Rails.env.development?
```
```erb
<%# Render client side nav bar helpers of different types and styles %>
<%== pagy_nav_js(@pagy) %> 
<%== pagy_bootstrap_nav_js(@pagy) %>
<%== pagy_bulma_nav_js(@pagy) %>

<%== pagy_combo_nav_js(@pagy) %>
<%== pagy_bootstrap_combo_nav_js(@pagy) %>
<%== pagy_bulma_combo_nav_js(@pagy) %>
```

View helpers:

| Helper Name                                                                                                                                                                                                                          | Preview (Bootstrap Style shown)                                        |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|
| [`pagy_nav(@pagy)`](https://ddnexus.github.io/pagy/docs/api/frontend)                                                                                                                                                                | ![`pagy_nav`](/docs/assets/images/bootstrap_nav.png)                   |
| [`pagy_nav_js(@pagy)`](https://ddnexus.github.io/pagy/docs/api/javascript/)                                                                                                                                                          | ![`pagy_nav_js`](/docs/assets/images/bootstrap_nav_js.png)             |
| [`pagy_info(@pagy)`](https://ddnexus.github.io/pagy/docs/api/frontend)                                                                                                                                                               | ![`pagy_info`](/docs/assets/images/pagy_info.png)                      |
| [`pagy_combo_nav_js(@pagy)`](https://ddnexus.github.io/pagy/docs/api/javascript/)                                                                                                                                                    | ![`pagy_combo_nav_js`](/docs/assets/images/bootstrap_combo_nav_js.png) |
| [`pagy_limit_selector_js`](https://ddnexus.github.io/pagy/docs/api/javascript/)                                                                                                                                                      | ![`pagy_limit_selector_js`](/docs/assets/images/limit_selector_js.png) |
| [`pagy_nav(@calendar[:year])`](https://ddnexus.github.io/pagy/docs/extras/calendar/)<br/>[`pagy_nav(@calendar[:month])`](https://ddnexus.github.io/pagy/docs/extras/calendar/)<br/> (other units: `:quarter`, `:week`, `:day` and custom) | ![calendar extra](/docs/assets/images/calendar-app.png)                |

## Documentation

- [Migrate from WillPaginate and Kaminari](https://ddnexus.github.io/pagy/docs/migration-guide) (practical guide)
- [Quick Start](https://ddnexus.github.io/pagy/quick-start)
- [Documentation](https://ddnexus.github.io/pagy)
- [How To (quick recipes)](https://ddnexus.github.io/pagy/docs/how-to/)
- [Changelog](https://ddnexus.github.io/pagy/changelog)
- [How Pagy's Docs work?](https://github.com/ddnexus/pagy/blob/master/docs/README.md)

### Support

- [Discussions](https://github.com/ddnexus/pagy/discussions/categories/q-a)
- [Issues](https://github.com/ddnexus/pagy/issues)


## Top 💯 Contributors

<!-- top100_start -->

[<img src="https://avatars.githubusercontent.com/u/100721?v=4" width="40" title="@ddnexus: 1746 contributions">](https://github.com/ddnexus/pagy/commits?author=ddnexus)[<img src="https://avatars.githubusercontent.com/u/15097447?v=4" width="40" title="@benkoshy: 77 contributions">](https://github.com/ddnexus/pagy/commits?author=benkoshy)[<img src="https://avatars.githubusercontent.com/u/11367?v=4" width="40" title="@grosser: 9 contributions">](https://github.com/ddnexus/pagy/commits?author=grosser)[<img src="https://avatars.githubusercontent.com/u/14981592?v=4" width="40" title="@Earlopain: 4 contributions">](https://github.com/ddnexus/pagy/commits?author=Earlopain)[<img src="https://avatars.githubusercontent.com/u/9843321?v=4" width="40" title="@workgena: 4 contributions">](https://github.com/ddnexus/pagy/commits?author=workgena)[<img src="https://avatars.githubusercontent.com/u/32258?v=4" width="40" title="@espen: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=espen)[<img src="https://avatars.githubusercontent.com/u/26239269?v=4" width="40" title="@enzinia: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=enzinia)[<img src="https://avatars.githubusercontent.com/u/132?v=4" width="40" title="@sunny: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=sunny)[<img src="https://avatars.githubusercontent.com/u/235048?v=4" width="40" title="@molfar: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=molfar)[<img src="https://avatars.githubusercontent.com/u/22333?v=4" width="40" title="@bquorning: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=bquorning)[<img src="https://avatars.githubusercontent.com/u/17091381?v=4" width="40" title="@djpremier: 3 contributions">](https://github.com/ddnexus/pagy/commits?author=djpremier)[<img src="https://avatars.githubusercontent.com/u/8125726?v=4" width="40" title="@simonneutert: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=simonneutert)[<img src="https://avatars.githubusercontent.com/u/195636?v=4" width="40" title="@tersor: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=tersor)[<img src="https://avatars.githubusercontent.com/u/1100176?v=4" width="40" title="@thomasklemm: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=thomasklemm)[<img src="https://avatars.githubusercontent.com/u/37790?v=4" width="40" title="@gamafranco: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=gamafranco)[<img src="https://avatars.githubusercontent.com/u/500826?v=4" width="40" title="@tiagotex: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=tiagotex)[<img src="https://avatars.githubusercontent.com/u/112558900?v=4" width="40" title="@wimdavies: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=wimdavies)[<img src="https://avatars.githubusercontent.com/u/7076736?v=4" width="40" title="@renshuki: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=renshuki)[<img src="https://avatars.githubusercontent.com/u/2749593?v=4" width="40" title="@berniechiu: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=berniechiu)[<img src="https://avatars.githubusercontent.com/u/2051199?v=4" width="40" title="@rbngzlv: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=rbngzlv)[<img src="https://avatars.githubusercontent.com/u/101501?v=4" width="40" title="@rainerborene: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=rainerborene)[<img src="https://avatars.githubusercontent.com/u/421488?v=4" width="40" title="@petergoldstein: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=petergoldstein)[<img src="https://avatars.githubusercontent.com/u/50970645?v=4" width="40" title="@sabljak: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=sabljak)[<img src="https://avatars.githubusercontent.com/u/3188392?v=4" width="40" title="@cseelus: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=cseelus)[<img src="https://avatars.githubusercontent.com/u/12479464?v=4" width="40" title="@ashmaroli: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=ashmaroli)[<img src="https://avatars.githubusercontent.com/u/3427854?v=4" width="40" title="@747: 2 contributions">](https://github.com/ddnexus/pagy/commits?author=747)[<img src="https://avatars.githubusercontent.com/u/23448075?v=4" width="40" title="@woller: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=woller)[<img src="https://avatars.githubusercontent.com/u/43544760?v=4" width="40" title="@WilliamHorel: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=WilliamHorel)[<img src="https://avatars.githubusercontent.com/u/1012014?v=4" width="40" title="@okuramasafumi: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=okuramasafumi)[<img src="https://avatars.githubusercontent.com/u/12237543?v=4" width="40" title="@olieidel: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=olieidel)[<img src="https://avatars.githubusercontent.com/u/211?v=4" width="40" title="@olleolleolle: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=olleolleolle)[<img src="https://avatars.githubusercontent.com/u/43936240?v=4" width="40" title="@PedroAugustoRamalhoDuarte: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=PedroAugustoRamalhoDuarte)[<img src="https://avatars.githubusercontent.com/u/2815199?v=4" width="40" title="@pedrocarmona: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=pedrocarmona)[<img src="https://avatars.githubusercontent.com/u/32079912?v=4" width="40" title="@rafaeelaudibert: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rafaeelaudibert)[<img src="https://avatars.githubusercontent.com/u/7660738?v=4" width="40" title="@rafaelmontas: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rafaelmontas)[<img src="https://avatars.githubusercontent.com/u/4824537?v=4" width="40" title="@yenshirak: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=yenshirak)[<img src="https://avatars.githubusercontent.com/u/412056?v=4" width="40" title="@rogermarlow: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rogermarlow)[<img src="https://avatars.githubusercontent.com/u/1478773?v=4" width="40" title="@Tolchi: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Tolchi)[<img src="https://avatars.githubusercontent.com/u/9060346?v=4" width="40" title="@artplan1: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=artplan1)[<img src="https://avatars.githubusercontent.com/u/30351533?v=4" width="40" title="@sk8higher: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=sk8higher)[<img src="https://avatars.githubusercontent.com/u/58137134?v=4" width="40" title="@muhammadnawzad: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=muhammadnawzad)[<img src="https://avatars.githubusercontent.com/u/69295?v=4" width="40" title="@ronald: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=ronald)[<img src="https://avatars.githubusercontent.com/u/10906059?v=4" width="40" title="@achmiral: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=achmiral)[<img src="https://avatars.githubusercontent.com/u/1393996?v=4" width="40" title="@mauro-ni: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=mauro-ni)[<img src="https://avatars.githubusercontent.com/u/462701?v=4" width="40" title="@borama: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=borama)[<img src="https://avatars.githubusercontent.com/u/24856?v=4" width="40" title="@creativetags: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=creativetags)[<img src="https://avatars.githubusercontent.com/u/24826?v=4" width="40" title="@mcary: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=mcary)[<img src="https://avatars.githubusercontent.com/u/93276?v=4" width="40" title="@marckohlbrugge: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=marckohlbrugge)[<img src="https://avatars.githubusercontent.com/u/1753398?v=4" width="40" title="@fluser: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=fluser)[<img src="https://avatars.githubusercontent.com/u/6563823?v=4" width="40" title="@maful: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=maful)[<img src="https://avatars.githubusercontent.com/u/9826538?v=4" width="40" title="@LuukvH: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=LuukvH)[<img src="https://avatars.githubusercontent.com/u/7241024?v=4" width="40" title="@AngelGuerra: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=AngelGuerra)[<img src="https://avatars.githubusercontent.com/u/18153165?v=4" width="40" title="@tr4b4nt: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tr4b4nt)[<img src="https://avatars.githubusercontent.com/u/4953187?v=4" width="40" title="@tiejianluo: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tiejianluo)[<img src="https://avatars.githubusercontent.com/u/28652?v=4" width="40" title="@szTheory: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=szTheory)[<img src="https://avatars.githubusercontent.com/u/22420?v=4" width="40" title="@smoothdvd: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=smoothdvd)[<img src="https://avatars.githubusercontent.com/u/87665329?v=4" width="40" title="@rhodes-david: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=rhodes-david)[<img src="https://avatars.githubusercontent.com/u/5484758?v=4" width="40" title="@radinreth: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=radinreth)[<img src="https://avatars.githubusercontent.com/u/54139019?v=4" width="40" title="@pranavbabu: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=pranavbabu)[<img src="https://avatars.githubusercontent.com/u/884634?v=4" width="40" title="@okliv: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=okliv)[<img src="https://avatars.githubusercontent.com/u/5013677?v=4" width="40" title="@nedimdz: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=nedimdz)[<img src="https://avatars.githubusercontent.com/u/468744?v=4" width="40" title="@msdundar: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=msdundar)[<img src="https://avatars.githubusercontent.com/u/59817964?v=4" width="40" title="@m-abdurrehman: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=m-abdurrehman)[<img src="https://avatars.githubusercontent.com/u/831536?v=4" width="40" title="@dwieringa: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=dwieringa)[<img src="https://avatars.githubusercontent.com/u/29891001?v=4" width="40" title="@jyuvaraj03: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=jyuvaraj03)[<img src="https://avatars.githubusercontent.com/u/6220668?v=4" width="40" title="@YutoYasunaga: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=YutoYasunaga)[<img src="https://avatars.githubusercontent.com/u/65494027?v=4" width="40" title="@iamyujinwon: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=iamyujinwon)[<img src="https://avatars.githubusercontent.com/u/13119624?v=4" width="40" title="@yhk1038: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=yhk1038)[<img src="https://avatars.githubusercontent.com/u/6612882?v=4" width="40" title="@ya-s-u: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=ya-s-u)[<img src="https://avatars.githubusercontent.com/u/13472945?v=4" width="40" title="@yshmarov: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=yshmarov)[<img src="https://avatars.githubusercontent.com/u/190269?v=4" width="40" title="@thattimc: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=thattimc)[<img src="https://avatars.githubusercontent.com/u/7021119?v=4" width="40" title="@thomaschauffour: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=thomaschauffour)[<img src="https://avatars.githubusercontent.com/u/361323?v=4" width="40" title="@snkashis: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=snkashis)[<img src="https://avatars.githubusercontent.com/u/6059188?v=4" width="40" title="@sliminas: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=sliminas)[<img src="https://avatars.githubusercontent.com/u/310909?v=4" width="40" title="@serghost: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=serghost)[<img src="https://avatars.githubusercontent.com/u/149513?v=4" width="40" title="@tulak: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=tulak)[<img src="https://avatars.githubusercontent.com/u/6208777?v=4" width="40" title="@Federico-G: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Federico-G)[<img src="https://avatars.githubusercontent.com/u/18742365?v=4" width="40" title="@egimenos: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=egimenos)[<img src="https://avatars.githubusercontent.com/u/73437?v=4" width="40" title="@elliotlarson: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=elliotlarson)[<img src="https://avatars.githubusercontent.com/u/17459154?v=4" width="40" title="@hungdiep97: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=hungdiep97)[<img src="https://avatars.githubusercontent.com/u/6763624?v=4" width="40" title="@davidwessman: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=davidwessman)[<img src="https://avatars.githubusercontent.com/u/813150?v=4" width="40" title="@david-a-wheeler: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=david-a-wheeler)[<img src="https://avatars.githubusercontent.com/u/1169363?v=4" width="40" title="@daniel-rikowski: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=daniel-rikowski)[<img src="https://avatars.githubusercontent.com/u/8194848?v=4" width="40" title="@connie-feng: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=connie-feng)[<img src="https://avatars.githubusercontent.com/u/83706?v=4" width="40" title="@MrMoins: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=MrMoins)[<img src="https://avatars.githubusercontent.com/u/67093?v=4" width="40" title="@excid3: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=excid3)[<img src="https://avatars.githubusercontent.com/u/5347394?v=4" width="40" title="@cellvinchung: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=cellvinchung)[<img src="https://avatars.githubusercontent.com/u/4116980?v=4" width="40" title="@brunoocasali: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=brunoocasali)[<img src="https://avatars.githubusercontent.com/u/42350151?v=4" width="40" title="@branson-simplethread: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=branson-simplethread)[<img src="https://avatars.githubusercontent.com/u/19940878?v=4" width="40" title="@BrandonKlotz: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=BrandonKlotz)[<img src="https://avatars.githubusercontent.com/u/12526288?v=4" width="40" title="@benjaminwols: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=benjaminwols)[<img src="https://avatars.githubusercontent.com/u/3390330?v=4" width="40" title="@Atul9: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=Atul9)[<img src="https://avatars.githubusercontent.com/u/1328587?v=4" width="40" title="@amenon: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=amenon)[<img src="https://avatars.githubusercontent.com/u/482867?v=4" width="40" title="@artinboghosian: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=artinboghosian)[<img src="https://avatars.githubusercontent.com/u/58791514?v=4" width="40" title="@antonzaharia: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=antonzaharia)[<img src="https://avatars.githubusercontent.com/u/43855653?v=4" width="40" title="@PyrinAndrii: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=PyrinAndrii)[<img src="https://avatars.githubusercontent.com/u/1060?v=4" width="40" title="@andrew: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=andrew)[<img src="https://avatars.githubusercontent.com/u/7662492?v=4" width="40" title="@AliOsm: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=AliOsm)[<img src="https://avatars.githubusercontent.com/u/147130?v=4" width="40" title="@AbelToy: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=AbelToy)[<img src="https://avatars.githubusercontent.com/u/1453563?v=4" width="40" title="@loed-idzinga: 1 contribution">](https://github.com/ddnexus/pagy/commits?author=loed-idzinga)
<!-- top100_end -->

<br/>

## 👏 Credits

Many thanks to:

- [Ben Koshy](https://github.com/benkoshy) for his contributions to the documentation, user support and interaction with external
  frameworks
- [JetBrains](http://www.jetbrains.com?from=https%3A%2F%2Fgithub.com%2Fddnexus%2Fpagy) for their free OpenSource license project
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
