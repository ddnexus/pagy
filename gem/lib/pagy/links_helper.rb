# frozen_string_literal: true

class Pagy
  module LinksHelper
    def pagy_links(pagy, **)
      url_str = pagy_page_url(pagy, PAGE_TOKEN, **)
      { first: url_str.sub(PAGE_TOKEN, '1') }.tap do |links|
        links[:next] = url_str.sub(PAGE_TOKEN, pagy.next.to_s) if pagy.next
        next if defined?(::Pagy::Keyset) && pagy.is_a?(Keyset)

        links[:prev] = url_str.sub(PAGE_TOKEN, pagy.prev.to_s) if pagy.prev
        links[:last] = url_str.sub(PAGE_TOKEN, pagy.last.to_s) if pagy.last \
        && !(defined?(::Pagy::Offset::Countless) && pagy.is_a?(Offset::Countless))
      end.slice(:first, :prev, :next, :last)
    end
  end
end
