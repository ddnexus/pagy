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

  // jump to page number from input when input looses focus
  input.addEventListener('focusout', this.go)
  // … and when pressing enter inside input
  input.addEventListener('keyup', function (e) {
    if (event.which === 13) {
      this.go()
    }
  }.bind(this))
}
