
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  
  module Frontend
    def pagy_tailwind_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy, 'class="block  hover:text-white hover:bg-blue-600 text-blue border-r border-blue-400 px-3 py-2"'), pagy.prev, pagy.next

      html = EMPTY + (p_prev ? %(<li class="block  hover:text-white hover:bg-blue-600 text-blue border-r border-blue-400 px-3 py-2">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                             : %(<li class="block  hover:text-white hover:bg-blue-600 text-blue border-r border-blue-400 px-3 py-2 cursor-not-allowed"><a href="#" >#{pagy_t('pagy.nav.prev')}</a></li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li class="block hover:text-white hover:bg-blue-600 text-blue border-r border-blue-400 px-3 py-2">#{link.call item}</li>)                                                               # page link
                elsif item.is_a?(String) ; %(<li class="block text-white bg-blue-400 border-r border-blue px-3 py-2">#{link.call item}</li>)                                                        # active page
                elsif item == :gap       ; %(<li class="block hover:text-white hover:bg-blue-600 text-blue border-r border-blue-400 px-3 py-2 cursor-not-allowed"><a href="#">#{pagy_t('pagy.nav.gap'),'aria-label=". . ."'}</a></li>) # page gap
                end
      end
      html << (p_next ? %(<li class="block hover:text-blue-600 hover:bg-blue text-blue px-3 py-2">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                      : %(<li class="block hover:text-blue-600 hover:bg-blue text-blue px-3 py-2 cursor-not-allowed"><a href="#" class="">#{pagy_t('pagy.nav.next')}</a></li>))
      %(<nav class="inline-block"><ul class="flex list-none border border-blue-400 rounded w-auto">#{html}</ul></nav>)
    end

  end
end
