# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/materialize
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for materialize: it returns the html with the series of links to the pages
    def pagy_nav_materialize(pagy)
      html, link, p_prev, p_next = +'', pagy_link_proc(pagy), pagy.prev, pagy.next
      html << (p_prev ? %(<li class="waves-effect prev">#{link.call p_prev, '<i class="material-icons">chevron_left</i>', 'aria-label="previous"'}</li>)
                      : %(<li class="prev disabled"><a href="#"><i class="material-icons">chevron_left</i></a></li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li class="waves-effect">#{link.call item}</li>)                                             # page link
                elsif item.is_a?(String) ; %(<li class="active">#{link.call item}</li>)                                                   # active page
                elsif item == :gap       ; %(<li class="gap disabled"><a href="#">#{pagy_t('pagy.nav.gap')}</a></li>)   # page gap
                end
      end
      html << (p_next ? %(<li class="waves-effect next">#{link.call p_next, '<i class="material-icons">chevron_right</i>', 'aria-label="next"'}</li>)
                      : %(<li class="next disabled"><a href="#"><i class="material-icons">chevron_right</i></a></li>))
      %(<div class="pagy-nav-materialize pagination" role="navigation" aria-label="pager"><ul class="pagination">#{html}</ul></div>)
    end

    # Compact pagination for materialize: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_nav_compact_materialize(pagy, id=caller(1,1)[0].hash)
      html, link, p_prev, p_next, p_page, p_pages = +'', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html << %(<div id="pagy-nav-#{id}" class="pagy-nav-compact-materialize pagination" role="navigation" aria-label="pager">)
      html << link.call(MARKER, '', %(style="display: none;" ))
      (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
      html << %(<div class="pagy-compact-chip role="group" style="height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;">)
      html << '<ul class="pagination" style="margin: 0px;">'
      li_style = 'style="vertical-align: middle;"'
      html << (p_prev ? %(<li class="waves-effect prev" #{li_style}>#{link.call p_prev, '<i class="material-icons">chevron_left</i>', 'aria-label="previous"'}</li>)
               : %(<li class="prev disabled" #{li_style}><a href="#"><i class="material-icons">chevron_left</i></a></li>))
      input = %(<input type="number" class="browser-default" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 2px; border: none; border-radius: 2px; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
      html << %(<div class="pagy-compact-input btn-flat" style="cursor: default; padding: 0px">#{pagy_t('pagy.compact.page')} #{input} #{pagy_t('pagy.compact.of')} #{p_pages}</div>)
      html << (p_next ? %(<li class="waves-effect next" #{li_style}>#{link.call p_next, '<i class="material-icons">chevron_right</i>', 'aria-label="next"'}</li>)
               : %(<li class="next disabled" #{li_style}><a href="#"><i class="material-icons">chevron_right</i></a></li>))
      html << %(</ul></div><script type="application/json" class="pagy-compact-json">["#{id}", "#{MARKER}", "#{p_page}", #{!!defined?(TRIM)}]</script>)
    end

    # Responsive pagination for Materialize: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_nav_responsive_materialize(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = +'<ul class="pagination">'
      tags['before'] << (p_prev  ? %(<li class="waves-effect prev">#{link.call p_prev, '<i class="material-icons">chevron_left</i>', 'aria-label="previous"'}</li>)
                                 : %(<li class="prev disabled"><a href="#"><i class="material-icons">chevron_left</i></a></li>))
      responsive[:items].each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<li class="waves-effect">#{link.call item}</li>)                           # page link
                          elsif item.is_a?(String) ; %(<li class="active">#{link.call item}</li>)                                 # active page
                          elsif item == :gap       ; %(<li class="gap disabled"><a href="#">#{pagy_t('pagy.nav.gap')}</a></li>)   # page gap
                          end
      end
      tags['after'] = +(p_next ? %(<li class="waves-effect next">#{link.call p_next, '<i class="material-icons">chevron_right</i>', 'aria-label="next"'}</li>)
                               : %(<li class="next disabled"><a href="#"><i class="material-icons">chevron_right</i></a></li>))
      tags['after'] << '</ul>'
      script = %(<script type="application/json" class="pagy-responsive-json">["#{id}", #{tags.to_json},  #{responsive[:widths].to_json}, #{responsive[:series].to_json}]</script>)
      %(<div id="pagy-nav-#{id}" class="pagy-nav-responsive-materialize pagination" role="navigation" aria-label="pager"></div>#{script})
    end

  end
end
