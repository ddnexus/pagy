# frozen_string_literal: true

class Pagy
  # Generte  hash of the pagination links
  def links_hash(**)
    url = compose_page_url(PAGE_TOKEN, **)
    { first: compose_page_url(nil, **) }.tap do |links| # first is present, but the URL omits the nil page param
      links[:previous] = url.sub(PAGE_TOKEN, @previous.to_s) if @previous
      links[:next]     = url.sub(PAGE_TOKEN, @next.to_s)     if @next
      links[:last]     = url.sub(PAGE_TOKEN, @last.to_s)     if @count # offset and not countless
    end
  end
end
