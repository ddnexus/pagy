// See the Pagy documentation: https://ddnexus.github.io/pagy/extras#javascript

// This code should be OK also with very old browsers

// Container of the whole pagy stuff
function Pagy(){}

Pagy.version = '5.3.1'

// Used by the waitForMe function
Pagy.delay = 100

// Scan the target for data-pagy-json elements and apply their functions
Pagy.init =
  function(arg) {
    var target   = arg instanceof Event || arg === undefined ? document : arg,
        elements = target.querySelectorAll('[data-pagy-json]')
    for (var i = 0, len = elements.length; i < len; i++) {
      var args  = JSON.parse(elements[i].getAttribute('data-pagy-json')),
          fname = args.shift()
      args.unshift(elements[i])
      Pagy[fname].apply(null, args)
    }
  }

// Power the pagy*_nav_js helpers
Pagy.nav =
  function(pagyEl, tags, sequels, label_sequels, trimParam ) {
    label_sequels = (label_sequels === null) ? sequels : label_sequels
    var widths = [], lastWidth,
        fill   = function(string, item, label) { return string.replace(/__pagy_page__/g, item)
                                                              .replace(/__pagy_label__/g, label) }
    for (var width in sequels) {
      if (sequels.hasOwnProperty(width)) { widths.push(parseInt(width, 10)) }
    }
    widths.sort(function(a, b) { return b - a })

    pagyEl.render =
      function() {
        var width, i, len
        for (i = 0, len = widths.length; i < len; i++) {
          if (this.parentElement.clientWidth > widths[i]) { width = widths[i]; break }
        }
        if (width !== lastWidth) {
          var html   = tags.before,
              series = sequels[width],
              labels = label_sequels[width]
          for (i = 0, len = series.length; i < len; i++) {
            var item  = series[i],
                label = labels[i]
            if (typeof(trimParam) === 'string' && item === 1) { html += Pagy.trim(fill(tags.link, item, label), trimParam) }
            else if (typeof(item) === 'number') { html += fill(tags.link, item, label) }
            else if (item === 'gap') { html += tags.gap }
            else if (typeof(item) === 'string') { html += fill(tags.active, item, label) }
          }
          html += tags.after
          this.insertAdjacentHTML('afterbegin', html)
          lastWidth = width
        }
      }.bind(pagyEl)
    pagyEl.render()
  }

// Power the pagy*_combo_nav_js helpers
Pagy.combo_nav =
  function(pagyEl, page, link, trimParam) {
    var input  = pagyEl.getElementsByTagName('input')[0],
        toPage =
          function() {
            if (page !== input.value) {
              var html = link.replace(/__pagy_page__/, input.value)
              if (typeof (trimParam) === 'string' && input.value === '1') { html = Pagy.trim(html, trimParam) }
              pagyEl.insertAdjacentHTML('afterbegin', html)
              pagyEl.getElementsByTagName('a')[0].click()
            }
          }
    Pagy.addInputEventListeners(input, toPage)
  }

// Power the pagy_items_selector_js helper
Pagy.items_selector =
  function(pagyEl, from, link, param) {
    var input   = pagyEl.getElementsByTagName('input')[0],
        current = input.value,
        toPage  =
          function() {
            var items = input.value
            if (items === 0 || items === '') { return }
            if (current !== items) {
              var page = Math.max(Math.ceil(from / items), 1),
                  html = link.replace(/__pagy_page__/, page).replace(/__pagy_items__/, items)
              if (typeof (param) === 'string' && page === 1) { html = Pagy.trim(html, param) }
              pagyEl.insertAdjacentHTML('afterbegin', html)
              pagyEl.getElementsByTagName('a')[0].click()
            }
          }
    Pagy.addInputEventListeners(input, toPage)
  }

// Utility for input fields
Pagy.addInputEventListeners =
  function(input, toPage) {
    // select the content on click: easier for typing a number
    input.addEventListener('click', function() { this.select() })
    // toPage when the input looses focus
    input.addEventListener('focusout', toPage)
    // … and when pressing enter inside the input
    input.addEventListener('keyup', function(e) { if (e.which === 13) {toPage()} }.bind(this))
  }

// Power the trim extra for js helpers
Pagy.trim =
  function(html, param) {
    var re = new RegExp('[?&]' + param + '=1\\b(?!&)|\\b' + param + '=1&')
    return html.replace(re, '')
  }

// Render all *nav_js helpers
Pagy.renderNavs =
  function() {
    var navs = document.getElementsByClassName('pagy-njs')  // 'pagy-njs' is common to all *nav_js helpers
    for (var i = 0, len = navs.length; i < len; i++) { navs[i].render() }
  }

// Throttle to avoid to fire multiple time the renderNavs on resize
Pagy.waitForMe =
  function() {
    if (typeof(Pagy.tid) === 'number') { clearTimeout(Pagy.tid) }
    Pagy.tid = setTimeout(Pagy.renderNavs, Pagy.delay)
  }

// If there is a window object then add the event listener on resize
if (typeof window !== 'undefined') {
  window.addEventListener('resize', Pagy.waitForMe, true)
}
