// See the Pagy documentation: https://ddnexus.github.io/pagy/extras#javascript

function Pagy(){}

Pagy.init = function(arg){
              var target   = arg instanceof Event || arg === undefined ? document : arg,
                  jsonTags = target.getElementsByClassName('pagy-json');
              for (var i = 0, len = jsonTags.length; i < len; i++) {
                var args = JSON.parse(jsonTags[i].innerHTML);
                Pagy[args.shift()].apply(null, args);
              }
            };

Pagy.nav = function(id, marker, tags, sequels){
             var pagyEl    = document.getElementById(id),
                 container = pagyEl.parentElement,
                 lastWidth = undefined,
                 timeoutId = 0,
                 marker_re = new RegExp(marker, 'g'),
                 widths    = [];
             for (var width in sequels) { widths.push(parseInt(width)) } // fine with sequels structure
             widths.sort(function(a, b){return b-a});

             var render    = function(){
                               if (container.clientWidth === 0) { rendering() }
                               var width, i, len;
                               for (i = 0, len = widths.length; i < len; i++) {
                                 if (container.clientWidth > widths[i]) { width = widths[i]; break }
                               }
                               if (width !== lastWidth) {
                                 while (pagyEl.firstChild) { pagyEl.removeChild(pagyEl.firstChild) }
                                 var html   = tags.before,
                                     series = sequels[width];
                                 for (i = 0, len = series.length; i < len; i++) {
                                   var item = series[i];
                                   if      (typeof(item) === 'number') { html += tags.link.replace(marker_re, item) }
                                   else if (item === 'gap')            { html += tags.gap }
                                   else if (typeof(item) === 'string') { html += tags.active.replace(marker_re, item) }
                                 }
                                 html += tags.after;
                                 pagyEl.insertAdjacentHTML('beforeend', html);
                                 lastWidth = width;
                               }
                             },
                 // suppress rapid firing rendering
                 rendering = function(){ clearTimeout(timeoutId); timeoutId = setTimeout(render, 150) };

             if (widths.length > 1) {
               // refresh the window resize listener (avoiding rendering multiple times)
               window.removeEventListener('resize', Pagy.windowListeners[id], true);
               window.addEventListener('resize', rendering, true);
               Pagy.windowListeners[id] = rendering;
             }
             render();
           };

Pagy.combo_nav = function(id, marker, page, trim){
                   var pagyEl = document.getElementById(id),
                       input  = pagyEl.getElementsByTagName('input')[0],
                       link   = pagyEl.getElementsByTagName('a')[0],
                       linkP1 = pagyEl.getElementsByTagName('a')[1],
                       go     = function(){
                                  if (page !== input.value) {
                                    if (trim === true && input.value === '1') { linkP1.click() }
                                    else {
                                      var href = link.getAttribute('href').replace(marker, input.value);
                                      link.setAttribute('href', href);
                                      link.click();
                                    }
                                  }
                                };
                   Pagy.addInputEventListeners(input, go);
                 };

Pagy.items_selector = function(id, marker, from){
                        var pagyEl  = document.getElementById(id),
                            input   = pagyEl.getElementsByTagName('input')[0],
                            current = input.value,
                            link    = pagyEl.getElementsByTagName('a')[0],
                            go      = function(){
                                        var items = input.value;
                                        if (current !== items) {
                                          var page = Math.max(Math.ceil(from / items),1);
                                          var href = link.getAttribute('href').replace(marker+'-page-', page).replace(marker+'-items-', items);
                                          link.setAttribute('href', href);
                                          link.click();
                                        }
                                      };
                        Pagy.addInputEventListeners(input, go);
                      };

Pagy.windowListeners = {};

Pagy.addInputEventListeners = function(input, handler){
                                // select the content on click: easier for typing a number
                                input.addEventListener('click', function(){ this.select() });
                                // go when the input looses focus
                                input.addEventListener('focusout', handler);
                                // … and when pressing enter inside the input
                                input.addEventListener('keyup', function(e){ if (e.which === 13) handler() }.bind(this));
                              };

