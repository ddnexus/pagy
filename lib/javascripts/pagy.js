// See the Pagy documentation: https://ddnexus.github.io/pagy/extras#javascript

function Pagy(){}

Pagy.windowListeners = [];

Pagy.addInputEventListeners = function(input, handler){
                                // select the content on click: easier for typing a number
                                input.addEventListener('click', function(){ this.select() });
                                // go when the input looses focus
                                input.addEventListener('focusout', handler);
                                // … and when pressing enter inside the input
                                input.addEventListener('keyup', function(e){ if (e.which === 13) handler() }.bind(this));
                              };

Pagy.compact = function(id, marker, page, trim){
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

Pagy.items = function(id, marker, from){
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

Pagy.responsive = function(id, tags, widths, series){
                    var pagyEl     = document.getElementById(id),
                        pagyParent = pagyEl.parentElement,
                        lastWidth  = undefined,
                        render     = function(){
                                       var parentWidth = parseInt(pagyParent.clientWidth),
                                           width       = widths.find(function(w){return parentWidth > w});
                                       if (width !== lastWidth) {
                                         while (pagyEl.firstChild) { pagyEl.removeChild(pagyEl.firstChild) }
                                         var html = tags['before'];
                                         series[width].forEach(function(item){html += tags[item]});
                                         html += tags['after'];
                                         pagyEl.insertAdjacentHTML('beforeend', html);
                                         lastWidth = width;
                                       }
                                     }.bind(this);
                    window.addEventListener('resize', render, true);
                    Pagy.windowListeners.push(render);
                    render();
                  };

Pagy.init = function(){
              // we need to explicitly remove the window listeners  because turbolinks persists the window object
              Pagy.windowListeners.forEach(function(l){window.removeEventListener('resize', l, true)});
              Pagy.windowListeners = [];
              var json = document.getElementsByClassName('pagy-json');
              for (var i = 0, len = json.length; i < len; i++) {
                var args = JSON.parse(json[i].innerHTML);
                Pagy[args.shift()].apply(null, args);
              }
              // Support for legacy overridden helpers. It will be removed in 2.0
              ['compact', 'items', 'responsive'].forEach(function(name){
                var json = document.getElementsByClassName("pagy-"+name+"-json");
                for (var i = 0, len = json.length; i < len; i++) {
                  Pagy[name].apply(null, JSON.parse(json[i].innerHTML))
                }
              })
            };
