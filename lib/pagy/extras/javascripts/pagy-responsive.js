// See the Pagy documentation: https://ddnexus.github.io/pagy/extras/resposive

function PagyResponsive(id, items, widths, series){
  var pagyNav    = document.getElementById('pagy-nav-'+id),
      pagyBox    = pagyNav.firstChild || pagyNav,
      pagyParent = pagyNav.parentElement,
      lastWidth  = undefined;

  this.render = function(){
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

  if (window.attachEvent) { window.attachEvent('onresize', this.render) }
  else if (window.addEventListener) { window.addEventListener('resize', this.render, true) }

  this.render();
};
