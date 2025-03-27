(() => {
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
  const panelInit = (shadowRoot) => {
    const panel = shadowRoot.getElementById("panel");
    const head = shadowRoot.getElementById("head");
    const toggle = shadowRoot.getElementById("toggle");
    const controlDiv = shadowRoot.getElementById("controls");
    const helpIcon = shadowRoot.getElementById("help-icon");
    const helpDiv = shadowRoot.getElementById("help");
    const getPanelPosition = () => {
      const position = getCookie("pagy-tweaker-position");
      if (position) {
        const [left, top] = position.split(",");
        return { left: parseInt(left), top: parseInt(top) };
      }
      return null;
    };
    const setPanelPosition = (left, top) => {
      setCookie("pagy-tweaker-position", `${left},${top}`);
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
    head.addEventListener("mousedown", (e) => {
      if (e.target.closest("#presets"))
        return;
      dragging = true;
      offsetX = e.clientX - panel.offsetLeft;
      offsetY = e.clientY - panel.offsetTop;
    });
    panel.addEventListener("mousedown", (e) => {
      if (!(e.target === head || e.ctrlKey || e.metaKey))
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
    toggle.addEventListener("click", (e) => {
      helpDiv.style.display = "none";
      if (controlDiv.style.display !== "none") {
        controlDiv.style.display = "none";
      } else {
        controlDiv.style.display = "grid";
      }
    });
    helpIcon.addEventListener("click", () => {
      controlDiv.style.display = "none";
      helpDiv.style.display = "flex";
    });
    helpDiv.addEventListener("click", () => {
      helpDiv.style.display = "none";
      controlDiv.style.display = "grid";
    });
  };
  const tweakerInit = (shadowRoot) => {
    const styleTag = document.createElement("style");
    styleTag.id = "pagy-override-style-tag";
    document.head.appendChild(styleTag);
    let variables = {
      brightness: { name: "--B", unit: "" },
      hue: { name: "--H", unit: "" },
      saturation: { name: "--S", unit: "" },
      lightness: { name: "--L", unit: "" },
      opacity: { name: "--opacity", unit: "" },
      spacing: { name: "--spacing", unit: "rem" },
      rounding: { name: "--rounding", unit: "rem" },
      padding: { name: "--padding", unit: "rem" },
      fontSize: { name: "--font-size", unit: "rem" },
      lineHeight: { name: "--line-height", unit: "" },
      fontWeight: { name: "--font-weight", unit: "" },
      borderWidth: { name: "--border-width", unit: "rem" }
    };
    for (const [id, css] of Object.entries(variables)) {
      css.input = shadowRoot.getElementById(id);
    }
    const overrideStyleTag = document.getElementById("pagy-override-style-tag");
    const overrideDisplay = shadowRoot.getElementById("override");
    const updateCSS = () => {
      let override = `.pagy {\n`;
      Object.values(variables).forEach((css) => {
        override += `  ${css.name}: ${css.input.value}${css.unit};\n`;
      });
      override += "}";
      overrideDisplay.value = override;
      overrideStyleTag.textContent = override;
      setCookie("pagy-override", override);
    };
    const presets = {
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
      Pilloween: ` 
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
      Peppermint: `
      .pagy {
        --B: 1;
        --H: 78;
        --S: 70;
        --L: 42;
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
      CocoaBeans: `
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
      VintageScent: `
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
    const presetsDropdown = shadowRoot.getElementById("presets");
    for (const presetName in presets) {
      const option = document.createElement("option");
      option.value = presetName;
      option.textContent = presetName;
      presetsDropdown.appendChild(option);
    }
    const applyPreset = (name) => {
      const css = name ? (deleteCookie("pagy-override"), presets[name]) : getCookie("pagy-override");
      css?.match(/--[^:]+:\s*[^;]+/g)?.forEach((match) => {
        let [name, value] = match.split(":");
        name = name.trim();
        value = value.trim().replace(/[a-zA-Z%]+$/, "");
        for (const css of Object.values(variables)) {
          if (css.name === name) {
            css.input.value = value;
            break;
          }
        }
      });
      setCookie("pagy-preset", name || "");
      updateCSS();
    };
    presetsDropdown.addEventListener("change", (e) => applyPreset(e.target.value));
    const deselectDropdown = () => {
      presetsDropdown.value = "";
      setCookie("pagy-preset", "");
    };
    Object.values(variables).forEach((css) => {
      css.input.addEventListener("input", updateCSS);
      css.input.addEventListener("input", deselectDropdown);
    });
    const preset = getCookie("pagy-preset") ?? "Default";
    presetsDropdown.value = preset;
    applyPreset(preset);
  };
  const attachShadow = () => {
    const host = document.createElement("div");
    host.id = "tweaker-host";
    document.body.appendChild(host);
    const shadow = host.attachShadow({ mode: "open" });
    shadow.innerHTML = `
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap" rel="stylesheet">
      <style>
        #panel {
          font-family: 'Nunito Sans', sans-serif;
          width: 350px;
          box-sizing: border-box;
          box-shadow: 12px 12px 25px 0 rgba(0,0,0,0.3);
          position: fixed;
          z-index: 1000;
        }
        #head {
          border-top-left-radius: 5px;
          border-top-right-radius: 5px;
          background-color: #505050;
          padding: 4px 10px;
          cursor: move;
          user-select: none;
          color: white;  
          display: flex;
          align-items: center;
        }
        #toggle {
          margin-right: 12px;
          line-height: 1em;
          user-select: none;
          cursor: pointer;
          position: relative; /* Add this to allow absolute positioning of the pseudo-element */
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
        #presets {
          all: revert;
          margin-left: auto; 
        }
        #controls {
          padding: 16px;
          font-size: 0.8rem;
          display: grid;
          grid-template-columns: auto auto;
          grid-column-gap: 5px;
          line-height: normal;
          color: black;
          background-color: rgba(200,200,200,.9);
        }
        #controls label {
          grid-column: 1;
          text-align: right;
          padding-right: 5px;
          white-space: nowrap;
          position: relative;
        }
        #help-icon {
          width: 23px;
          height: 23px;
          background-color: #505050;
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
          padding: 16px;
          font-size: 0.8rem;
          color: black;
          background-color: rgba(200,200,200,.9);
        }
        #brightness {
          all: revert;
          margin: 0 2px;
        }
        #override {
          all: revert;
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
        <div id="head">
          <span id="toggle">\u2630</span><b>Pagy Tweaker</b></span>
          <label for="presets" style="width:0;height:0;color:rgba(0,0,0,0);">&nbsp;</label>
          <select id="presets">
            <option value="" disabled>Presets...</option>
          </select>
        </div>
        <div id="controls">
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
          <label for="rounding">Rounding</label>
          <input type="range" id="rounding" min="0" max="3" step="0.0625">
          <label for="padding">Padding</label>
          <input type="range" id="padding" min="0" max="1.5" step="0.0625">
          <label for="lineHeight">Line Height</label>
          <input type="range" id="lineHeight" min="1.25" max="2.5" step="0.0625">
          <label for="fontSize">Font Size</label>
          <input type="range" id="fontSize" min="0.75" max="2" step="0.0625">
          <label for="fontWeight">Font Weight</label>
          <input type="range" id="fontWeight" min="100" max="1000" step="50">
          <label for="borderWidth">Border Width</label>
          <input type="range" id="borderWidth" min="0" max="0.25" step="0.03125">
          <label for="override">Override<span id="help-icon">?</span></label>
          <textarea id="override" rows="5" cols="40" readonly></textarea>
        </div>
  <div id="help">
    <ul>
      <li><b>Help</b></li>
      <li><b>Example</b></li>
      <li><b>Example</b></li>
      <li><b>Example</b></li>
      <li><b>Example</b></li>
      <li><b>Example</b></li>
    </ul>
  </div>
      </div>
    `;
    tweakerInit(shadow);
    panelInit(shadow);
  };
  document.addEventListener("DOMContentLoaded", attachShadow);
})();
