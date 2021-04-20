// See the Pagy documentation: https://ddnexus.github.io/pagy/extras#javascript

function Pagy(){}

Pagy.version = '4.3.0';

Pagy.timeout = 100;

Pagy.timeoutId = 0;

Pagy.init = function(arg) {
              var target   = arg instanceof Event || arg === undefined ? document : arg,
                  jsonTags = target.getElementsByClassName('pagy-json');
              for (var i = 0, len = jsonTags.length; i < len; i++) {
                var args  = JSON.parse(jsonTags[i].innerHTML),
                    fname = args.shift();
                args.unshift(jsonTags[i].previousSibling);
                Pagy[fname].apply(null, args);
              }
            }

Pagy.nav = function(pagyEl, tags, sequels, param) {
             var lastWidth = undefined,
                 timeoutId = 0,
                 pageREg   = new RegExp(/__pagy_page__/g),
                 widths    = [],
                 wait      = function() { clearTimeout(timeoutId); timeoutId = setTimeout(pagyEl.render, Pagy.timeout) };

             for (var width in sequels) { widths.push(parseInt(width)) } // fine with sequels structure
             widths.sort(function(a, b) { return b - a });

             pagyEl.render = function() {
                               if (this.parentElement.clientWidth === 0) { return wait() } // not ready yet
                               var width, i, len;
                               for (i = 0, len = widths.length; i < len; i++) {
                                 if (this.parentElement.clientWidth > widths[i]) { width = widths[i]; break }
                               }
                               if (width !== lastWidth) {
                                 var html   = tags.before,
                                     series = sequels[width];
                                 for (i = 0, len = series.length; i < len; i++) {
                                   var item = series[i];
                                   if (typeof(param) === 'string' && item === 1) { html += Pagy.trim(tags.link.replace(pageREg, item), param) }
                                   else if (typeof(item) === 'number') { html += tags.link.replace(pageREg, item) }
                                   else if (item === 'gap') { html += tags.gap }
                                   else if (typeof(item) === 'string') { html += tags.active.replace(pageREg, item) }
                                 }
                                 html += tags.after;
                                 this.innerHTML = '';
                                 this.insertAdjacentHTML('afterbegin', html);
                                 lastWidth = width;
                               }
                             }.bind(pagyEl);
             pagyEl.render();
           }

Pagy.combo_nav = function(pagyEl, page, link, param) {
                   var input = pagyEl.getElementsByTagName('input')[0],
                       go    = function() {
                                 if (page !== input.value) {
                                   var html = link.replace(/__pagy_page__/, input.value);
                                   if (typeof (param) === 'string' && input.value === '1') { html = Pagy.trim(html, param) }
                                   pagyEl.insertAdjacentHTML('afterbegin', html);
                                   pagyEl.getElementsByTagName('a')[0].click();
                                 }
                               };
                   Pagy.addInputEventListeners(input, go);
                 }

Pagy.items_selector = function(pagyEl, from, link, param) {
                        var input   = pagyEl.getElementsByTagName('input')[0],
                            current = input.value,
                            go      = function() {
                              var items = input.value;
                              if (current !== items) {
                                var page = Math.max(Math.ceil(from / items), 1),
                                    html = link.replace(/__pagy_page__/, page).replace(/__pagy_items__/, items);
                                if (typeof (param) === 'string' && page === 1) { html = Pagy.trim(html, param) }
                                pagyEl.insertAdjacentHTML('afterbegin', html);
                                pagyEl.getElementsByTagName('a')[0].click();
                              }
                            };
                        Pagy.addInputEventListeners(input, go);
                      }

Pagy.addInputEventListeners = function(input, handler) {
                                // select the content on click: easier for typing a number
                                input.addEventListener('click', function() { this.select() });
                                // go when the input looses focus
                                input.addEventListener('focusout', handler);
                                // … and when pressing enter inside the input
                                input.addEventListener('keyup', function(e) { if (e.which === 13) {handler()} }.bind(this));
                              }

Pagy.trim = function(html, param) {
              var re = new RegExp('[?&]' + param + '=1\\b(?!&)|\\b' + param + '=1&');
              return html.replace(re, '');
            }

Pagy.renderNjs = function() {
                  var sels = '.pagy-nav-js, .pagy-bootstrap-nav-js, .pagy-bulma-nav-js, .pagy-foundation-nav-js, .pagy-materialize-nav-js, .pagy-semantic-nav-js, .pagy-uikit-nav-js',
                      navs = document.querySelectorAll(sels);
                   for (var i = 0, len = navs.length; i < len; i++) { navs[i].render() }
                 }

Pagy.wait = function() {
              clearTimeout(Pagy.timeoutId);
              Pagy.timeoutId = setTimeout(Pagy.renderNjs, Pagy.timeout);
            }

window.addEventListener('resize', Pagy.wait, true);
