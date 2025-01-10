# frozen_string_literal: true

require_relative '../../test_helper'

describe 'Load search mixins' do
  it 'loads meilisearch mixin' do
    meilisearch_results = Struct.new(:raw_answer).new({ 'hitsPerPage' => 10, 'page' => 2, 'totalHits' => 25 })
    Pagy::Offset::Meilisearch.new_from_meilisearch(meilisearch_results)
  end
  it 'loads elasticsearch_rails mixin' do
    elasticsearch_response = Struct.new(:raw_response, :search).new({ 'hits' => {'total' => 25 } },
                                                                    Struct.new(:options).new({:size => 10, :from => 11}))
    Pagy::Offset::ElasticsearchRails.new_from_elasticsearch_rails(elasticsearch_response)
  end
  it 'loads searchkick mixin' do
    searchkick_results = Struct.new(:options, :total_count).new({ per_page: 10, page: 2 }, 25)
    Pagy::Offset::Searchkick.new_from_searchkick(searchkick_results)
  end
end
