# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/support
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy

  def to_h
    { count:  defined?(@count) && @count,
      page:   @page,
      items:  @items,
      pages:  @pages,
      last:   @last,
      offset: @offset,
      from:   @from,
      to:     @to,
      prev:   @prev,
      next:   @next,
      vars:   @vars,
      series: series }
  end

  module Frontend

    def pagy_prev_url(pagy)
      pagy_url_for(pagy.prev, pagy) if pagy.prev
    end

    def pagy_next_url(pagy)
      pagy_url_for(pagy.next, pagy) if pagy.next
    end

    def pagy_prev_link(pagy, text = pagy_t('pagy.nav.prev'), link_extra = '')
      pagy.prev ? %(<span class="page prev"><a href="#{pagy_prev_url(pagy)}" rel="next" aria-label="next" #{pagy.vars[:link_extra]} #{link_extra}>#{text}</a></span>)
                : %(<span class="page prev disabled">#{text}</span>)
    end

    def pagy_next_link(pagy, text = pagy_t('pagy.nav.next'), link_extra = '')
      pagy.next ? %(<span class="page next"><a href="#{pagy_next_url(pagy)}" rel="next" aria-label="next" #{pagy.vars[:link_extra]} #{link_extra}>#{text}</a></span>)
                : %(<span class="page next disabled">#{text}</span>)
    end

    def pagy_serialized(pagy)
      pagy.to_h.merge(prev_url: pagy_prev_url(pagy), next_url: pagy_next_url(pagy))
    end

    # Multi purpose JSON tag for custom javascript initialization
    def pagy_apply_init_tag(pagy, function, payload=pagy_serialized(pagy))
      pagy_json_tag(:applyInit, function, payload)
    end

  end

end
