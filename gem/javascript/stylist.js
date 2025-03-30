(() => {
  const icons = "help,tune,unfold_less,unfold_more,visibility,visibility_off";
  const linkTags = `
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@300&icon_names=${icons}&display=block">
  `;
  document.head.insertAdjacentHTML("beforeend", linkTags);
  const B64SafeEncode = (unicode) => btoa(String.fromCharCode(...new TextEncoder().encode(unicode))).replace(/[+/=]/g, (m) => m == "+" ? "-" : m == "/" ? "_" : "");
  const B64Decode = (base64) => new TextDecoder().decode(Uint8Array.from(atob(base64), (c) => c.charCodeAt(0)));
  const deleteCookie = (name) => document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
  const setCookie = (name, value) => document.cookie = `${name}=${B64SafeEncode(value)}; path=/`;
  const getCookie = (name) => {
    const cookieName = `${name}=`;
    const cookieArray = document.cookie.split(";");
    for (let i = 0;i < cookieArray.length; i++) {
      let cookie = cookieArray[i].trim();
      if (cookie.startsWith(cookieName)) {
        return B64Decode(cookie.substring(cookieName.length));
      }
    }
    return null;
  };
  const contentPadding = 16;
  const panelInit = (shadow) => {
    const panel = shadow.getElementById("panel");
    const getPanelPosition = () => {
      const position = getCookie("pagy-stylist-position");
      if (position) {
        const [left, top] = position.split(",");
        return { left: parseInt(left), top: parseInt(top) };
      }
      return null;
    };
    const setPanelPosition = (left, top) => {
      setCookie("pagy-stylist-position", `${left},${top}`);
    };
    const keepPanelInView = () => {
      const left = parseInt(panel.style.left);
      const top = parseInt(panel.style.top);
      const panelRect = panel.getBoundingClientRect();
      if (panelRect.left < 0) {
        panel.style.left = "0px";
      } else if (panelRect.right > window.innerWidth) {
        panel.style.left = `${window.innerWidth - panel.offsetWidth}px`;
      }
      if (panelRect.top < 0) {
        panel.style.top = "0px";
      } else if (panelRect.bottom > window.innerHeight) {
        panel.style.top = `${window.innerHeight - panel.offsetHeight}px`;
      }
      if (panelRect.top < 0 && panel.offsetHeight < window.innerHeight) {
        panel.style.top = "0px";
      }
      setPanelPosition(left, top);
    };
    window.addEventListener("resize", keepPanelInView);
    const position = getPanelPosition();
    if (position) {
      panel.style.left = `${position.left}px`;
      panel.style.top = `${position.top}px`;
    } else {
      panel.style.left = `${(window.innerWidth - panel.offsetWidth) / 2}px`;
      panel.style.top = `${(window.innerHeight - panel.offsetHeight) / 2}px`;
      keepPanelInView();
    }
    let offsetX = 0;
    let offsetY = 0;
    let dragging = false;
    const topBar = shadow.getElementById("top-bar");
    topBar.addEventListener("mousedown", (e) => {
      if (e.target.closest("#preset-menu"))
        return;
      dragging = true;
      offsetX = e.clientX - panel.offsetLeft;
      offsetY = e.clientY - panel.offsetTop;
    });
    document.addEventListener("mousemove", (e) => {
      if (!dragging)
        return;
      panel.style.left = `${e.clientX - offsetX}px`;
      panel.style.top = `${e.clientY - offsetY}px`;
      setPanelPosition(e.clientX - offsetX, e.clientY - offsetY);
    });
    document.addEventListener("mouseup", () => dragging = false);
    const contentChk = shadow.getElementById("content-chk");
    const contentIcon = shadow.getElementById("content-icon");
    const contentDiv = shadow.getElementById("content");
    contentChk.addEventListener("change", () => {
      if (contentChk.checked) {
        contentIcon.textContent = "unfold_less";
        contentDiv.style.display = "block";
      } else {
        contentIcon.textContent = "unfold_more";
        contentDiv.style.display = "none";
      }
    });
    const stylistChk = shadow.getElementById("stylist-chk");
    const stylistIcon = shadow.getElementById("stylist-icon");
    const stylistStyle = document.getElementById("pagy-stylist-default");
    const stylistStyleOverride = document.getElementById("pagy-stylist-override");
    stylistChk.addEventListener("change", () => {
      if (stylistChk.checked) {
        stylistIcon.textContent = "visibility_off";
        stylistStyle.disabled = false;
        stylistStyleOverride.disabled = false;
      } else {
        stylistIcon.textContent = "visibility";
        stylistStyle.disabled = true;
        stylistStyleOverride.disabled = true;
      }
    });
    const controlsChk = shadow.getElementById("controls-chk");
    const controlsIcon = shadow.getElementById("controls-icon");
    const controlsDiv = shadow.getElementById("controls");
    const helpDiv = shadow.getElementById("help");
    controlsChk.addEventListener("change", () => {
      if (controlsChk.checked) {
        controlsIcon.textContent = "help";
        helpDiv.style.display = "none";
        controlsDiv.style.display = "grid";
      } else {
        controlsIcon.textContent = "tune";
        helpDiv.style.display = "block";
        helpDiv.style.height = `${controlsDiv.clientHeight - contentPadding * 2}px`;
        controlsDiv.style.display = "none";
      }
    });
  };
  const stylistInit = (shadow) => {
    const styleTag = document.createElement("style");
    styleTag.id = "pagy-stylist-override";
    document.head.appendChild(styleTag);
    let variables = {
      brightness: { name: "--B", unit: "" },
      hue: { name: "--H", unit: "" },
      saturation: { name: "--S", unit: "" },
      lightness: { name: "--L", unit: "" },
      spacing: { name: "--spacing", unit: "rem" },
      padding: { name: "--padding", unit: "rem" },
      rounding: { name: "--rounding", unit: "rem" },
      borderWidth: { name: "--border-width", unit: "rem" },
      fontSize: { name: "--font-size", unit: "rem" },
      fontWeight: { name: "--font-weight", unit: "" },
      lineHeight: { name: "--line-height", unit: "" }
    };
    for (const [id, v] of Object.entries(variables)) {
      v.input = shadow.getElementById(id);
    }
    const updateStyle = () => {
      let override = `.pagy {\n`;
      Object.values(variables).forEach((v) => {
        override += `  ${v.name}: ${v.input.value}${v.unit};\n`;
      });
      override += "}";
      const overrideArea = shadow.getElementById("override");
      const overrideStyle = document.getElementById("pagy-stylist-override");
      overrideArea.value = override;
      overrideStyle.textContent = override;
      setCookie("pagy-stylist-override", override);
    };
    const presets = {
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
      Pilloween: ` 
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
      Peppermint: `
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
      CocoaBeans: `
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
      VintageScent: `
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
    const presetMenu = shadow.getElementById("preset-menu");
    for (const presetName in presets) {
      const option = document.createElement("option");
      option.value = presetName;
      option.textContent = presetName;
      presetMenu.appendChild(option);
    }
    const applyPreset = (name) => {
      const css = name ? (deleteCookie("pagy-stylist-override"), presets[name]) : getCookie("pagy-stylist-override");
      css?.match(/--[^:]+:\s*[^;]+/g)?.forEach((match) => {
        let [name, value] = match.split(":");
        name = name.trim();
        value = value.trim().replace(/[a-zA-Z%]+$/, "");
        for (const v of Object.values(variables)) {
          if (v.name === name) {
            v.input.value = value;
            break;
          }
        }
      });
      setCookie("pagy-stylist-preset", name || "");
      updateStyle();
    };
    presetMenu.addEventListener("change", (e) => applyPreset(e.target.value));
    const deselectDropdown = () => {
      presetMenu.value = "";
      setCookie("pagy-stylist-preset", "");
    };
    Object.values(variables).forEach((v) => {
      v.input.addEventListener("input", updateStyle);
      v.input.addEventListener("input", deselectDropdown);
    });
    const preset = getCookie("pagy-stylist-preset") ?? "Default";
    presetMenu.value = preset;
    applyPreset(preset);
  };
  const attachShadow = () => {
    const host = document.createElement("div");
    host.id = "pagy-stylist-host";
    document.body.appendChild(host);
    const style = document.createElement("style");
    style.id = "pagy-stylist-default";
    const element = document.getElementById("pagy-stylist");
    style.textContent = B64Decode(element.getAttribute("data-pagy-stylist-default"));
    document.head.appendChild(style);
    const shadow = host.attachShadow({ mode: "open" });
    shadow.innerHTML = `
      ${linkTags}
      <style>
        :host {
          --base-color: #505050;
        }
        #panel {
          accent-color: var(--base-color);
          font-family: 'Nunito Sans', sans-serif !important;
          font-display: block;
          width: 350px;
          box-sizing: border-box;
          box-shadow: 12px 12px 25px 0 rgba(0,0,0,0.3);
          position: fixed;
          z-index: 1000;
        }
        #panel pre, #panel code, #panel kbd, #panel samp {
          font-family: 'Ubuntu Sans Mono', monospace !important;
        }
        #top-bar {
          border-top-left-radius: 5px;
          border-top-right-radius: 5px;
          background-color: var(--base-color);
          padding: 5px 12px;
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
        .left-items {
          display: flex;
          align-items: center;
        }
        .right-items {
          display: flex;
          align-items: center;
        }
        .switch-icon {
          font-size: 24px;
          font-weight: 200;
          cursor: pointer;
        }
        #title {
          font-weight: 500;
        }
        .right-items > *:not(:last-child) {
          margin-right: 6px;
        }
        .left-items > *:not(:first-child) {
          margin-left: 4px;
        }
        #top-bar label input[type="checkbox"] {
          display: none;
        }
        #preset-menu {
          /*margin-left: 5px;*/
        }
        .content{
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
        #brightness {
          margin: 0 2px;
        }
        #override {
          font-family: "Ubuntu Sans Mono", monospace !important;
          font-size: .8rem;
          font-weight: 400;
          line-height: 1.1;
          height: 185px;
          resize: vertical;
          margin: 2px;
        }
        .help-icon {
          font-size: 1rem;
          vertical-align: -25%;
          border-radius: 15%;
          color: white;
          background-color: var(--base-color);
          margin-top: 0.2rem;
          padding: 1px;
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
        #help > h4:first-child {
          margin-top: 0;
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
      </style>
      <div id="panel">
        <div id="top-bar">
          <div class="left-items">
            <span id="title">Pagy Stylist</span>
          </div>
          <div class="right-items">
            <label for="controls-chk">
              <input id="controls-chk" type="checkbox" checked>
              <span class="material-symbols-outlined switch-icon" id="controls-icon">help</span>
            </label>          
            <label for="stylist-chk">
              <input id="stylist-chk" type="checkbox" checked>
              <span class="material-symbols-outlined switch-icon" id="stylist-icon">visibility_off</span>
            </label>
            <label for="content-chk" style="margin-left: -2px;">
              <input id="content-chk" type="checkbox" checked>
              <span class="material-symbols-outlined switch-icon" id="content-icon">unfold_less</span>
            </label>
            <label for="preset-menu">
              <select id="preset-menu">
                <option value="" disabled>Presets...</option>
              </select>
            </label>
          </div>
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
          <h4>Panel</h4>
          <dl>
            <dt>Install</dt>
              <dd><code><%== Pagy.stylist_tag %></code></dd>
            <dt>Move</dt>
              <dd>Drag on the TOP Bar.</dd>
            <dt>Top Bar Icons</dt>
           
              <dd><ul style="list-style-type: none; padding-left: 0; margin: 0;">
                   <li><span class="material-symbols-outlined help-icon">unfold_less</span>
                       <span class="material-symbols-outlined help-icon">unfold_more</span> Collapse/Expand the content</li>
                   <li><span class="material-symbols-outlined help-icon">help</span>
                       <span class="material-symbols-outlined help-icon">tune</span> Toggle the Help/Controls content</li>
                   <li><span class="material-symbols-outlined help-icon">visibility</span>
                       <span class="material-symbols-outlined help-icon">visibility_off</span> Show/Hide the Live Style</li>
                
                  </ul>
              </dd>
          </dl>
          <h4>Controls</h4>
          <dl>
            <dt>Presets dropdown</dt>
              <dd>Pick a starting point to further customize.</dd>
            <dt>Brightness</dt>
              <dd>Toggle the Light or Dark theming. Notice that when you toggle it, you should also adjust the lightness.</dd>
            <dt>Hue, Saturation, Lightness</dt>
              <dd>Adjust them to generate any color, however notice that the automatic calculations work better within certain ranges and combinations.</dd>
            <dt>Padding, Font Size, Line Height</dt>
              <dd>You can control the relative dimensions of the page links, through the interactions of these properties.</dd>
            <dt>Other Properties</dt>
              <dd>Self-explanatory.</dd>
          </dl>
          <h4>Customizing</h4>
          <p>You can change Pagy's styling quite radically, by just setting a few CSS Custom Properties:
            the <i>pagy.css</i> calculates all the other metrics.</p>
          <p>Pick a Presets as a starting point, customize it with the controls,
            and copy/paste the CSS Override in your Stylesheet.</p>
          <p>Override the calculations for full control over the final style.</p>
          <p><b>Important</b>: Do not link the <i>pagy.css</i> file. Copy its customized content in your CSS to avoid unwanted cosmetic changes on update.</p>
        </div>
        </div>
      </div>
    `;
    stylistInit(shadow);
    panelInit(shadow);
  };
  document.addEventListener("DOMContentLoaded", attachShadow);
})();
