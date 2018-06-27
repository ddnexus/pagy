// See the Pagy documentation: https://ddnexus.github.io/pagy/extras#javascript

function Pagy(){}

Pagy.addInputEventListeners = function(input, handler){
                                // select the content on click: easier for typing a number
                                input.addEventListener('click', function(){ this.select() });
                                // go when the input looses focus
                                input.addEventListener('focusout', handler);
                                // … and when pressing enter inside the input
                                input.addEventListener('keyup', function(e){ if (e.which === 13) handler() }.bind(this));
                              };

Pagy.compact = function(id, marker, page){
                 var pagyNav = document.getElementById('pagy-nav-'+id),
                     input   = pagyNav.getElementsByTagName('input')[0],
                     link    = pagyNav.getElementsByTagName('a')[0],
                     go      = function(){
                                 if (page !== input.value) {
                                   var href = link.getAttribute('href').replace(marker, input.value);
                                   link.setAttribute('href', href);
                                   link.click();
                                 }
                               };
                 Pagy.addInputEventListeners(input, go);
               };

Pagy.items = function(id, marker, from){
               var pagyNav = document.getElementById('pagy-items-'+id),
                   input   = pagyNav.getElementsByTagName('input')[0],
                   current = input.value,
                   link    = pagyNav.getElementsByTagName('a')[0],
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
                    var pagyNav    = document.getElementById('pagy-nav-'+id),
                        pagyBox    = pagyNav.firstChild || pagyNav,
                        pagyParent = pagyNav.parentElement,
                        lastWidth  = undefined,
                        render     = function(){
                                       var parentWidth = parseInt(pagyParent.clientWidth),
                                           width       = widths.find(function(w){return parentWidth > w});
                                       if (width !== lastWidth) {
                                         while (pagyBox.firstChild) { pagyBox.removeChild(pagyBox.firstChild) }
                                         var html = tags['prev'];
                                         series[width].forEach(function(item){html += tags[item]});
                                         html += tags['next'];
                                         pagyBox.insertAdjacentHTML('beforeend', html);
                                         lastWidth = width;
                                       }
                                     };
                    if (window.attachEvent) { window.attachEvent('onresize', render) }
                    else if (window.addEventListener) { window.addEventListener('resize', render, true) }
                    render();
                  };

Pagy.init = function(){
              ['compact', 'items', 'responsive'].forEach(function(name){
                Array.from(document.getElementsByClassName("pagy-"+name+"-json")).forEach(function(json) {
                  Pagy[name].apply(null, JSON.parse(json.innerHTML))
                })
              })
            };
