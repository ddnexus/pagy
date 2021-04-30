// See the Pagy documentation: https://ddnexus.github.io/pagy/extras#javascript

function Pagy(){}

Pagy.version = '4.5.0'

Pagy.delay = 100

Pagy.init =
  function(arg) {
    var target   = arg instanceof Event || arg === undefined ? document : arg,
        jsonTags = target.getElementsByClassName('pagy-json')
    for (var i = 0, len = jsonTags.length; i < len; i++) {
      var args  = JSON.parse(jsonTags[i].innerHTML),
          fname = args.shift()
      args.unshift(jsonTags[i].previousSibling)
      Pagy[fname].apply(null, args)
    }
  }

Pagy.nav =
  function(pagyEl, tags, sequels, trimParam) {
    var lastWidth,
        pageREg = new RegExp(/__pagy_page__/g),
        widths  = []
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
              series = sequels[width]
          for (i = 0, len = series.length; i < len; i++) {
            var item = series[i]
            if (typeof(trimParam) === 'string' && item === 1) { html += Pagy.trim(tags.link.replace(pageREg, item), trimParam) }
            else if (typeof(item) === 'number') { html += tags.link.replace(pageREg, item) }
            else if (item === 'gap') { html += tags.gap }
            else if (typeof(item) === 'string') { html += tags.active.replace(pageREg, item) }
          }
          html += tags.after
          this.innerHTML = ''
          this.insertAdjacentHTML('afterbegin', html)
          lastWidth = width
        }
      }.bind(pagyEl)
    pagyEl.render()
 }

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

Pagy.items_selector =
  function(pagyEl, from, link, param) {
    var input   = pagyEl.getElementsByTagName('input')[0],
        current = input.value,
        toPage  =
          function() {
            var items = input.value
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

Pagy.addInputEventListeners =
  function(input, toPage) {
    // select the content on click: easier for typing a number
    input.addEventListener('click', function() { this.select() })
    // toPage when the input looses focus
    input.addEventListener('focusout', toPage)
    // … and when pressing enter inside the input
    input.addEventListener('keyup', function(e) { if (e.which === 13) {toPage()} }.bind(this))
  }

Pagy.trim =
  function(html, param) {
    var re = new RegExp('[?&]' + param + '=1\\b(?!&)|\\b' + param + '=1&')
    return html.replace(re, '')
  }

Pagy.renderNavs =
  function() {
    var navs = document.getElementsByClassName('pagy-njs')  // 'pagy-njs' is common to all *nav_js helpers
    for (var i = 0, len = navs.length; i < len; i++) { navs[i].render() }
  }

Pagy.waitForMe =
  function() {
    if (typeof(Pagy.tid) === 'number') { clearTimeout(Pagy.tid) }
    Pagy.tid = setTimeout(Pagy.renderNavs, Pagy.delay)
  }

window.addEventListener('resize', Pagy.waitForMe, true)
