() => {
  function loadWidget() {
    const script   = document.createElement('script');
    const hostname = window.location.hostname;
    switch (hostname) {
      case '127.0.0.1':
        script.dataset.widgetId = '_rXLissYyqe-dJ9vGGGXzmJwavoW0GvuzQPEq5BZjP8';
        // script.dataset.iconUrl  = 'http://localhost:5000/pagy/assets/images/pagy-the-frog.png';
        break;
      case 'localhost':
        script.dataset.widgetId = 'djgBhRlpdH8b07oj0Gsaerz69Xfs0FXMuUluyOo2iR4';
        script.dataset.iconUrl  = 'http://localhost:5000/pagy/assets/images/pagy-the-frog.png';
        script.dataset.margins  = '{"bottom": "1.48rem", "right": "6rem"}';
        break;
      case 'ddnexus.github.io':
        script.dataset.widgetId = 'HKtFSPZLGiAXOdBWS4rSAxEkqv8czIbJoQdMEwCqgEc';
        script.dataset.iconUrl  = 'https://ddnexus.github.io/pagy/assets/images/pagy-the-frog.png';
        script.dataset.margins  = '{"bottom": "1.48rem", "right": "6rem"}';
        break;
      default:
        console.error('Pagy AI - Unknown hostname: ', hostname);
    }
    script.async               = true;
    script.src                 = 'https://widget.gurubase.io/widget.latest.min.js';
    script.id                  = 'guru-widget-id';
    script.dataset.text        = 'Pagy AI';
    script.dataset.bgColor     = '#1f7a1f';
    script.dataset.lightMode   = 'false';
    script.dataset.tooltipSide = 'bottom';
    document.head.appendChild(script);
  }
  loadWidget();

  function editChatWidget() {
    const hostId              = 'gurubase-chat-widget-container',
          imgSelector         = '#chatWindow > div.anteon-header > div > img',
          nameSelector        = '#chatWindow > div.anteon-header > div > span',
          descriptionSelector = '#chatWindow > div.chat-messages > div > p',
          newImgSize          = '40px',
          newName             = 'Ask Pagy AI',
          newDescription      = 'Pagy AI uses the latest data in the documentation to answer your questions.';

    const checkAndEdit   = () => {
      const hostElement = document.getElementById(hostId);
      if (hostElement && hostElement.shadowRoot) {
        const shadowRoot  = hostElement.shadowRoot,
              img         = shadowRoot.querySelector(imgSelector),
              name        = shadowRoot.querySelector(nameSelector),
              description = shadowRoot.querySelector(descriptionSelector);
        if (img) {
          img.style.maxWidth  = newImgSize;
          img.style.maxHeight = newImgSize;
        }
        if (name) {
          name.textContent = newName;
        }
        if (description) {
          description.textContent = newDescription;
        }
        return true;
      }
      return false;
    };
    const attemptEditing = () => {
      if (checkAndEdit()) {
        return;
      }
      setTimeout(attemptEditing, 200);
    };
    attemptEditing();
  }
  editChatWidget();
}
