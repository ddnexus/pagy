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

  input.addEventListener("focusout", this.go);
}
