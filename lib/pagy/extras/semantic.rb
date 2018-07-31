# frozen_string_literal: true

class Pagy
  # Add nav helper for semantic-ui pagination
  # I18n not used here, semantic_icon used for chevrons
  # You need to add class="item" to :link_extra VARS
  # ex:
  # Pagy::VARS[:link_extra] = 'data-remote="true" class="item"'

  module Frontend

    # Pagination for semantic-ui: it returns the html with the series of links to the pages
    def pagy_nav_semantic(pagy)
      html, link, p_prev, p_next = +'', pagy_link_proc(pagy), pagy.prev, pagy.next

      html << (p_prev ? %(#{link.call p_prev, '<i class="left small chevron icon"></i>', 'aria-label="previous"'})
                      : %(<div class="item disabled"><i class="left small chevron icon"></i></div> ))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(#{link.call item} )                      # page link
                elsif item.is_a?(String) ; %(<a class="item active">#{item}</a> )     # current page
                elsif item == :gap       ; %(<div class="disabled item">...</div> )   # page gap
                end
      end
      html << (p_next ? %(#{link.call p_next, '<i class="right small chevron icon"></i>', 'aria-label="next"'})
                      : %(<div class="item disabled"><i class="right small chevron icon"></i></div>))
      %(<div class="ui pagination menu" aria-label="pager">#{html}</div>)
    end

  end
end
