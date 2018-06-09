// See the Pagy documentation: https://ddnexus.github.io/pagy/extras/items

function PagyItems(id, marker, from){
  var pagyNav = document.getElementById('pagy-items-'+id),
      input   = pagyNav.getElementsByTagName('input')[0],
      current = input.value,
      link    = pagyNav.getElementsByTagName('a')[0];

  this.go = function(){
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
  // jump to page number from input when the input looses focus
  input.addEventListener('focusout', this.go);
  // … and when pressing enter inside the input
  input.addEventListener('keyup', function(e){ if (e.which === 13) this.go() }.bind(this));

}
