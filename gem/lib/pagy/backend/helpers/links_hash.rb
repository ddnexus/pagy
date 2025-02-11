# frozen_string_literal: true

# require_relative
class Pagy
  Backend.module_eval do
    def pagy_links_hash(pagy, **)
      url = pagy_page_url(pagy, PAGE_TOKEN, **)
      { first: pagy_page_url(pagy, nil, **) }.tap do |links| # first is present, but the URL omits the nil page param
        links[:previous] = url.sub(PAGE_TOKEN, pagy.previous.to_s) if pagy.previous
        links[:next]     = url.sub(PAGE_TOKEN, pagy.next.to_s)     if pagy.next
        links[:last]     = url.sub(PAGE_TOKEN, pagy.last.to_s)     if pagy.count # offset and not countless
      end
    end
  end
end
