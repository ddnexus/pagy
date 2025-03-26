(() => {
  const tweakerInit = (shadowRoot) => {
    const styleTag = document.createElement("style");
    styleTag.id = "pagy-override-style-tag";
    document.head.appendChild(styleTag);
    const overrideStyleTag = document.getElementById("pagy-override-style-tag");
    const pagyElements = document.querySelectorAll(".pagy");
    const overrideDisplay = shadowRoot.getElementById("override");
    let variables = {
      brightness: { cssName: "--B", unit: "" },
      hue: { cssName: "--H", unit: "" },
      saturation: { cssName: "--S", unit: "" },
      lightness: { cssName: "--L", unit: "" },
      opacity: { cssName: "--opacity", unit: "" },
      spacing: { cssName: "--spacing", unit: "rem" },
      rounding: { cssName: "--rounding", unit: "rem" },
      padding: { cssName: "--padding", unit: "rem" },
      fontSize: { cssName: "--font-size", unit: "rem" },
      lineHeight: { cssName: "--line-height", unit: "" },
      fontWeight: { cssName: "--font-weight", unit: "" },
      borderWidth: { cssName: "--border-width", unit: "rem" }
    };
    for (const [id, data] of Object.entries(variables)) {
      data.input = shadowRoot.getElementById(id);
      data.cookieName = `pagy-${id}`;
    }
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
    const updateCSS = () => {
      let override = `.pagy {\n`;
      Object.values(variables).forEach((data) => {
        override += `  ${data.cssName}: ${data.input.value}${data.unit};\n`;
      });
      override += "}";
      overrideDisplay.value = override;
      overrideStyleTag.textContent = override;
      setCookie("pagy-override", override);
      let backdrop = variables.brightness.input.value === "-1" ? "#000000" : "#ffffff";
      pagyElements.forEach((element) => {
        element.style.backgroundColor = backdrop;
      });
    };
    const presets = {
      Default: `.pagy {
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
       }`,
      Dark: `.pagy {
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
       }`,
      MidnighExpress: `.pagy {
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
       }`,
      Pilloween: `.pagy {
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
       }`,
      GreenPeas: `.pagy {
         --B: 1;
         --H: 98;
         --S: 63;
         --L: 30;
         --opacity: 1;
         --spacing: 0.125rem;
         --rounding: 1.125rem;
         --padding: 0.6875rem;
         --font-size: 0.875rem;
         --line-height: 1.75;
         --font-weight: 600;
         --border-width: 0rem;
       }`,
      CocoaBeans: `.pagy {
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
       }`,
      PurpleStripe: `.pagy {
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
       }`,
      GhostInThought: `.pagy {
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
       }`,
      VintageScent: `.pagy {
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
       }`
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
        let [cssName, cssValue] = match.split(":");
        cssName = cssName.trim();
        cssValue = cssValue.trim().replace(/[a-zA-Z%]+$/, "");
        for (const data of Object.values(variables)) {
          if (data.cssName === cssName) {
            data.input.value = cssValue;
            break;
          }
        }
      });
      setCookie("pagy-preset", name || "");
      updateCSS();
    };
    presetsDropdown.addEventListener("change", (event) => applyPreset(event.target.value));
    const deselectDropdown = () => {
      presetsDropdown.value = "";
      setCookie("pagy-preset", "");
    };
    Object.values(variables).forEach((data) => {
      data.input.addEventListener("input", updateCSS);
      data.input.addEventListener("input", deselectDropdown);
    });
    const preset = getCookie("pagy-preset") ?? "Default";
    presetsDropdown.value = preset;
    applyPreset(preset);
    const panel = shadowRoot.getElementById("panel");
    const head = shadowRoot.getElementById("head");
    const toggle = shadowRoot.getElementById("toggle");
    const controls = shadowRoot.getElementById("controls");
    let offsetX = 0;
    let offsetY = 0;
    let dragging = false;
    head.addEventListener("mousedown", (e) => {
      dragging = true;
      offsetX = e.clientX - panel.offsetLeft;
      offsetY = e.clientY - panel.offsetTop;
    });
    document.addEventListener("mousemove", (e) => {
      if (!dragging)
        return;
      panel.style.left = `${e.clientX - offsetX}px`;
      panel.style.top = `${e.clientY - offsetY}px`;
    });
    toggle.addEventListener("click", (e) => {
      if (controls.style.display !== "none") {
        controls.style.display = "none";
      } else {
        controls.style.display = "grid";
      }
    });
    document.addEventListener("mouseup", () => {
      dragging = false;
    });
    panel.style.left = `${(window.innerWidth - panel.offsetWidth) / 2}px`;
    panel.style.top = `${(window.innerHeight - panel.offsetHeight) / 2}px`;
    const keepPanelInView = () => {
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
    };
    keepPanelInView();
    window.addEventListener("resize", keepPanelInView);
  };
  const attachShadow = () => {
    const host = document.createElement("div");
    host.id = "tweaker-host";
    document.body.appendChild(host);
    const shadow = host.attachShadow({ mode: "open" });
    shadow.innerHTML = `
      <style>
        #panel {
          width: 350px;
          box-sizing: border-box;
          box-shadow: 12px 12px 25px 0 rgba(0,0,0,0.3);
          position: fixed;
          z-index: 1000;
        }
        #head {
          border-top-left-radius: 5px;
          border-top-right-radius: 5px;
          background-color: #707070;
          padding: 4px 8px;
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
        }
        #presets {
          all: revert;
          margin-left: auto; 
        }
        #controls {
          all: revert;
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
        }
        #brightness {
          all: revert;
          margin: 0 2px;
        }
        #override {
          all: revert;
          font-family: monospace;
          font-size: .8rem;
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
            <label for="override">Override</label>
            <textarea id="override" rows="5" cols="40" readonly></textarea>
          </div>
        <div id="bottom"></div>
      </div>
    `;
    tweakerInit(shadow);
  };
  document.addEventListener("DOMContentLoaded", attachShadow);
})();
