# frozen_string_literal: true

# require_relative
class Pagy
  Backend.class_eval do
    def pagy_links(pagy, **)
      url_str = pagy_page_url(pagy, PAGE_TOKEN, **)
      {}.tap do |links|
        links[:first] = pagy_page_url(pagy, nil, **) # present, but the URL omits the nil page param
        links[:prev]  = url_str.sub(PAGE_TOKEN, pagy.prev.to_s) if pagy.prev
        links[:next]  = url_str.sub(PAGE_TOKEN, pagy.next.to_s) if pagy.next
        links[:last]  = url_str.sub(PAGE_TOKEN, pagy.last.to_s) if pagy.count # offset and not countles
      end
    end
  end
end
