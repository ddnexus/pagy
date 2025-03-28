type VariableMap = {
  [key: string]: {
    name:   string;
    unit:   string;
    input?: HTMLInputElement;
  };
};
type Presets = { [key: string]: string };

(() => {
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

  const contentPadding = 16;

  const panelInit = (shadowRoot: ShadowRoot) => {
    const overlay    = <HTMLElement>shadowRoot.getElementById('overlay');
    const panel      = <HTMLElement>shadowRoot.getElementById('panel');
    const topBar     = <HTMLElement>shadowRoot.getElementById('top-bar');
    const toggle     = <HTMLElement>shadowRoot.getElementById('toggle');
    const controlsDiv = <HTMLElement>shadowRoot.getElementById('controls');
    const helpIcon   = <HTMLElement>shadowRoot.getElementById('help-icon');
    const helpDiv    = <HTMLElement>shadowRoot.getElementById('help');

    // Panel position
    const getPanelPosition = () => {
      const position = getCookie('pagy-tweaker-position');
      if (position) {
        const [left, top] = position.split(',');
        return { left: parseInt(left), top: parseInt(top) };
      }
      return null;
    };
    const setPanelPosition = (left: number, top: number) => {
      setCookie('pagy-tweaker-position', `${left},${top}`);
    };

    const keepPanelInView = () => {
      const left = parseInt(panel.style.left);
      const top  = parseInt(panel.style.top);

      const panelRect = panel.getBoundingClientRect();
      // Check if panel is off-screen horizontally
      if (panelRect.left < 0) {
        panel.style.left = '0px';
      } else if (panelRect.right > window.innerWidth) {
        panel.style.left = `${window.innerWidth - panel.offsetWidth}px`;
      }
      // Check if panel is off-screen vertically
      if (panelRect.top < 0) {
        panel.style.top = '0px';
      } else if (panelRect.bottom > window.innerHeight) {
        panel.style.top = `${window.innerHeight - panel.offsetHeight}px`;
      }
      // Ensure the top bar is in view
      if (panelRect.top < 0 && panel.offsetHeight < window.innerHeight) {
        panel.style.top = '0px';
      }
      setPanelPosition(left, top);
    };
    window.addEventListener('resize', keepPanelInView);

    const position = getPanelPosition();
    if (position) {
      panel.style.left = `${position.left}px`;
      panel.style.top  = `${position.top}px`;
    } else {
      panel.style.left = `${(window.innerWidth - panel.offsetWidth) / 2}px`;
      panel.style.top  = `${(window.innerHeight - panel.offsetHeight) / 2}px`;
      keepPanelInView();
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
    panel.addEventListener('mousedown', (e) => {
      if (!(e.target === topBar || e.ctrlKey || e.metaKey)) return;

      dragging = true;
      offsetX  = e.clientX - panel.offsetLeft;
      offsetY  = e.clientY - panel.offsetTop;
    });
    document.addEventListener('mousemove', (e) => {
      if (!dragging) return;

      panel.style.left = `${e.clientX - offsetX}px`;
      panel.style.top  = `${e.clientY - offsetY}px`;
      setPanelPosition(e.clientX - offsetX, e.clientY - offsetY);
    });
    document.addEventListener('mouseup', () => dragging = false);

    // Add event listeners to control overlay visibility based on ctrl key press
    document.addEventListener('keydown', (e) => {
      if (e.ctrlKey || e.metaKey) {
        overlay.style.display = 'block'; // Show overlay
        overlay.style.width   = `${panel.offsetWidth}px`;  // Match panel width
        overlay.style.height  = `${panel.offsetHeight}px`; // Match panel height
      }
    });
    document.addEventListener('keyup', (e) => {
      if (!e.ctrlKey && !e.metaKey) {
        overlay.style.display = 'none'; // Hide overlay
      }
    });

    // Control Toggle
     const toggleControlDiv = () => {
       if (controlsDiv.style.display !== 'none' || helpDiv.style.display !== 'none') {
         controlsDiv.style.display = 'none';
         helpDiv.style.display = 'none';
       } else {
         helpDiv.style.display = 'block';
         controlsDiv.style.display = 'grid';
       }
     }

    toggle.addEventListener('click', toggleControlDiv);
    topBar.addEventListener('dblclick', toggleControlDiv);

    // Help Toggle
    helpIcon.addEventListener('click', () => {
      helpDiv.style.display    = 'block';
      helpDiv.style.height     = `${controlsDiv.clientHeight - contentPadding * 2}px`; // Match panel height
      controlsDiv.style.display = 'none';
    });
    helpDiv.addEventListener('click', () => {
      helpDiv.style.display    = 'none';
      controlsDiv.style.display = 'grid';
    });
  }

  const tweakerInit = (shadowRoot: ShadowRoot) => {
    // Create override style tag as the last tag in <head>
    const styleTag = document.createElement('style');
    styleTag.id    = 'pagy-tweaker-override-style-tag';
    document.head.appendChild(styleTag);

    let variables:VariableMap = {
      brightness:  { name: '--B',            unit: ''    },
      hue:         { name: '--H',            unit: ''    },
      saturation:  { name: '--S',            unit: ''    },
      lightness:   { name: '--L',            unit: ''    },
      opacity:     { name: '--opacity',      unit: ''    },
      spacing:     { name: '--spacing',      unit: 'rem' },
      padding:     { name: '--padding',      unit: 'rem' },
      rounding:    { name: '--rounding',     unit: 'rem' },
      borderWidth: { name: '--border-width', unit: 'rem' },
      fontSize:    { name: '--font-size',    unit: 'rem' },
      fontWeight:  { name: '--font-weight',  unit: ''    },
      lineHeight:  { name: '--line-height',  unit: ''    },
    };
    for (const [id, css] of Object.entries(variables)) {
      css.input = <HTMLInputElement>shadowRoot.getElementById(id);
    }

    const overrideStyleTag = <HTMLStyleElement>document.getElementById('pagy-tweaker-override-style-tag');
    const overrideDisplay  = <HTMLTextAreaElement>shadowRoot.getElementById('override');
    const updateCSS = () => {
      let override = `.pagy {\n`;
      Object.values(variables).forEach((css) => {
        override += `  ${css.name}: ${css.input!.value}${css.unit};\n`;
      });
      override += '}';
      overrideDisplay.value        = override;
      overrideStyleTag.textContent = override;
      setCookie('pagy-tweaker-override', override);
    };

    // PRESETS
    const presets:Presets = {
      Default: `
      .pagy {
        --B: 1;
        --H: 0;
        --S: 0;
        --L: 50;
        --opacity: 1;
        --spacing: 0.125rem;
        --rounding: 1.75rem;
        --padding: 0.75rem;
        --font-size: 0.875rem;
        --line-height: 1.75;
        --font-weight: 700;
        --border-width: 0rem;
      }
      `,
      Dark: `
      .pagy {
        --B: -1;
        --H: 0;
        --S: 0;
        --L: 60;
        --opacity: 1;
        --spacing: 0.125rem;
        --rounding: 1.75rem;
        --padding: 0.75rem;
        --font-size: 0.875rem;
        --line-height: 1.75;
        --font-weight: 700;
        --border-width: 0rem;
      }
      `,
      MidnighExpress: `
      .pagy {
        --B: -1;
        --H: 231;
        --S: 28;
        --L: 60;
        --opacity: 1;
        --spacing: 0.1875rem;
        --rounding: 0.375rem;
        --padding: 1rem;
        --font-size: 1rem;
        --line-height: 1.25;
        --font-weight: 450;
        --border-width: 0rem;
      }
      `,
      Pilloween:` 
      .pagy {
        --B: -1;
        --H: 10;
        --S: 80;
        --L: 50;
        --opacity: 1;
        --spacing: 0.375rem;
        --rounding: 1.125rem;
        --padding: 0.75rem;
        --font-size: 0.875rem;
        --line-height: 1.5;
        --font-weight: 700;
        --border-width: 0.0625rem;
      }
      `,
      Peppermint:`
      .pagy {
        --B: 1;
        --H: 78;
        --S: 70;
        --L: 38;
        --opacity: 1;
        --spacing: 0.1875rem;
        --rounding: 0.75rem;
        --padding: 0.625rem;
        --font-size: 0.875rem;
        --line-height: 1.75;
        --font-weight: 550;
        --border-width: 0rem;
      }
      `,
      CocoaBeans:`
      .pagy {
        --B: 1;
        --H: 27;
        --S: 63;
        --L: 17;
        --opacity: 1;
        --spacing: 0.0625rem;
        --rounding: 1.125rem;
        --padding: 0.5rem;
        --font-size: 0.875rem;
        --line-height: 2.5;
        --font-weight: 700;
        --border-width: 0rem;
      }
      `,
      PurpleStripe: `
      .pagy {
        --B: 1;
        --H: 255;
        --S: 63;
        --L: 39;
        --opacity: 1;
        --spacing: 0rem;
        --rounding: 0rem;
        --padding: 0.875rem;
        --font-size: 0.875rem;
        --line-height: 1.5;
        --font-weight: 300;
        --border-width: 0rem;
      }
      `,
      GhostInThought: `
      .pagy {
        --B: 1;
        --H: 174;
        --S: 40;
        --L: 70;
        --opacity: 1;
        --spacing: 0.125rem;
        --rounding: 1.125rem;
        --padding: 0.75rem;
        --font-size: 0.875rem;
        --line-height: 1.75;
        --font-weight: 450;
        --border-width: 0rem;
      }
      `,
      VintageScent:`
      .pagy {
        --B: 1;
        --H: 51;
        --S: 27;
        --L: 64;
        --opacity: 1;
        --spacing: 0.1875rem;
        --rounding: 0.75rem;
        --padding: 0.75rem;
        --font-size: 0.875rem;
        --line-height: 1.75;
        --font-weight: 300;
        --border-width: 0.0625rem;
      }
      `
    };
    const presetMenu = <HTMLSelectElement>shadowRoot.getElementById('preset-menu');
    // Setup preset options
    for (const presetName in presets) {
      const option       = document.createElement('option');
      option.value       = presetName;
      option.textContent = presetName;
      presetMenu.appendChild(option);
    }

    const applyPreset = (name:string | null) => {
      const css = name
                  ? (deleteCookie('pagy-tweaker-override'), presets[name])
                  : getCookie('pagy-tweaker-override');
      css?.match(/--[^:]+:\s*[^;]+/g)?.forEach((match) => {
        let [name, value] = match.split(':');
        name  = name.trim();
        value = value.trim().replace(/[a-zA-Z%]+$/, '');
        for (const css of Object.values(variables)) {
          if (css.name === name) {
            css.input!.value = value;
            break;
          }
        }
      });
      setCookie('pagy-tweaker-preset', name || '');
      updateCSS();
    };
    presetMenu.addEventListener('change', (e) => applyPreset((<HTMLSelectElement>e.target).value));

    // Event listeners
    const deselectDropdown = () => {
      presetMenu.value = '';
      setCookie('pagy-tweaker-preset', '');
    };
    Object.values(variables).forEach((css) => {
      css.input!.addEventListener('input', updateCSS);
      css.input!.addEventListener('input', deselectDropdown);
    });

    // Start
    const preset     = getCookie('pagy-tweaker-preset') ?? 'Default';
    presetMenu.value = preset;
    applyPreset(preset);
  };

  const attachShadow = () => {
    const host = document.createElement('div');
    host.id    = 'pagy-tweaker-host';
    document.body.appendChild(host);
    const shadow     = host.attachShadow({ mode: 'open' });
    shadow.innerHTML = `
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap" rel="stylesheet">
      <style>
        :host {
          --base-color: #505050;
        }
        #overlay {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(0, 0, 0, 0); /* Transparent */
          cursor: move;
          z-index: 10; /* Make sure it's on top of the panel */
          display: none; /* Initially hidden */
        }
        #panel {
          accent-color: var(--base-color);
          font-family: 'Nunito Sans', sans-serif;
          width: 350px;
          box-sizing: border-box;
          box-shadow: 12px 12px 25px 0 rgba(0,0,0,0.3);
          position: fixed;
          z-index: 1000;
        }
        pre, code, kbd, samp {
          font-family: 'Ubuntu Sans Mono', monospace;
        }
        #top-bar {
          border-top-left-radius: 5px;
          border-top-right-radius: 5px;
          background-color: var(--base-color);
          padding: 4px 10px;
          cursor: move;
          user-select: none;
          color: white;
          display: flex;
          align-items: center;
        }
        #title {
          font-weight: 600;
        }
        #toggle {
          margin-right: 12px;
          line-height: 1em;
          user-select: none;
          cursor: pointer;
          position: relative;
          z-index: 1
        }
        #toggle:before {
          content: '';
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          width: calc(100% + 14px);
          height: calc(100% + 12px);
          border-radius: 50%;
          background-color: white;
          opacity: 0;
          z-index: -1;
        }
        #toggle:hover:before {
          opacity: .16;
        }
        #preset-menu {
          margin-left: auto;
        }
        .panel-content{
          line-height: 1.1;
          color: black;
          background-color: rgba(220,220,220,.6);
          backdrop-filter: blur(14px);
          padding: ${contentPadding}px;
          font-size: 0.8rem;
        }
        #controls {
          display: grid;
          grid-template-columns: auto auto;
          grid-column-gap: 5px;
        }
        #controls label {
          font-weight: 600;
          grid-column: 1;
          text-align: right;
          padding-right: 5px;
          white-space: nowrap;
          position: relative;
        }
        #help-icon {
          width: 23px;
          height: 23px;
          background-color: var(--base-color);
          border-radius: 50%;
          display: flex;
          justify-content: center;
          align-items: center;
          font-size: 18px;
          font-weight: 500;
          font-family: 'Nunito Sans', sans-serif;
          color: white;
          position: absolute;
          bottom: 0;
          left: 0;
        }
        #help {
          display: none;
          overflow-y: auto;
        }
        #help h3 {
          font-size: 1rem;
          margin-top: 0;
          margin-bottom: .2rem;
        }
        #help h4 {
          text-align: right;
          padding: 4px 8px;
          background: linear-gradient(to right, rgba(255,255,255,0), rgba(255,255,255, 1));
          margin-top: 1rem;
          margin-bottom: .5rem;
        }
        #help p {
          margin-top: .5rem;
          margin-bottom: .4rem;
        }
        #help dl {
          margin: 0;
        }
        #help dt {
          font-weight: bold;
          margin-top: 0.4rem;
          margin-bottom: 0.2rem;
        }
        #help dd {
          margin-bottom: .15rem;
          margin-left: 1rem;
        }
        #brightness {
          margin: 0 2px;
        }
        #override {
          font-family: "Ubuntu Sans Mono", monospace;
          font-size: .8rem;
          font-weight: 400;
          line-height: 1.25;
          height: 235px;
          resize: vertical;
          margin: 2px;
        }
      </style>
      <div id="panel">
        <div id="top-bar">
          <span id="toggle">☰</span><span id="title">PagyTweaker</span>
          <label for="preset-menu" style="width:0;height:0;color:rgba(0,0,0,0);">&nbsp;</label>
          <select id="preset-menu">
            <option value="" disabled>Presets...</option>
          </select>
        </div>
        <div class="panel-content" id="controls">
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
          <label for="opacity">Opacity</label>
          <input type="range" id="opacity" min="0" max="1" step="0.01">
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
          <label for="override">CSS Override<span id="help-icon">?</span></label>
          <textarea id="override" rows="5" cols="40" readonly></textarea>
        </div>
        <div id="help" class="panel-content">
          <h4>Panel</h4>
          <dl>
            <dt>Install</dt>
              <dd><code><%== Pagy.tweaker_tag %></code></dd>
            <dt>Move</dt>
              <dd>Drag on the TOP Bar or anywhere with <code>Ctrl</code> or <code>Cmd</code> pressed.</dd>
            <dt>Collapse/Expand</dt>
              <dd>Click on the <b>☰</b> icon or double-click on the Top Bar.</dd>
          </dl>
          <h4>Customizing</h4>
          <p>You can change Pagy's styling quite radically, by just setting a few CSS Custom Properties:
            the <i>pagy.css</i> calculates all the other metrics.</p>
          <p>Pick a Presets as a starting point, customize it with the controls,
            and copy/paste the CSS Override in your Stylesheet.</p>
          <p>Override the calculations for full control over the final style.</p>
          <p><b>Important</b>: Do not link the <i>pagy.css</i> file. Copy its customized content in your CSS to avoid unwanted cosmetic changes on update.</p>
          <h4>Controls</h4>
          <dl>
            <dt>Presets dropdown</dt>
              <dd>Pick a starting point to further customize.</dd>
            <dt>Brightness</dt>
              <dd>Toggle the Light or Dark theming. Notice that when you toggle it, you should also adjust the lightness.</dd>
            <dt>Hue, Saturation, Lightness</dt>
              <dd>Adjust them to generate any color, however notice that the automatic calculations work better within certain ranges and combinations.</dd>
            <dt>Padding, Font Size, Line Height</dt>
              <dd>You can control the relative dimensions of the items, through the interactions of these properties.</dd>
            <dt>Other Properties</dt>
              <dd>Self-explanatory.</dd>
          </dl>
        </div>
        <div id="overlay"></div>
      </div>
    `;
    tweakerInit(shadow);
    panelInit(shadow);
  };
  document.addEventListener('DOMContentLoaded', attachShadow);
})();
