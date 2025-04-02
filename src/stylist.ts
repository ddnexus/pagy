type VariableMap = {
  [key: string]: {
    name:   string;
    unit:   string;
    input?: HTMLInputElement;
  };
};
type Presets = { [key: string]: string };

(() => {
  const roundness = 12;
  // Alpha sorted icon names
  const icons    = 'compress,expand,help,tune,visibility,visibility_off';
  const linkTags = `
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@300&icon_names=${icons}&display=block">
  `
  document.head.insertAdjacentHTML('beforeend', linkTags);
  // Cookie handling
  const B64SafeEncode = (unicode:string) => btoa(String.fromCharCode(...(new TextEncoder).encode(unicode)))
                                            .replace(/[+/=]/g, (m) => m == "+" ? "-" : m == "/" ? "_" : "");
  const B64Decode     = (base64:string) => (new TextDecoder()).decode(Uint8Array.from(atob(base64), c => c.charCodeAt(0)));
  const deleteCookie  = (name:string) => (document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`);
  const setCookie     = (name:string, value:string) => document.cookie = `${name}=${B64SafeEncode(value)}; path=/`;
  const getCookie     = (name:string):string | null => {
    const cookieName  = `${name}=`;
    const cookieArray = document.cookie.split(';');
    for (let i = 0; i < cookieArray.length; i++) {
      let cookie = cookieArray[i].trim();
      if (cookie.startsWith(cookieName)) {
        return B64Decode(cookie.substring(cookieName.length));
      }
    }
    return null;
  };
  const encodeBool = (bool:boolean) =>  bool ? 'true' : 'false';
  const decodeBool = (str:string) => str === 'true';

  const stylistInit = (shadow: ShadowRoot) => {
    // Create override style tag as the last tag in <head>
    const styleTag = document.createElement('style');
    styleTag.id    = 'pagy-stylist-override';
    document.head.appendChild(styleTag);

    let variables:VariableMap = {
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
    for (const [id, v] of Object.entries(variables)) {
      v.input = <HTMLInputElement>shadow.getElementById(id);
    }

    const updateStyle = () => {
      let override = `.pagy {\n`;
      Object.values(variables).forEach((v) => {
        override += `  ${v.name}: ${v.input!.value}${v.unit};\n`;
      });
      override += '}';
      const overrideArea        = <HTMLTextAreaElement>shadow.getElementById('override');
      const overrideStyle       = <HTMLStyleElement>document.getElementById('pagy-stylist-override');
      overrideArea.value        = override;
      overrideStyle.textContent = override;
      setCookie('pagy-stylist-override', override);
    };

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

    const applyPreset = (name:string | null) => {
      const css = name
                  ? (deleteCookie('pagy-stylist-override'), presets[name])
                  : getCookie('pagy-stylist-override');
      css?.match(/--[^:]+:\s*[^;]+/g)?.forEach((match) => {
        let [name, value] = match.split(':');
        name  = name.trim();
        value = value.trim().replace(/[a-zA-Z%]+$/, '');
        for (const v of Object.values(variables)) {
          if (v.name === name) {
            v.input!.value = value;
            break;
          }
        }
      });
      setCookie('pagy-stylist-preset', name || '');
      updateStyle();
    };
    presetMenu.addEventListener('change', (e) => applyPreset((<HTMLSelectElement>e.target).value));

    // Event listeners
    const deselectDropdown = () => {
      presetMenu.value = '';
      setCookie('pagy-stylist-preset', '');
    };
    Object.values(variables).forEach((v) => {
      v.input!.addEventListener('input', updateStyle);
      v.input!.addEventListener('input', deselectDropdown);
    });

    // Start
    const preset     = getCookie('pagy-stylist-preset') ?? 'Default';
    presetMenu.value = preset;
    applyPreset(preset);
  };


  const panelInit = (shadow: ShadowRoot) => {
    const panel  = <HTMLElement>shadow.getElementById('panel');
    const topBar = <HTMLElement>shadow.getElementById('top-bar');

    // Panel position
    const getCookiePosition = () => {
      const position = getCookie('pagy-stylist-position');
      if (position) {
        const [left, top] = position.split(',');
        return { left: parseInt(left), top: parseInt(top) };
      }
      return null;
    };
    const setCookiePosition = (left: string|number, top: string|number) => {
      setCookie('pagy-stylist-position', `${left},${top}`);
    };
    const viewport = () => {
      return { width: window.visualViewport ? window.visualViewport.width : document.documentElement.clientWidth,
               height: window.visualViewport ? window.visualViewport.height : document.documentElement.clientHeight }
    }
    const keepTopBarInView = () => {
      const v = viewport();
      const topBarRect     = topBar.getBoundingClientRect();
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
    window.addEventListener('resize', keepTopBarInView);

    const position = getCookiePosition();
    if (position) {
      panel.style.left = `${position.left}px`;
      panel.style.top  = `${position.top}px`;
    } else {
      const v = viewport();
      panel.style.left = `${(v.width - panel.offsetWidth) / 2}px`;
      panel.style.top  = `${(v.height - panel.offsetHeight) / 2}px`;
      keepTopBarInView();
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


    // Toggle content
    const contentChk   = <HTMLInputElement>shadow.getElementById('content-chk');
    contentChk.checked = decodeBool(getCookie('pagy-stylist-content-chk') ?? 'true');
    const contentIcon  = <HTMLElement>shadow.getElementById('content-icon');
    const contentDiv   = <HTMLElement>shadow.getElementById('content');
    const contentSwitcher = () => {
      if (contentChk.checked) {  // compress
        contentIcon.textContent  = 'compress';
        contentDiv.style.display = 'block';
      } else {                   // expand
        contentIcon.textContent  = 'expand';
        contentDiv.style.display = 'none';
      }
      setCookie('pagy-stylist-content-chk', encodeBool(contentChk.checked));
    };
    contentChk.addEventListener('change', contentSwitcher);
    contentSwitcher();

    // Toggle Stylist
    const stylistChk           = <HTMLInputElement>shadow.getElementById('stylist-chk');
    stylistChk.checked         = decodeBool(getCookie('pagy-stylist-stylist-chk') ?? 'true');
    const stylistIcon          = <HTMLElement>shadow.getElementById('stylist-icon');
    const stylistStyle         = <HTMLStyleElement>document.getElementById('pagy-stylist-default');
    const stylistStyleOverride = <HTMLStyleElement>document.getElementById('pagy-stylist-override');
    const stylistSwitcher = () => {
      if (stylistChk.checked) {       // enable stylist
        stylistIcon.textContent       = 'visibility_off';
        stylistStyle.disabled         = false;
        stylistStyleOverride.disabled = false;
      } else {                        // disable stylist
        stylistIcon.textContent       = 'visibility';
        stylistStyle.disabled         = true;
        stylistStyleOverride.disabled = true;
      }
      setCookie('pagy-stylist-stylist-chk', encodeBool(stylistChk.checked));
    };
    stylistChk.addEventListener('change', stylistSwitcher);
    stylistSwitcher();

    // Toggle controls
    const controlsChk   = <HTMLInputElement>shadow.getElementById('controls-chk');
    controlsChk.checked = decodeBool(getCookie('pagy-stylist-controls-chk') ?? 'true');
    const controlsIcon  = <HTMLElement>shadow.getElementById('controls-icon');
    const controlsDiv   = <HTMLElement>shadow.getElementById('controls');
    const helpDiv       = <HTMLElement>shadow.getElementById('help');
    const controlsSwitcher = () => {
      if (controlsChk.checked) {  // show controls
        controlsIcon.textContent  = 'help';
        helpDiv.style.display     = 'none';
        controlsDiv.style.display = 'grid';
      } else {                    // show help
        controlsIcon.textContent  = 'tune';
        helpDiv.style.display     = 'block';
        helpDiv.style.height      = `${controlsDiv.clientHeight - roundness * 2}px`; // Match panel height
        controlsDiv.style.display = 'none';
      }
      setCookie('pagy-stylist-controls-chk', encodeBool(controlsChk.checked));
    };
    controlsChk.addEventListener('change', controlsSwitcher);
    controlsChk.addEventListener('click', () => {
      if (!contentChk.checked) {  // expand content first
        contentChk.checked = true;
        contentSwitcher();
      }
    });
    controlsSwitcher();
  };

  const attachShadow = () => {
    const host = document.createElement('div');
    host.id    = 'pagy-stylist-host';
    document.body.appendChild(host);
    // Append the gem updated pagy.css, to override user app
    const style   = document.createElement('style');
    style.id      = 'pagy-stylist-default';
    const element = document.getElementById('pagy-stylist')
    style.textContent = B64Decode(<string>element!.getAttribute("data-pagy-stylist-default"));
    document.head.appendChild(style);

    const shadow     = host.attachShadow({ mode: 'open' });
    shadow.innerHTML = `
      ${linkTags}
      <style>
        :host {
          --base-color: #505050;
        }
        @font-face {
          font-display: block;
        }
        #panel select, #panel select option, #panel input[type="range"] {
          font-family: 'Nunito Sans', sans-serif !important;
          cursor: pointer;
        }
        #panel select, textarea {
          border-radius: 4px;
          border: none;
          box-shadow: 2px 2px 5px 0 rgba(0,0,0,0.3);
        }
        #panel {
          accent-color: var(--base-color);
          font-family: 'Nunito Sans', sans-serif !important;
          line-height: 1.2;
          border-radius: ${roundness}px;
          width: 350px;
          box-sizing: border-box;
          box-shadow: 12px 12px 25px 0 rgba(0,0,0,0.3);
          position: fixed;
          z-index: 1000;
          overflow: hidden;
        }
        #panel pre, #panel code, #panel kbd, #panel samp {
          font-family: 'Ubuntu Sans Mono', monospace !important;
        }
        #top-bar {
          background-color: var(--base-color);
          padding: 8px ${roundness + 2}px;
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
          font-weight: 600;
        }
        .switch-icon {
          font-size: 24px;
          font-weight: 200;
          cursor: pointer;
        }
        .content{
          overflow-y: auto;
          font-size: 0.8rem;
          color: black;
          background-color: rgba(220,220,220,.6);
          backdrop-filter: blur(14px);
          padding: ${roundness}px;
        }
        #controls {  
          display: grid;
          grid-template-columns: auto auto;
          grid-column-gap: 5px;
          grid-row-gap: 3px;
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
          margin-top: 4px;
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
          background-color: var(--base-color);
          margin-top: 0.2rem;
          padding: 2px 1px 1px 1px;
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
          <span id="title">Pagy Stylist</span>
          <label for="content-chk">
            <input id="content-chk" type="checkbox" checked>
            <span class="material-symbols-outlined switch-icon" id="content-icon">compress</span>
          </label>
          <label for="stylist-chk">
            <input id="stylist-chk" type="checkbox" checked>
            <span class="material-symbols-outlined switch-icon" id="stylist-icon">visibility_off</span>
          </label>
          <label for="controls-chk">
            <input id="controls-chk" type="checkbox" checked>
            <span class="material-symbols-outlined switch-icon" id="controls-icon">help</span>
          </label>
          <label for="preset-menu">
            <select id="preset-menu">
              <option value="" disabled>Presets...</option>
            </select>
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
                <dd><code><%== Pagy.stylist_tag %></code>
                </dd>
              </dl>
            <h4>Panel</h4>
            <dl>
              <dt>Move</dt>
                <dd>Drag the TOP Bar.</dd>
              <dt>Top Bar Buttons</dt>
                <dd>
                  <ul style="list-style-type: none; padding-left: 0; margin: 0;">
                    <li><span class="material-symbols-outlined help-icon">compress</span>
                       <span class="material-symbols-outlined help-icon">expand</span><span class="button-desc">Collapse/Expand the content</span></li>
                    <li><span class="material-symbols-outlined help-icon">help</span>
                       <span class="material-symbols-outlined help-icon">tune</span><span class="button-desc">Toggle the Help/Controls content</span></li>
                    <li><span class="material-symbols-outlined help-icon">visibility_off</span>
                       <span class="material-symbols-outlined help-icon">visibility</span><span class="button-desc">Hide/Show the added Live Style</span></li>
                  </ul>
                </dd>
              <dt>Close Button</dt>
                <dd>There is no dynamic close button by design. Use the 
                Collapse button to make it less invasive during Pagy customization.</dd>
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
            <p><b>Important</b>: Do not link the Pagy CSS file. Copy its customized content in your CSS to avoid unwanted 
            cosmetic changes that could happen on update.</p>
          </div>
        </div>
      </div>
    `;

    stylistInit(shadow);
    panelInit(shadow);
  };
  document.addEventListener('DOMContentLoaded', attachShadow);
})();
