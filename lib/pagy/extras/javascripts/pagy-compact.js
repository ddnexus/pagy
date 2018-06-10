// See the Pagy documentation: https://ddnexus.github.io/pagy/extras/compact

function PagyCompact(id, marker, page){
  var pagyNav = document.getElementById('pagy-nav-'+id),
      input   = pagyNav.getElementsByTagName('input')[0],
      link    = pagyNav.getElementsByTagName('a')[0];

  this.go = function(){
    if (page !== input.value) {
      var href = link.getAttribute('href').replace(marker, input.value);
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
