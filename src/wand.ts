type Controls = {
  [key: string]: {
    name:   string;
    unit:   string;
    input?: HTMLInputElement;
  };
};
type Presets = { [key: string]: string };

(() => {
  // Load ASAP
  const icons    = 'help,tune,visibility,visibility_off';  // Alpha sorted icon names
  const linkTags = `
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Pattaya&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=${icons}&display=block" />
  `
  document.head.insertAdjacentHTML('beforeend', linkTags);
  // Cookie handling
  const B64SafeEncode = (unicode:string) => btoa(String.fromCharCode(...(new TextEncoder).encode(unicode)))
                                            .replace(/[+/=]/g, (m) => m == "+" ? "-" : m == "/" ? "_" : "");
  const B64Decode     = (base64:string) => (new TextDecoder()).decode(Uint8Array.from(atob(base64), c => c.charCodeAt(0)));

  const encodeBool    = (bool:boolean) =>  bool ? 'true' : 'false';
  const decodeBool    = (str:string) => str === 'true';

  // Cookie names
  const PRESET       = 'pagy-wand-preset';
  const OVERRIDE     = 'pagy-wand-override';
  const POSITION     = 'pagy-wand-position';
  const CONTROLS_CHK = 'pagy-wand-controls-chk';
  const HELP_CHK     = 'pagy-wand-help-chk';
  const LIVE_CHK     = 'pagy-wand-live-chk';

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
    const styleTagOverride = document.createElement('style');
    styleTagOverride.id    = 'pagy-wand-ovrride';
    document.head.appendChild(styleTagOverride);

    const panel      = <HTMLElement>shadow.getElementById('panel');
    const topBar     = <HTMLElement>shadow.getElementById('top-bar');
    const presetMenu = <HTMLSelectElement>shadow.getElementById('preset-menu');

    const controlsChk   = <HTMLInputElement>shadow.getElementById('controls-chk');
    controlsChk.checked = decodeBool(getCookie(CONTROLS_CHK) ?? 'false');
    const controlsIcon  = <HTMLElement>shadow.getElementById('controls-icon');
    const controlsDiv   = <HTMLElement>shadow.getElementById('controls');

    const helpChk   = <HTMLInputElement>shadow.getElementById('help-chk');
    helpChk.checked = decodeBool(getCookie(HELP_CHK) ?? 'false');
    const helpIcon  = <HTMLElement>shadow.getElementById('help-icon');
    const helpDiv   = <HTMLElement>shadow.getElementById('help');

    const liveChk   = <HTMLInputElement>shadow.getElementById('live-chk');
    liveChk.checked = decodeBool(getCookie(LIVE_CHK) ?? 'true');
    const liveIcon  = <HTMLElement>shadow.getElementById('live-icon');
    const liveStyle = <HTMLStyleElement>document.getElementById('pagy-wand-default');

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
      c.input!.addEventListener('input', () => {
        updateStyle();
        presetMenu.value = '';
        setCookie(PRESET, '');
      });
    }

    // PresetMenu
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
    // Setup preset options
    for (const presetName in presets) {
      const option       = document.createElement('option');
      option.value       = presetName;
      option.textContent = presetName;
      presetMenu.appendChild(option);
    }

    function applyPreset(name:string | null) {
      const css = name
                  ? (deleteCookie(OVERRIDE), presets[name])
                  : getCookie(OVERRIDE);
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
      });
      setCookie(PRESET, name || '');
      updateStyle();
    }
    presetMenu.addEventListener('change', (e) => applyPreset((<HTMLSelectElement>e.target).value));
    const preset     = getCookie(PRESET) ?? 'Default';
    presetMenu.value = preset;
    applyPreset(preset);

    // Style handling
    function updateStyle() {
      let override = `.pagy {\n`;
      Object.values(controls).forEach((c) => {
        override += `  ${c.name}: ${c.input!.value}${c.unit};\n`;
      });
      override += '}';
      (<HTMLTextAreaElement>shadow.getElementById('override'))!.value = override;
      styleTagOverride.textContent = liveChk.checked ? override : '';
      setCookie(OVERRIDE, override);
    }

    function getCookiePosition() {
      const position = getCookie(POSITION);
      if (position) {
        const [left, top] = position.split(',');
        return { left: parseInt(left), top: parseInt(top) };
      }
      return null;
    }

    // Position handling
    function setCookiePosition(left: string|number, top: string|number) {
      setCookie(POSITION, `${left},${top}`);
    }

    const viewport = () => ({
      width:  window.visualViewport ? window.visualViewport.width  : document.documentElement.clientWidth,
      height: window.visualViewport ? window.visualViewport.height : document.documentElement.clientHeight,
    });

    function keepTopBarInView() {
      const v = viewport();
      const rect = topBar.getBoundingClientRect();
      // Check if topBar is off-screen horizontally
      if (rect.left < 0) {
        panel.style.left = '0px';
      } else if (rect.right > v.width) {
        panel.style.left = `${v.width - topBar.offsetWidth}px`;
      }
      // Check if topBar is off-screen vertically
      if (rect.top < 0) {
        panel.style.top = '0px';
      } else if (rect.bottom > v.height) {
        panel.style.top = `${v.height - topBar.offsetHeight}px`;
      }
      // Ensure the top bar is in view
      if (rect.top < 0 && topBar.offsetHeight < v.height) {
        panel.style.top = '0px';
      }
      setCookiePosition(rect.left, rect.top);
    }

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
          setCookiePosition(rect.left, rect.top);
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
      setCookie(CONTROLS_CHK, encodeBool(controlsChk.checked));
    }
    controlsSwitcher();
    controlsChk.addEventListener('change', controlsSwitcher);

    // Help
    function helpSwitcher() {
      if (helpChk.checked) {  // show help
        helpIcon.classList.add('selected-icon');
        helpDiv.style.display = 'block';
        controlsChk.checked   = false;
        controlsSwitcher();
      } else {                // hide help
        helpIcon.classList.remove('selected-icon');
        helpDiv.style.display = 'none';
      }
      setCookie(HELP_CHK, encodeBool(helpChk.checked));
    }
    helpSwitcher();
    helpChk.addEventListener('change', helpSwitcher);

    // Live
    function liveSwitcher() {
      if (liveChk.checked) { // enabled
        liveIcon.classList.add('selected-icon');
        liveIcon.textContent = 'visibility';
        liveStyle.disabled   = false;
      } else {               // disabled
        liveIcon.classList.remove('selected-icon');
        liveIcon.textContent = 'visibility_off';
        liveStyle.disabled   = true;
      }
      updateStyle(); // take care of the override if not checked
      setCookie(LIVE_CHK, encodeBool(liveChk.checked));
    }
    liveSwitcher();
    liveChk.addEventListener('change', liveSwitcher);
  }

  function attachShadow() {
    const padding   = 0.75;
    const baseColor = '#484848';
    const pagyColor = 'lightsalmon';
    const host = document.createElement('div');
    host.id    = 'pagy-wand-host';
    document.body.appendChild(host);
    // Set the scaling
    const scale = (document.getElementById("pagy-wand"))!.getAttribute("data-scale");
    const style = <HTMLElement>document.getElementById('pagy-wand-default')
    document.head.appendChild(style);
    const shadow     = host.attachShadow({ mode: 'closed' });
    // Append the gem-updated pagy.css, to override the user stylesheet
    shadow.innerHTML = `
      ${linkTags}
      <style>
        @font-face {
          font-display: block;
        }
        #panel select, #panel select option, #panel input[type="range"] {
          font-family: 'Nunito Sans', sans-serif;
          font-weight: 500;
          cursor: pointer;
        }
        #panel select, textarea {
          border-radius: 0.25rem;
          border: none;
          box-shadow: 0.125rem 0.125rem 0.3125rem 0 rgba(0,0,0,0.3);
        }
        #panel {
          accent-color: ${baseColor};
          font-family: 'Nunito Sans', sans-serif;
          line-height: 1.2;
          border-radius: 1.25rem;
          width: 22rem;
          box-sizing: border-box;
          box-shadow: 0.75rem 0.75rem 1.5625rem 0.0625rem rgba(0,0,0,.4);
          position: fixed;
          z-index: 1000;
          overflow: hidden;
          transform: scale(${scale});
          transition: transform 1s ease;
        }
        #panel.initial {
          top: 0;
          left: 0;
          transform: translate(-50%, 0) scale(0.1) rotate(0deg);
        }
        #panel.centered {
          transform: translate(calc(50vw - 50%), calc(50vh - 50%)) scale(${scale}) rotate(1080deg);
        }
        #panel pre, #panel code, #panel kbd, #panel samp {
          font-family: 'Ubuntu Sans Mono', monospace;
        }
        #top-bar {
          background: linear-gradient(to bottom,
            #1a1a1a 0%,      /* Fading Further */
            #2b2b2b 5%,      /* Fading to Mid-Tone */
            #404040 10%,     /* Soft Highlight */
            #525252 20%,     /* Highlight Transition */
            #404040 40%,     /* Mid-Tone (Lighter) */
            #2b2b2b 60%,     /* Mid-Tone (Darker) */
            #1a1a1a 80%,     /* Core Shadow */
            #0d0d0d 92%,     /* Deep Shadow */
            #000000 100%     /* Darkest Shadow */
            );
          padding: 0.25rem ${padding}rem 0.25rem calc(${padding}rem + 0.125rem);
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
          font-family: 'Pattaya', sans-serif;
          font-size: 1.4rem;
          text-shadow: 0.0625rem 0.0625rem 0 rgba(0,0,0,1);
          margin-right: 0.125rem;
        }
        #preset-menu {
          border-radius: 1.25rem !important;
          padding-left: 0.25rem !important;
        }
        .switch-icon {
          font-size: 1.5rem;
          font-weight: 300;
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
          backdrop-filter: blur(0.875rem);
          padding: ${padding}rem;
          border-top: 0.125rem solid ${pagyColor};
          border-bottom: 0.125rem solid ${pagyColor};
          display: flex;
          justify-content: center;
          align-items: center;
          height: 30rem;
        }
        #controls {
          display: grid;
          grid-template-columns: auto auto;
          grid-column-gap: 0.625rem;
        }
        #controls label {
          font-weight: 600;
          grid-column: 1;
          white-space: nowrap;
          justify-self: end;
          align-self: center;
        }
        label[for="override"] {
          align-self: start !important;
          margin-top: 0.375rem;
        }
        #brightness {
          margin: 0.125rem;
        }
        #override {
          font-family: "Ubuntu Sans Mono", monospace;
          font-size: .8rem;
          font-weight: 400;
          line-height: 1.1;
          height: 11.5625rem;
          resize: vertical;
          margin: 0.1875rem;
        }
        .help-icon {
          font-size: 1rem;
          vertical-align: -15.625%;
          border-radius: 15%;
          color: white;
          background-color: ${baseColor};
          margin-top: 0.2rem;
          padding: 0.125rem 0.0625rem 0.0625rem 0.0625rem;
          font-weight: 300;
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
          padding: 0.25rem 0.625rem;
          border-top-right-radius: 2.5rem;
          border-bottom-right-radius: 2.5rem;
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
          font-family: "Ubuntu Sans Mono", monospace;
          display: inline-block;
          line-height: .8rem;
          border-radius: 0.625rem;
          background-color: white;
          padding: 0.0625rem 0.3125rem;
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
            <span class="material-symbols-rounded switch-icon" id="controls-icon">tune</span>
          </label>
          <label for="help-chk">
            <input id="help-chk" type="checkbox">
            <span class="material-symbols-rounded switch-icon" id="help-icon">help</span>
          </label>
          <label for="live-chk">
            <input id="live-chk" type="checkbox" checked>
            <span class="material-symbols-rounded switch-icon" id="live-icon">visibility</span>
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
            <h4>Wand</h4>
            <dl>
              <dt>Move</dt>
                <dd>Drag the Wand.</dd>
              <dt>Top Bar Indicators</dt>
                <dd>
                  <ul style="list-style-type: none; padding-left: 0; margin: 0;">
                    <li><span class="material-symbols-rounded help-icon">tune</span> <span class="material-symbols-rounded help-icon selected-help-icon">tune</span><span class="button-desc">Toggle the Controls Section</span></li>
                    <li><span class="material-symbols-rounded help-icon">help</span> <span class="material-symbols-rounded help-icon selected-help-icon">help</span><span class="button-desc">Toggle the Help Section</span></li>
                        <span class="material-symbols-rounded help-icon">visibility_off</span> <span class="material-symbols-rounded help-icon selected-help-icon">visibility</span><span class="button-desc">Toggle the Live Preview</span></li>
                  </ul>
                </dd>
              <dt>Presets</dt>
                <dd>Pick a starting point to try and further customize.</dd>
              <dt>Close Icon</dt>
                <dd>There is no dynamic close button by design.</dd>
            </dl>
            <h4>Controls</h4>
            <dl>
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
  }
  document.addEventListener('DOMContentLoaded', attachShadow);
})();
