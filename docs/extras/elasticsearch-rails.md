---
title: Elasticsearch Rails
---
# Elasticsearch Rails Extra

Paginate `ElasticsearchRails::Results` objects efficiently avoiding expensive object-wrapping and without overriding.

## Synopsys

See [extras](../extras.md) for general usage info.

In a controller:

```ruby
def search
  @pagy, @articles = pagy_elasticsearch_rails(Article.search(params[:q]).records, items: 10)

  render action: "index"
end

# independently paginate some other collections as usual
@pagy_b, @records = pagy(some_scope, ...)
```

## Files

This extra is composed of 1 file:

- [elasticsearch-rails.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/elasticsearch-rails.rb)

## Methods

This extra adds the `pagy_elasticsearch_rails` method to the `Pagy::Backend` to be used in place (or in parallel) of the `pagy` method when you have to paginate a `ElasticsearchRails::Results` object. It also adds a `pagy_elasticsearch_rails_get_variables` sub-method, used for easy customization of variables by overriding.

**Notice**: there is no `pagy_elasticsearch_rails_get_items` method to override, since the items are fetched directly by Elasticsearch Rails.

### pagy_elasticsearch_rails(Model.search(...), vars=nil)

This method is the same as the generic `pagy` method, but specialized for Elasticsearch Rails. (see the [pagy doc](../api/backend.md#pagycollection-varsnil))

### pagy_elastic_search_rails_get_vars(array)

This sub-method is the same as the `pagy_get_vars` sub-method, but it is called only by the `pagy_elasticsearch_rails` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).
