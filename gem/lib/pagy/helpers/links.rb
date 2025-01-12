# frozen_string_literal: true

class Pagy
  module Links
    def pagy_links(pagy, **)
      url_str = pagy_page_url(pagy, PAGE_TOKEN, **)
      { first: url_str.sub(PAGE_TOKEN, '1') }.tap do |links|
        links[:prev] = url_str.sub(PAGE_TOKEN, pagy.prev.to_s) if pagy.prev
        links[:next] = url_str.sub(PAGE_TOKEN, pagy.next.to_s) if pagy.next
        links[:last] = url_str.sub(PAGE_TOKEN, pagy.last.to_s) if pagy.class.predict_last?
      end
    end
  end
end
