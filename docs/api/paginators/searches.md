---
title: Searches
icon: database
order: -100
expanded: true
categories:
- Backend
- Search Paginators
---

The search paginators are specialized methods for handling `ElasticsearchRails`, `Meilisearch` and `Searchkick` collections.

For example:

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

- `@pagy` can be used with all the frontend helpers
- `@results` are the paginated results

### Methods:

- [pagy_elasticsearch_rails](searches/elasticsearch_rails.md)
- [pagy_meilisearch](searches/meilisearch.md)
- [pagy_searchkick](searches/searchkick.md)
