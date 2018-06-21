// See the Pagy documentation: https://ddnexus.github.io/pagy/extras

function Pagy(){}

Pagy.compact = function(id, marker, page){
                 var pagyNav = document.getElementById('pagy-nav-'+id),
                     input   = pagyNav.getElementsByTagName('input')[0],
                     link    = pagyNav.getElementsByTagName('a')[0];

                 var go = function(){
                   if (page !== input.value) {
                     var href = link.getAttribute('href').replace(marker, input.value);
                     link.setAttribute('href', href);
                     link.click();
                   }
                 };

                // select the content on click: easier for typing a number
                input.addEventListener('click', function(){ this.select() });
                // go when the input looses focus
                input.addEventListener('focusout', go);
                // … and when pressing enter inside the input
                input.addEventListener('keyup', function(e){ if (e.which === 13) go() }.bind(this));

              };


Pagy.items = function(id, marker, from){
               var pagyNav = document.getElementById('pagy-items-'+id),
                   input   = pagyNav.getElementsByTagName('input')[0],
                   current = input.value,
                   link    = pagyNav.getElementsByTagName('a')[0];

               var go = function(){
                 var items = input.value;
                 if (current !== items) {
                   var page = Math.max(Math.ceil(from / items),1);
                   var href = link.getAttribute('href').replace(marker+'-page-', page).replace(marker+'-items-', items);
                   link.setAttribute('href', href);
                   link.click();
                 }
               };

               // select the content on click: easier for typing a number
               input.addEventListener('click', function(){ this.select() });
               // go when the input looses focus
               input.addEventListener('focusout', go);
               // … and when pressing enter inside the input
               input.addEventListener('keyup', function(e){ if (e.which === 13) go() }.bind(this));

             };

Pagy.responsive = function(id, items, widths, series){
                    var pagyNav    = document.getElementById('pagy-nav-'+id),
                        pagyBox    = pagyNav.firstChild || pagyNav,
                        pagyParent = pagyNav.parentElement,
                        lastWidth  = undefined;

                    var render = function(){
                      var parentWidth = parseInt(pagyParent.clientWidth),
                          width       = widths.find(function(w){return parentWidth > w});
                      if (width !== lastWidth) {
                        while (pagyBox.firstChild) { pagyBox.removeChild(pagyBox.firstChild) }
                        var tags = items['prev'];
                        series[width].forEach(function(item){tags += items[item]});
                        tags += items['next'];
                        pagyBox.insertAdjacentHTML('beforeend', tags);
                        lastWidth = width;
                      }
                    };

                    if (window.attachEvent) { window.attachEvent('onresize', render) }
                    else if (window.addEventListener) { window.addEventListener('resize', render, true) }

                    render();
                  };


Pagy.init = function(){
              ['compact', 'items', 'responsive'].forEach(function(name){
                Array.from(document.getElementsByClassName("pagy-"+name)).forEach(function(json) {
                  Pagy[name].apply(null, JSON.parse(json.innerHTML))
                })
              })
            };
