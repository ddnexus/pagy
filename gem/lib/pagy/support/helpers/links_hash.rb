# frozen_string_literal: true

class Pagy
  class_eval do
    def links_hash(**)
      url = page_url(PAGE_TOKEN, **)
      { first: page_url(nil, **) }.tap do |links| # first is present, but the URL omits the nil page param
        links[:previous] = url.sub(PAGE_TOKEN, @previous.to_s) if @previous
        links[:next]     = url.sub(PAGE_TOKEN, @next.to_s)     if @next
        links[:last]     = url.sub(PAGE_TOKEN, @last.to_s)     if @count # offset and not countless
      end
    end
  end
end
