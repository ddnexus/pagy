type Controls = {
  [key: string]: {
    name:   string;
    unit:   string;
    input?: HTMLInputElement;
  };
};
type Presets = { [key: string]: string };

(() => {
  const padding   = 12;
  const baseColor = '#484848';
  const pagyColor = 'lightsalmon';
  const icons     = 'help,tune,visibility,visibility_off';  // Alpha sorted icon names
  const linkTags  = `
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Pattaya&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@300&icon_names=${icons}&display=block">
  `
  document.head.insertAdjacentHTML('beforeend', linkTags);
  // Cookie handling
  const B64SafeEncode = (unicode:string) => btoa(String.fromCharCode(...(new TextEncoder).encode(unicode)))
                                            .replace(/[+/=]/g, (m) => m == "+" ? "-" : m == "/" ? "_" : "");
  const B64Decode     = (base64:string) => (new TextDecoder()).decode(Uint8Array.from(atob(base64), c => c.charCodeAt(0)));

  const encodeBool    = (bool:boolean) =>  bool ? 'true' : 'false';
  const decodeBool    = (str:string) => str === 'true';

  function deleteCookie(name:string) {
    document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
  }

  function setCookie(name:string, value:string) {
    document.cookie = `${name}=${B64SafeEncode(value)}; path=/`;
  }

  function getCookie(name:string) : string | null {
    const cookieName  = `${name}=`;
    const cookieArray = document.cookie.split(';');
    for (let i = 0; i < cookieArray.length; i++) {
      let cookie = cookieArray[i].trim();
      if (cookie.startsWith(cookieName)) {
        return B64Decode(cookie.substring(cookieName.length));
      }
    }
    return null;
  }

  function initialize(shadow: ShadowRoot) {
    // Append CSS ovveride style tag in <head>
    const styleTag = document.createElement('style');
    styleTag.id    = 'pagy-wand-override';
    document.head.appendChild(styleTag);

    let controls:Controls = {
      brightness:  { name: '--B',            unit: ''    },
      hue:         { name: '--H',            unit: ''    },
      saturation:  { name: '--S',            unit: ''    },
      lightness:   { name: '--L',            unit: ''    },
      spacing:     { name: '--spacing',      unit: 'rem' },
      padding:     { name: '--padding',      unit: 'rem' },
      rounding:    { name: '--rounding',     unit: 'rem' },
      borderWidth: { name: '--border-width', unit: 'rem' },
      fontSize:    { name: '--font-size',    unit: 'rem' },
      fontWeight:  { name: '--font-weight',  unit: ''    },
      lineHeight:  { name: '--line-height',  unit: ''    },
    };
    for (const [id, c] of Object.entries(controls)) {
      c.input = <HTMLInputElement>shadow.getElementById(id);
    }

    function updateStyle() {
      let override = `.pagy {\n`;
      Object.values(controls).forEach((c) => {
        override += `  ${c.name}: ${c.input!.value}${c.unit};\n`;
      });
      override += '}';
      const overrideArea        = <HTMLTextAreaElement>shadow.getElementById('override');
      const overrideStyle       = <HTMLStyleElement>document.getElementById('pagy-wand-override');
      overrideArea.value        = override;
      overrideStyle.textContent = override;
      setCookie('pagy-wand-override', override);
    }

    function getCookiePosition() {
      const position = getCookie('pagy-wand-position');
      if (position) {
        const [left, top] = position.split(',');
        return { left: parseInt(left), top: parseInt(top) };
      }
      return null;
    }

    function setCookiePosition(left: string|number, top: string|number) {
      setCookie('pagy-wand-position', `${left},${top}`);
    }

    const viewport = () => ({
      width:  window.visualViewport ? window.visualViewport.width  : document.documentElement.clientWidth,
      height: window.visualViewport ? window.visualViewport.height : document.documentElement.clientHeight,
    });

    const panel  = <HTMLElement>shadow.getElementById('panel');
    const topBar = <HTMLElement>shadow.getElementById('top-bar');

    function keepTopBarInView() {
      const v = viewport();
      const topBarRect = topBar.getBoundingClientRect();
      // Check if topBar is off-screen horizontally
      if (topBarRect.left < 0) {
        panel.style.left = '0px';
      } else if (topBarRect.right > v.width) {
        panel.style.left = `${v.width - topBar.offsetWidth}px`;
      }
      // Check if topBar is off-screen vertically
      if (topBarRect.top < 0) {
        panel.style.top = '0px';
      } else if (topBarRect.bottom > v.height) {
        panel.style.top = `${v.height - topBar.offsetHeight}px`;
      }
      // Ensure the top bar is in view
      if (topBarRect.top < 0 && topBar.offsetHeight < v.height) {
        panel.style.top = '0px';
      }
      setCookiePosition(topBar.style.left, topBar.style.top);
    };

    // Resize event listener
    let resizeTimeout: number | undefined;   // debouncing
    window.addEventListener('resize', () => {
      if (resizeTimeout) clearTimeout(resizeTimeout);
      resizeTimeout = window.setTimeout(keepTopBarInView, 250);
    });

    // Set position from cookie (or transition-center it)
    const position = getCookiePosition();

    if (position) {
      panel.style.left = `${position.left}px`;
      panel.style.top  = `${position.top}px`;
    } else {
      panel.classList.add('initial');
      window.addEventListener('load', () => {
        panel.addEventListener('transitionend', () => {
          panel.style.transition = 'none'; // Remove transition using 'none'
          const rect       = panel.getBoundingClientRect();
          panel.style.top  = rect.top + 'px';
          panel.style.left = rect.left + 'px';
          setCookiePosition(panel.style.left, panel.style.top)
          panel.classList.remove('initial')
          panel.classList.remove('centered')
        });
        panel.classList.add('centered');
      });
    }

    // Panel dragging
    let offsetX  = 0;
    let offsetY  = 0;
    let dragging = false;

    topBar.addEventListener('mousedown', (e) => {
      if ((<HTMLElement>e.target).closest('#preset-menu')) return;

      dragging = true;
      offsetX  = e.clientX - panel.offsetLeft;
      offsetY  = e.clientY - panel.offsetTop;
    });
    document.addEventListener('mousemove', (e) => {
      if (!dragging) return;

      panel.style.left = `${e.clientX - offsetX}px`;
      panel.style.top  = `${e.clientY - offsetY}px`;
      setCookiePosition(e.clientX - offsetX, e.clientY - offsetY);
    });
    document.addEventListener('mouseup', () => dragging = false);


    // Toggles
    const controlsChk   = <HTMLInputElement>shadow.getElementById('controls-chk');
    controlsChk.checked = decodeBool(getCookie('pagy-wand-controls-chk') ?? 'false');
    const controlsIcon  = <HTMLElement>shadow.getElementById('controls-icon');
    const controlsDiv   = <HTMLElement>shadow.getElementById('controls');

    const helpChk   = <HTMLInputElement>shadow.getElementById('help-chk');
    helpChk.checked = decodeBool(getCookie('pagy-wand-help-chk') ?? 'false');
    const helpIcon  = <HTMLElement>shadow.getElementById('help-icon');
    const helpDiv   = <HTMLElement>shadow.getElementById('help');

    // Controls
    function controlsSwitcher() {
      if (controlsChk.checked) {  // show controls
        controlsIcon.classList.add('selected-icon');
        controlsDiv.style.display = 'grid';
        helpChk.checked           = false;
        helpSwitcher();
      } else {                    // hide controls
        controlsIcon.classList.remove('selected-icon');
        controlsDiv.style.display = 'none';
      }
      setCookie('pagy-wand-controls-chk', encodeBool(controlsChk.checked));
    }
    controlsSwitcher();
    controlsChk.addEventListener('change', controlsSwitcher);

    // Help
    function helpSwitcher() {
      if (helpChk.checked) {      // show help
        helpIcon.classList.add('selected-icon');
        helpDiv.style.display = 'block';
        controlsChk.checked   = false;
        controlsSwitcher();
      } else {                    // hide controls
        helpIcon.classList.remove('selected-icon');
        helpDiv.style.display = 'none';
      }
      setCookie('pagy-wand-help-chk', encodeBool(helpChk.checked));
    }
    helpSwitcher();
    helpChk.addEventListener('change', helpSwitcher);

    // Live button
    const liveChk           = <HTMLInputElement>shadow.getElementById('live-chk');
    liveChk.checked         = decodeBool(getCookie('pagy-wand-live-chk') ?? 'true');
    const liveIcon          = <HTMLElement>shadow.getElementById('live-icon');
    const liveStyle         = <HTMLStyleElement>document.getElementById('pagy-wand-default');
    const liveStyleOverride = <HTMLStyleElement>document.getElementById('pagy-wand-override');
    function liveSwitcher() {
      if (liveChk.checked) {       // enabled
        liveIcon.textContent       = 'visibility';
        liveStyle.disabled         = false;
        liveStyleOverride.disabled = false;
      } else {                     // disabled
        liveIcon.textContent       = 'visibility_off';
        liveStyle.disabled         = true;
        liveStyleOverride.disabled = true;
      }
      setCookie('pagy-wand-live-chk', encodeBool(liveChk.checked));
    }
    liveSwitcher();
    liveChk.addEventListener('change', liveSwitcher);

    // PRESETS
    const presets:Presets = {
      Default: `
      .pagy {
        --B: 1;
        --H: 0;
        --S: 0;
        --L: 50;
        --spacing: 0.125rem;
        --padding: 0.75rem;
        --rounding: 1.75rem;
        --border-width: 0rem;
        --font-size: 0.875rem;
        --font-weight: 600;
        --line-height: 1.75;
      }
      `,
      Dark: `
      .pagy {
        --B: -1;
        --H: 0;
        --S: 0;
        --L: 60;
        --spacing: 0.125rem;
        --padding: 0.75rem;
        --rounding: 1.75rem;
        --border-width: 0rem;
        --font-size: 0.875rem;
        --font-weight: 600;
        --line-height: 1.75;
      }
      `,
      MidnighExpress: `
      .pagy {
        --B: -1;
        --H: 231;
        --S: 28;
        --L: 60;
        --spacing: 0.1875rem;
        --padding: 1rem;
        --rounding: 0.375rem;
        --border-width: 0rem;
        --font-size: 1rem;
        --font-weight: 450;
        --line-height: 1.25;
      }
      `,
      Pilloween:` 
      .pagy {
        --B: -1;
        --H: 20;
        --S: 80;
        --L: 50;
        --spacing: 0.375rem;
        --padding: 0.75rem;
        --rounding: 1.125rem;
        --border-width: 0.0625rem;
        --font-size: 0.875rem;
        --font-weight: 600;
        --line-height: 1.5;
      }
      `,
      Peppermint:`
      .pagy {
        --B: 1;
        --H: 78;
        --S: 70;
        --L: 38;
        --spacing: 0.1875rem;
        --padding: 0.625rem;
        --rounding: 0.75rem;
        --border-width: 0rem;
        --font-size: 0.875rem;
        --font-weight: 550;
        --line-height: 1.75;
      }
      `,
      CocoaBeans:`
      .pagy {
        --B: 1;
        --H: 27;
        --S: 63;
        --L: 17;
        --spacing: 0.0625rem;
        --padding: 0.5rem;
        --rounding: 1.125rem;
        --border-width: 0rem;
        --font-size: 0.875rem;
        --font-weight: 600;
        --line-height: 2.5;
      }
      `,
      PurpleStripe: `
      .pagy {
        --B: 1;
        --H: 255;
        --S: 63;
        --L: 39;
        --spacing: 0rem;
        --padding: 0.875rem;
        --rounding: 0rem;
        --border-width: 0rem;
        --font-size: 0.875rem;
        --font-weight: 300;
        --line-height: 1.5;
      }
      `,
      GhostInThought: `
      .pagy {
        --B: 1;
        --H: 174;
        --S: 40;
        --L: 70;
        --spacing: 0.125rem;
        --padding: 0.75rem;
        --rounding: 1.125rem;
        --border-width: 0rem;
        --font-size: 0.875rem;
        --font-weight: 450;
        --line-height: 1.75;
      }
      `,
      VintageScent:`
      .pagy {
        --B: 1;
        --H: 51;
        --S: 27;
        --L: 64;
        --spacing: 0.1875rem;
        --padding: 0.75rem;
        --rounding: 0.75rem;
        --border-width: 0.0625rem;
        --font-size: 0.875rem;
        --font-weight: 300;
        --line-height: 1.75;
      }
      `
    };
    const presetMenu = <HTMLSelectElement>shadow.getElementById('preset-menu');
    // Setup preset options
    for (const presetName in presets) {
      const option       = document.createElement('option');
      option.value       = presetName;
      option.textContent = presetName;
      presetMenu.appendChild(option);
    }

    function applyPreset(name:string | null) {
      const css = name
                  ? (deleteCookie('pagy-wand-override'), presets[name])
                  : getCookie('pagy-wand-override');
      css?.match(/--[^:]+:\s*[^;]+/g)?.forEach((match) => {
        let [name, value] = match.split(':');
        name  = name.trim();
        value = value.trim().replace(/[a-zA-Z%]+$/, '');
        for (const c of Object.values(controls)) {
          if (c.name === name) {
            c.input!.value = value;
            break;
          }
        }
        const liveChk = <HTMLInputElement>shadow.getElementById('live-chk');
        liveChk.checked = true;
        liveSwitcher();
      });
      setCookie('pagy-wand-preset', name || '');
      updateStyle();
    }
    presetMenu.addEventListener('change', (e) => applyPreset((<HTMLSelectElement>e.target).value));

    // All input listener: update style and deselect the preset
    Object.values(controls).forEach((c) => {
      c.input!.addEventListener('input', () => {
        updateStyle();
        presetMenu.value = '';
        setCookie('pagy-wand-preset', '');
      });
    });

    // Start
    const preset     = getCookie('pagy-wand-preset') ?? 'Default';
    presetMenu.value = preset;
    applyPreset(preset);
  };

  function attachShadow() {
    const host = document.createElement('div');
    host.id    = 'pagy-wand-host';
    document.body.appendChild(host);
    // Append the gem-updated pagy.css, to override the user stylesheet
    const style   = document.createElement('style');
    style.id      = 'pagy-wand-default';
    const element = document.getElementById('pagy-wand')
    style.textContent = B64Decode(<string>element!.getAttribute("data-pagy-wand-default"));
    document.head.appendChild(style);

    const shadow     = host.attachShadow({ mode: 'closed' });
    shadow.innerHTML = `
      ${linkTags}
      <style>
        @font-face {
          font-display: block;
        }
        #panel select, #panel select option, #panel input[type="range"] {
          font-family: 'Nunito Sans', sans-serif !important;
          font-weight: 500;
          cursor: pointer;
        }
        #panel select, textarea {
          border-radius: 4px;
          border: none;
          box-shadow: 2px 2px 5px 0 rgba(0,0,0,0.3);
        }
        #panel {
          accent-color: ${baseColor};
          font-family: 'Nunito Sans', sans-serif !important;
          line-height: 1.2;
          border-radius: 20px;
          width: 350px;
          box-sizing: border-box;
          box-shadow: 12px 12px 25px 1px rgba(0,0,0, .4);
          position: fixed;
          z-index: 1000;
          overflow: hidden;
          transition: transform 1s ease;
        }
        #panel.initial {
          top: 0;
          left: 0;
          transform: translate(-50%, 0) scale(0.1) rotate(0deg);
        }
        #panel.centered {
          transform: translate(calc(50vw - 50%), calc(50vh - 50%)) scale(1) rotate(1080deg);
        }
        #panel pre, #panel code, #panel kbd, #panel samp {
          font-family: 'Ubuntu Sans Mono', monospace !important;
        }
        #top-bar {
          background-color: ${baseColor};
          padding: 6px ${padding}px 6px ${padding + 2}px;
          cursor: move;
          user-select: none;
          color: white;
          display: flex;
          align-items: center;
          justify-content: space-between;
        }
        #top-bar label {
          display: flex;
          align-items: center;
        }
        #top-bar label input[type="checkbox"] {
          display: none;
        }
        #title {
          color: ${pagyColor};
          font-family: 'Pattaya', sans-serif !important;
          font-size: 1.4rem;
          text-shadow: 1px 1px 0 rgba(0,0,0,1);
          margin-right: 2px;
          display: flex;
          align-items: center;
        }
        #preset-menu {
          border-radius: 20px !important;
          padding-left: 4px !important;
        }
        .switch-icon {
          font-size: 24px;
          font-weight: 200;
          cursor: pointer;
        }
        .selected-icon {
          color: ${pagyColor};
        }
        .content{
          overflow-y: auto;
          font-size: 0.8rem;
          color: black;
          background-color: rgba(220,220,220,.6);
          backdrop-filter: blur(14px);
          padding: ${padding}px;
          border-top: 2px solid ${pagyColor};
          border-bottom: 2px solid ${pagyColor};
          display: flex;
          justify-content: center; 
          align-items: center;    
          height: 484px;
        }
        #controls {  
          display: grid;
          grid-template-columns: auto auto;
          grid-column-gap: 5px;
          grid-row-gap: 1px;
        }
        #controls label {
          font-weight: 600;
          grid-column: 1;
          padding-right: 5px;
          white-space: nowrap;
          justify-self: end;
          align-self: center;
        }
        label[for="override"] {
          align-self: start !important;
          margin-top: 5px;
        }
        #brightness {
          margin: 2px;
        }
        #override {
          font-family: "Ubuntu Sans Mono", monospace !important;
          font-size: .8rem;
          font-weight: 400;
          line-height: 1.1;
          height: 185px;
          resize: vertical;
          margin: 3px;
        }
        .help-icon {
          font-size: 1rem;
          vertical-align: -25%;
          border-radius: 15%;
          color: white;
          background-color: ${baseColor};
          margin-top: 0.2rem;
          padding: 2px 1px 1px 1px;
        }
        .selected-help-icon {
          color: ${pagyColor};
        }
        #help {
          display: none;
          line-height: 1rem;
        }
        #help h3 {
          font-size: 1rem;
          margin-top: 0;
          margin-bottom: .2rem;
        }
        #help > h4:first-child {
          margin-top: 0;
        }
        #help h4 {
          text-align: right;
          padding: 4px 10px; 
          border-top-right-radius: 40px; /* large to ensure roundness */
          border-bottom-right-radius: 40px;
          background: linear-gradient(to right, rgba(255,255,255,0), rgba(255,255,255, 1));
          margin-top: 1rem;
          margin-bottom: .5rem;
        }
        #help p {
          margin-top: .4rem;
          margin-bottom: .3rem;
        }
        #help dl {
          margin: 0;
        }
        #help dt {
          font-weight: bold;
          margin: .4rem 0 .1rem 0;
        }
        #help dd {
          margin-bottom: .15rem;
          margin-left: 1rem;
        }
        #help .button-desc {
          margin-left: .4rem;
        }
        #help code {
          font-family: "Ubuntu Sans Mono", monospace !important;
          display: inline-block;
          line-height: .8rem;
          border-radius: 10px;
          background-color: white;
          padding: 1px 5px;
        } 
      </style>
      <div id="panel">
        <div id="top-bar">
          <span id="title">PagyWand</span>
          <label for="preset-menu">
            <select id="preset-menu">
              <option value="" disabled>Presets...</option>
            </select>
          </label>
          <label for="controls-chk">
            <input id="controls-chk" type="checkbox">
            <span class="material-symbols-outlined switch-icon" id="controls-icon">tune</span>
          </label>
          <label for="help-chk">
            <input id="help-chk" type="checkbox">
            <span class="material-symbols-outlined switch-icon" id="help-icon">help</span>
          </label>
          <label for="live-chk">
            <input id="live-chk" type="checkbox" checked>
            <span class="material-symbols-outlined switch-icon" id="live-icon">visibility</span>
          </label>
        </div>
        <div id="content">
          <div class="content" id="controls">
            <label for="brightness">Brightness</label>
            <select id="brightness">
              <option value="1">Light</option>
              <option value="-1">Dark</option>
            </select>
            <label for="hue">Hue</label>
            <input type="range" id="hue" min="0" max="360">
            <label for="saturation">Saturation</label>
            <input type="range" id="saturation" min="0" max="100">
            <label for="lightness">Lightness</label>
            <input type="range" id="lightness" min="0" max="100">
            <label for="spacing">Spacing</label>
            <input type="range" id="spacing" min="0" max="1.5" step="0.0625">
            <label for="padding">Padding</label>
            <input type="range" id="padding" min="0" max="1.5" step="0.0625">
            <label for="rounding">Rounding</label>
            <input type="range" id="rounding" min="0" max="3" step="0.0625">
            <label for="borderWidth">Border Width</label>
            <input type="range" id="borderWidth" min="0" max="0.25" step="0.03125">
            <label for="fontSize">Font Size</label>
            <input type="range" id="fontSize" min="0.75" max="2" step="0.0625">
            <label for="fontWeight">Font Weight</label>
            <input type="range" id="fontWeight" min="100" max="1000" step="50">
            <label for="lineHeight">Line Height</label>
            <input type="range" id="lineHeight" min="1.25" max="2.5" step="0.0625">
            <label for="override">CSS Override</label>
            <textarea id="override" rows="5" cols="40" readonly></textarea>
          </div>
          <div id="help" class="content">
            <h4>Install</h4>
              <dl>
                <dt>Load it in HTML head</dt>
                <dd><code><%== Pagy.wand_tag %></code>
                </dd>
              </dl>
            <h4>Panel</h4>
            <dl>
              <dt>Move</dt>
                <dd>Drag the TOP Bar.</dd>
              <dt>Top Bar Indicators</dt>
                <dd>
                  <ul style="list-style-type: none; padding-left: 0; margin: 0;">
                    <li><span class="material-symbols-outlined help-icon">tune</span> <span class="material-symbols-outlined help-icon selected-help-icon">tune</span><span class="button-desc">Expand/collapse the Controls Section</span></li>
                    <li><span class="material-symbols-outlined help-icon">help</span> <span class="material-symbols-outlined help-icon selected-help-icon">help</span><span class="button-desc">Expand/collapse the Help Section</span></li>
                        <span class="material-symbols-outlined help-icon">visibility</span> <span class="material-symbols-outlined help-icon">visibility_off</span><span class="button-desc">Enable/disable the Live Style</span></li>
                  </ul>
                </dd>
              <dt>Close Icon</dt>
                <dd>There is no dynamic close button by design.</dd>
            </dl>
            <h4>Controls</h4>
            <dl>
              <dt>Presets</dt>
                <dd>Pick a starting point to try and further customize.</dd>
              <dt>Brightness</dt>
                <dd>Toggle between Light and Dark theming. Adjust the lightness after toggling.</dd>
              <dt>Hue, Saturation, Lightness</dt>
                <dd>Adjust them to generate any color, however notice that the automatic calculations work better within certain ranges and combinations.</dd>
              <dt>Padding, Font Size, Line Height</dt>
                <dd>You can control the relative dimensions of the page links, through the interactions of these properties.</dd>
              <dt>Other Properties</dt>
                <dd>Self-explanatory.</dd>
            </dl>
            <h4>Customizing</h4>
            <p>You can change Pagy's styling quite radically, by just setting a few CSS Custom Properties:
              the <code><i>pagy.css</i></code> or <code><i>pagy-tailwind.css</i></code> calculates all the other metrics.</p>
            <p>Pick a Presets as a starting point, customize it with the controls,
              and copy/paste the CSS Override in your Stylesheet.</p>
            <p>You can add further customization to the <code>.pagy</code> CSS Override, or maybe
            override the calculated properties for full control over the final style.</p>
            <p><b>Important</b>: Do not link the Pagy CSS file. Copy its customized content in your CSS, in order to avoid unwanted 
            cosmetic changes that could happen on update.</p>
          </div>
        </div>
      </div>
    `;
    initialize(shadow);
  };
  document.addEventListener('DOMContentLoaded', attachShadow);
})();
