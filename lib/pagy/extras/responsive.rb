# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/responsive
# frozen_string_literal: true

require 'json'

class Pagy

  # Default :breakpoints
  VARS[:breakpoints] = { 0 => [1,4,4,1] }

  # Helper for building the page_nav with javascript. For example:
  # with an object like:
  #   Pagy.new count:1000, page: 20, breakpoints: {0 => [1,2,2,1], 350 => [2,3,3,2], 550 => [3,4,4,3]}
  # it returns something like:
  #   { :items  => [1, :gap, 18, 19, "20", 21, 22, 50, 2, 17, 23, 49, 3, 16, 24, 48],
  #     :series => { 0   =>[1, :gap, 18, 19, "20", 21, 22, :gap, 50],
  #                  350 =>[1, 2, :gap, 17, 18, 19, "20", 21, 22, 23, :gap, 49, 50],
  #                  550 =>[1, 2, 3, :gap, 16, 17, 18, 19, "20", 21, 22, 23, 24, :gap, 48, 49, 50] },
  #     :widths => [550, 350, 0] }
  # where :items  is the unordered array union of all the page numbers for all sizes (passed to the PagyResponsive javascript function)
  #       :series is the hash of the series keyed by width (used by the *_responsive helpers to create the JSON string)
  #       :widths is the desc-ordered array of widths (passed to the PagyResponsive javascript function)
  def responsive
    @responsive ||= {items: [], series: {}, widths:[]}.tap do |r|
      @vars[:breakpoints].key?(0) || raise(ArgumentError, "expected :breakpoints to contain the 0 size; got #{@vars[:breakpoints].inspect}")
      @vars[:breakpoints].each {|width, size| r[:items] |= r[:series][width] = series(size)}
      r[:widths] = r[:series].keys.sort!{|a,b| b <=> a}
    end
  end

  # Add nav helpers for responsive pagination
  module Frontend

    # Generic responsive pagination: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_nav_responsive(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = (p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
                               : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev')}</span> ))
      responsive[:items].each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<span class="page">#{link.call item}</span> )             # page link
                          elsif item.is_a?(String) ; %(<span class="page active">#{item}</span> )                # current page
                          elsif item == :gap       ; %(<span class="page gap">#{pagy_t('pagy.nav.gap')}</span> ) # page gap
                          end
      end
      tags['after'] = (p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
                              : %(<span class="page next disabled">#{pagy_t('pagy.nav.next')}</span>))
      script = %(<script type="application/json" class="pagy-responsive-json">["#{id}", #{tags.to_json},  #{responsive[:widths].to_json}, #{responsive[:series].to_json}]</script>)
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-responsive pagination" role="navigation" aria-label="pager"></nav>#{script})
    end

    # Responsive pagination for bootstrap: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_nav_responsive_bootstrap(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy, 'class="page-link"'), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = +'<ul class="pagination">'
      tags['before'] << (p_prev ? %(<li class="page-item prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                                : %(<li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.prev')}</a></li>))
      responsive[:items].each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<li class="page-item">#{link.call item}</li>)                                                        # page link
                          elsif item.is_a?(String) ; %(<li class="page-item active">#{link.call item}</li>)                                                 # active page
                          elsif item == :gap       ; %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.gap')}</a></li>) # page gap
                          end
      end
      tags['after'] = +(p_next ? %(<li class="page-item next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                               : %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.next')}</a></li>))
      tags['after'] << '</ul>'
      script = %(<script type="application/json" class="pagy-responsive-json">["#{id}", #{tags.to_json},  #{responsive[:widths].to_json}, #{responsive[:series].to_json}]</script>)
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-responsive-bootstrap pagination" role="navigation" aria-label="pager"></nav>#{script})
    end

    # Responsive pagination for Bulma: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_nav_responsive_bulma(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = +(p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'class="pagination-previous" aria-label="previous page"')
                                : %(<a class="pagination-previous" disabled>#{pagy_t('pagy.nav.prev')}</a>))
      tags['before'] << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'class="pagination-next" aria-label="next page"')
                                : %(<a class="pagination-next" disabled>#{pagy_t('pagy.nav.next')}</a>))
      tags['before'] << '<ul class="pagination-list">'
      responsive[:items].each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<li>#{link.call item, item, %(class="pagination-link" aria-label="goto page #{item}")}</li>)
                          elsif item.is_a?(String) ; %(<li>#{link.call item, item, %(class="pagination-link is-current" aria-current="page" aria-label="page #{item}")}</li>)
                          elsif item == :gap       ; %(<li><span class="pagination-ellipsis">#{pagy_t('pagy.nav.gap')}</span></li>)
                          end
      end
      tags['after'] = '</ul>'
      script = %(<script type="application/json" class="pagy-responsive-json">["#{id}", #{tags.to_json},  #{responsive[:widths].to_json}, #{responsive[:series].to_json}]</script>)
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-bulma pagination is-centered" role="navigation" aria-label="pagination"></nav>#{script})
    end

    # Responsive pagination for Foundation: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_nav_responsive_foundation(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = +'<ul class="pagination">'
      tags['before'] << (p_prev ? %(<li class="prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                                : %(<li class="prev disabled">#{pagy_t('pagy.nav.prev')}</li>))
      responsive[:items].each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<li>#{link.call item}</li>)                              # page link
                          elsif item.is_a?(String) ; %(<li class="current"><span class="show-for-sr">#{pagy_t('pagy.nav.current')}</span> #{item}</li>)                        # active page
                          elsif item == :gap       ; %(<li class="gap disabled">#{pagy_t('pagy.nav.gap')}</li>) # page gap
                          end
      end
      tags['after'] = +(p_next ? %(<li class="next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                               : %(<li class="next disabled">#{pagy_t('pagy.nav.next')}</li>))
      tags['after'] << '</ul>'
      script = %(<script type="application/json" class="pagy-responsive-json">["#{id}", #{tags.to_json},  #{responsive[:widths].to_json}, #{responsive[:series].to_json}]</script>)
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-responsive-foundation" aria-label="Pagination"></nav>#{script})
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
