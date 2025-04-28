# frozen_string_literal: true

class Pagy
  # Generte  hash of the pagination links
  def urls_hash(**)
    url = compose_page_url(PAGE_TOKEN, **)
    { first: compose_page_url(nil, **) }.tap do |urls| # first is present, but the URL omits the nil page param
      urls[:previous] = url.sub(PAGE_TOKEN, @previous.to_s) if @previous
      urls[:next]     = url.sub(PAGE_TOKEN, @next.to_s)     if @next
      urls[:last]     = url.sub(PAGE_TOKEN, @last.to_s)     if @count # offset and not countless
    end
  end
end
