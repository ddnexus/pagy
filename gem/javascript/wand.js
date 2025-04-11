(() => {
  const lightGray = "rgba(220,220,220,.6)";
  const baseColor = "#484848";
  const pagyColor = "#81ffff";
  const icons = "check_circle,content_copy,error,help,tune,visibility,visibility_off";
  const linkTags = `
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Pattaya&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=${icons}&display=block" />
  `;
  document.head.insertAdjacentHTML("beforeend", linkTags);
  const B64SafeEncode = (unicode) => btoa(String.fromCharCode(...new TextEncoder().encode(unicode))).replace(/[+/=]/g, (m) => m == "+" ? "-" : m == "/" ? "_" : "");
  const B64Decode = (base64) => new TextDecoder().decode(Uint8Array.from(atob(base64), (c) => c.charCodeAt(0)));
  const encodeBool = (bool) => bool ? "true" : "false";
  const decodeBool = (str) => str === "true";
  const PRESET = "pagy-wand-preset";
  const OVERRIDE = "pagy-wand-override";
  const POSITION = "pagy-wand-position";
  const CONTROLS_CHK = "pagy-wand-controls-chk";
  const HELP_CHK = "pagy-wand-help-chk";
  const LIVE_CHK = "pagy-wand-live-chk";
  function deleteCookie(name) {
    document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
  }
  function setCookie(name, value) {
    document.cookie = `${name}=${B64SafeEncode(value)}; path=/`;
  }
  function getCookie(name) {
    const cookieName = `${name}=`;
    const cookieArray = document.cookie.split(";");
    for (let i = 0;i < cookieArray.length; i++) {
      let cookie = cookieArray[i].trim();
      if (cookie.startsWith(cookieName)) {
        return B64Decode(cookie.substring(cookieName.length));
      }
    }
    return null;
  }
  function initialize(shadow) {
    const styleTagOverride = document.createElement("style");
    styleTagOverride.id = "pagy-wand-ovrride";
    document.head.appendChild(styleTagOverride);
    const panel = shadow.getElementById("panel");
    const topBar = shadow.getElementById("top-bar");
    const presetMenu = shadow.getElementById("preset-menu");
    const controlsChk = shadow.getElementById("controls-chk");
    controlsChk.checked = decodeBool(getCookie(CONTROLS_CHK) ?? "false");
    const controlsIcon = shadow.getElementById("controls-icon");
    const controlsDiv = shadow.getElementById("controls");
    const helpChk = shadow.getElementById("help-chk");
    helpChk.checked = decodeBool(getCookie(HELP_CHK) ?? "false");
    const helpIcon = shadow.getElementById("help-icon");
    const helpDiv = shadow.getElementById("help");
    const liveChk = shadow.getElementById("live-chk");
    liveChk.checked = decodeBool(getCookie(LIVE_CHK) ?? "true");
    const liveIcon = shadow.getElementById("live-icon");
    const liveStyle = document.getElementById("pagy-wand-default");
    const copyIcon = shadow.getElementById("copy-icon");
    const overrideArea = shadow.getElementById("override");
    let controls = {
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
    for (const [id, c] of Object.entries(controls)) {
      c.input = shadow.getElementById(id);
      c.input.addEventListener("input", () => {
        updateStyle();
        presetMenu.value = "";
        setCookie(PRESET, "");
      });
    }
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
    for (const presetName in presets) {
      const option = document.createElement("option");
      option.value = presetName;
      option.textContent = presetName;
      presetMenu.appendChild(option);
    }
    function applyPreset(name) {
      const css = name ? (deleteCookie(OVERRIDE), presets[name]) : getCookie(OVERRIDE);
      css?.match(/--[^:]+:\s*[^;]+/g)?.forEach((match) => {
        let [cssVarName, value] = match.split(":");
        cssVarName = cssVarName.trim();
        value = value.trim().replace(/[a-zA-Z%]+$/, "");
        for (const c of Object.values(controls)) {
          if (c.name === cssVarName) {
            c.input.value = value;
            break;
          }
        }
      });
      setCookie(PRESET, name || "");
      updateStyle();
    }
    presetMenu.addEventListener("change", (e) => applyPreset(e.target.value));
    const preset = getCookie(PRESET) ?? "Default";
    presetMenu.value = preset;
    const initialOverride = getCookie(OVERRIDE);
    if (initialOverride) {
      applyPreset(null);
      presetMenu.value = "";
    } else {
      applyPreset(preset);
    }
    function updateStyle() {
      let override = `.pagy {\n`;
      Object.values(controls).forEach((c) => {
        override += `  ${c.name}: ${c.input.value}${c.unit};\n`;
      });
      override += "}";
      overrideArea.value = override;
      styleTagOverride.textContent = liveChk.checked ? override : "";
      if (presetMenu.value === "") {
        setCookie(OVERRIDE, override);
      } else {
        deleteCookie(OVERRIDE);
      }
    }
    function getCookiePosition() {
      const position = getCookie(POSITION);
      if (position) {
        const [left, top] = position.split(",");
        return { left: parseInt(left), top: parseInt(top) };
      }
      return null;
    }
    function setCookiePosition(left, top) {
      setCookie(POSITION, `${left},${top}`);
    }
    const viewport = () => ({
      width: window.visualViewport ? window.visualViewport.width : document.documentElement.clientWidth,
      height: window.visualViewport ? window.visualViewport.height : document.documentElement.clientHeight
    });
    function keepTopBarInView() {
      const v = viewport();
      const rect = topBar.getBoundingClientRect();
      let newLeft = panel.offsetLeft;
      let newTop = panel.offsetTop;
      if (rect.left < 0) {
        newLeft = panel.offsetLeft - rect.left;
      } else if (rect.right > v.width) {
        newLeft = panel.offsetLeft - (rect.right - v.width);
      }
      if (rect.top < 0) {
        newTop = panel.offsetTop - rect.top;
      } else if (rect.bottom > v.height) {
        newTop = panel.offsetTop - (rect.bottom - v.height);
      }
      panel.style.left = `${newLeft}px`;
      panel.style.top = `${newTop}px`;
      setCookiePosition(newLeft, newTop);
    }
    let resizeTimeout;
    window.addEventListener("resize", () => {
      if (resizeTimeout)
        clearTimeout(resizeTimeout);
      resizeTimeout = window.setTimeout(keepTopBarInView, 250);
    });
    const position = getCookiePosition();
    if (position && !isNaN(position.left) && !isNaN(position.top)) {
      panel.style.left = `${position.left}px`;
      panel.style.top = `${position.top}px`;
    } else {
      panel.classList.add("initial");
      requestAnimationFrame(() => {
        panel.classList.add("centered");
      });
      panel.addEventListener("transitionend", (e) => {
        if (e.propertyName === "transform") {
          panel.style.transition = "none";
          const rect = panel.getBoundingClientRect();
          panel.style.top = rect.top + "px";
          panel.style.left = rect.left + "px";
          setCookiePosition(rect.left, rect.top);
          panel.classList.remove("initial");
          panel.classList.remove("centered");
        }
      }, { once: true });
    }
    let offsetX = 0;
    let offsetY = 0;
    let dragging = false;
    topBar.addEventListener("mousedown", (e) => {
      if (e.target.closest("#preset-menu, label"))
        return;
      dragging = true;
      offsetX = e.clientX - panel.offsetLeft;
      offsetY = e.clientY - panel.offsetTop;
      topBar.style.cursor = "grab";
      panel.style.transition = "none";
    });
    document.addEventListener("mousemove", (e) => {
      if (!dragging)
        return;
      e.preventDefault();
      const newLeft = e.clientX - offsetX;
      const newTop = e.clientY - offsetY;
      panel.style.left = `${newLeft}px`;
      panel.style.top = `${newTop}px`;
      setCookiePosition(newLeft, newTop);
    });
    document.addEventListener("mouseup", () => {
      if (!dragging)
        return;
      dragging = false;
      topBar.style.cursor = "move";
    });
    function controlsSwitcher() {
      if (controlsChk.checked) {
        controlsIcon.classList.add("selected-icon");
        controlsDiv.style.display = "grid";
        helpChk.checked = false;
        helpSwitcher();
      } else {
        controlsIcon.classList.remove("selected-icon");
        controlsDiv.style.display = "none";
      }
      setCookie(CONTROLS_CHK, encodeBool(controlsChk.checked));
    }
    controlsSwitcher();
    controlsChk.addEventListener("change", controlsSwitcher);
    function helpSwitcher() {
      if (helpChk.checked) {
        helpIcon.classList.add("selected-icon");
        helpDiv.style.display = "block";
        controlsChk.checked = false;
        controlsSwitcher();
      } else {
        helpIcon.classList.remove("selected-icon");
        helpDiv.style.display = "none";
      }
      setCookie(HELP_CHK, encodeBool(helpChk.checked));
    }
    helpSwitcher();
    helpChk.addEventListener("change", helpSwitcher);
    function liveSwitcher() {
      if (liveChk.checked) {
        liveIcon.classList.add("selected-icon");
        liveIcon.textContent = "visibility";
        liveStyle.disabled = false;
      } else {
        liveIcon.classList.remove("selected-icon");
        liveIcon.textContent = "visibility_off";
        liveStyle.disabled = true;
      }
      updateStyle();
      setCookie(LIVE_CHK, encodeBool(liveChk.checked));
    }
    liveSwitcher();
    liveChk.addEventListener("change", liveSwitcher);
    async function copyToClipboard() {
      const feedback = shadow.getElementById("copy-feedback");
      const originalIcon = "content_copy";
      feedback.classList.remove("visible");
      try {
        await navigator.clipboard.writeText(overrideArea.value);
        copyIcon.textContent = "check_circle";
        copyIcon.style.color = "limegreen";
        feedback.textContent = "Copied!";
        feedback.classList.add("visible", "success");
        setTimeout(() => {
          copyIcon.textContent = originalIcon;
          copyIcon.style.color = lightGray;
          feedback.classList.remove("visible", "success");
        }, 3000);
      } catch (err) {
        console.error('Failed to copy! (navigator.clipboard requires "localhost" or HTTPS) - ', err);
        copyIcon.textContent = "error";
        copyIcon.style.color = "red";
        feedback.textContent = "Failed!";
        feedback.classList.add("visible", "failure");
        setTimeout(() => {
          copyIcon.textContent = originalIcon;
          copyIcon.style.color = lightGray;
          feedback.classList.remove("visible", "failure");
        }, 5000);
      }
    }
    copyIcon.addEventListener("click", copyToClipboard);
  }
  function attachShadow() {
    const host = document.createElement("div");
    host.id = "pagy-wand-host";
    document.body.appendChild(host);
    const scale = parseFloat(document.getElementById("pagy-wand").getAttribute("data-scale"));
    const style = document.getElementById("pagy-wand-default");
    document.head.appendChild(style);
    const shadow = host.attachShadow({ mode: "closed" });
    shadow.innerHTML = `
      ${linkTags}
      <style>
        @font-face {
          font-display: block;
        }
        #panel select, #panel select option, #panel input[type="range"] {
          font-family: 'Nunito Sans', sans-serif;
          cursor: pointer;
          font-weight: 600;
        }
        #panel select, textarea {
          font-size: ${scale * 0.8}rem;
          border-radius: ${scale}rem;
          padding-left: ${scale * 0.25}rem !important;
          border: none;
          box-shadow: ${scale * 0.125}rem
                      ${scale * 0.125}rem
                      ${scale * 0.3125}rem 
                      0 rgba(0,0,0,0.3);
        }
        #panel {
          accent-color: ${baseColor};
          font-family: 'Nunito Sans', sans-serif;
          line-height: 1.2;
          border-radius:  ${scale * 1.25}rem;
          width:  ${scale * 22}rem;
          box-sizing: border-box;
          box-shadow: ${scale * 0.75}rem
                      ${scale * 0.75}rem
                      ${scale * 1.5625}rem
                      ${scale * 0.0625}rem
                      rgba(0,0,0,.4);
          position: fixed;
          z-index: 1000;
          overflow: hidden;
          transition: transform 1s ease-in;
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
          font-family: 'Ubuntu Sans Mono', monospace;
        }
        #top-bar {
          background: linear-gradient(to bottom,
                                        #1a1a1a 0%,
                                        #2b2b2b 5%,
                                        #404040 10%,
                                        #525252 20%,
                                        #404040 40%,
                                        #2b2b2b 60%,
                                        #1a1a1a 80%,
                                        #0d0d0d 92%,
                                        #000000 100%
                                      );
          padding: ${scale * 0.25}rem
                   ${scale * 0.75}rem
                   ${scale * 0.25}rem
                   ${scale * 0.875}rem;
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
          font-size: ${scale * 1.4}rem;
          text-shadow: ${scale * 0.0625}rem
                       ${scale * 0.0625}rem 
                       0 rgba(0,0,0,1);
          margin-right: ${scale * 0.125}rem;
        }
        .switch-icon {
          font-size: ${scale * 1.5}rem;
          font-weight: 300;
          cursor: pointer;
        }
        .selected-icon {
          color: ${pagyColor};
        }
        .content{
          overflow-y: auto;
          font-size: ${scale * 0.8}rem;
          color: black;
          background-color: ${lightGray};
          backdrop-filter: blur(${scale * 0.875}rem);
          padding: ${scale * 0.8}rem ${scale}rem;
          border-top: ${scale * 0.15}rem solid ${pagyColor};
          border-bottom: ${scale * 0.15}rem solid ${pagyColor};
          height: ${scale * 28.9}rem;
        }
        #controls {
          display: grid;
          grid-template-columns: min-content 1fr;
          grid-template-rows: repeat(11, ${scale * 1.5}rem) ${scale * 12}rem;
          grid-column-gap: ${scale * 0.625}rem;
        }
        #controls input {
          margin: 0;
        }
        #controls label {
          font-weight: 600;
          grid-column: 1;
          white-space: nowrap;
          justify-self: end;
          align-self: center;
          user-select: none;
          cursor: default;
        }
        label[for="override"] {
          align-self: start !important;
          margin-top: ${scale * 0.35}rem;
        }
        #brightness {
          margin: 0 0 ${scale * 0.2}rem 0;
          color: white;
          background-color: black;
          opacity: .6;
        }
        #override-container {
          display: inline;
          position: relative;
        }
        #override {
          white-space: pre-wrap; /* Preserve line breaks, wrap only when necessary */
          word-break: normal;    /* Prevent breaking words */
          overflow-wrap: normal; /* Standard line breaking */
          font-family: "Ubuntu Sans Mono", monospace;
          padding: ${scale * 0.2}rem !important;
          border-radius: ${scale * 0.6}rem;
          line-height: 1.1;
          height: 100%;
          width: 100%;
          resize: none;
          font-weight: 500;
          box-sizing: border-box;  
          position: relative;
          margin-top: ${scale * 0.25}rem;
          color: white;
          background-color: black;
          opacity: .6;
        }
        #copy-icon {
          font-weight: 300;
          color: ${lightGray};
          position: absolute;
          top: ${scale * 0.8}rem;
          right: ${scale * 0.6}rem;
          cursor: pointer;
        }
        .copy-feedback {
          position: absolute;
          top: ${scale}rem;
          right: ${scale * 2.3}rem;
          padding: ${scale * 0.1}rem ${scale * 0.3}rem;
          border-radius: ${scale * 0.2}rem;
          font-weight: 700;
          white-space: nowrap;
          color: white;
          opacity: 0;
          visibility: hidden;
          transition: opacity 0.4s ease-in-out, visibility 0.2s ease-in-out;
          pointer-events: none; /* Prevent interfering with clicks */
        }
        .copy-feedback.visible {
          opacity: 1;
          visibility: visible;
        }
        .copy-feedback.success {
          background-color: limegreen; /* Subtle background */
        }
        .copy-feedback.failure {
          background-color: red; /* Subtle background */
        }
        .help-icon, .help-copy-icon {
          font-size: ${scale}rem;
          vertical-align: -15.625%;
          border-radius: 15%;
          color: white;
          background-color: ${baseColor};
          margin-top: ${scale * 0.2}rem;
          padding: ${scale * 0.125}rem
                   ${scale * 0.0625}rem
                   ${scale * 0.0625}rem
                   ${scale * 0.0625}rem;
          font-weight: 300;
        }
        .selected-help-icon {
          color: ${pagyColor};
        }
         .help-copy-icon {
           color: ${baseColor};
           background-color: white;
         }
        .help-copy-icon.success {
          color: limegreen;
        }
        .help-copy-icon.failure {
          color: red;
        }
        #help {
          display: none;
          line-height: ${scale}rem;
          scrollbar-width: none;
        }
        #help::-webkit-scrollbar {
          display: none;
        }
        #help > h4:first-child {
          margin-top: 0;
        }
        #help h4 {
          text-align: right;
          padding: ${scale * 0.25}rem ${scale * 0.625}rem;
          border-top-right-radius: ${scale * 2.5}rem;
          border-bottom-right-radius: 2.5rem;
          color: white;
          background: linear-gradient(to right, rgba(0,0,0,0), rgba(0,0,0,.5));
          margin-top: ${scale * 0.8}rem;
          margin-bottom: ${scale * 0.4}rem;
        }
        #help p {
          margin-top: ${scale * 0.4}rem;
          margin-bottom: ${scale * 0.3}rem;
        }
        #help dl {
          margin: 0;
        }
        #help dt {
          font-weight: bold;
          margin: ${scale * 0.4}rem 0 ${scale * 0.1}rem 0;
        }
        #help dd {
          margin-bottom: ${scale * 0.15}rem;
          margin-left: ${scale}rem;
        }
        #help .button-desc {
          margin-left: ${scale * 0.4}rem;
        }
        #help code {
          font-family: "Ubuntu Sans Mono", monospace;
          display: inline-block;
          line-height: ${scale * 0.8}rem;
          border-radius: ${scale * 0.625}rem;
          background-color: white;
          padding: ${scale * 0.0625}rem ${scale * 0.3125}rem;
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
            <div id="override-container">
              <textarea id="override" readonly></textarea>
              <span id="copy-feedback" class="copy-feedback"></span>
              <span id="copy-icon" class="material-symbols-rounded">content_copy</span>
            </div>
          </div>
          <div id="help" class="content">
            <h4>Install</h4>
              <dl>
                <dt>Load it in HTML head</dt>
                <dd>
                  <code><%== Pagy.wand_tag %></code>
                  <p>You can pass the optional <code>scale</code> factor argument to change the size of the Wand.
                    <br>Default: <code>scale: 1</code></p>
                </dd>
              </dl>
            <h4>Wand</h4>
            <dl>
              <dt>Top Bar</dt>
                <dd>Drag the Wand.</dd>
              <dt>Top Bar Indicator Buttons</dt>
                <dd>
                  <ul style="list-style-type: none; padding-left: 0; margin: 0;">
                    <li><span class="material-symbols-rounded help-icon">tune</span> <span class="material-symbols-rounded help-icon selected-help-icon">tune</span><span class="button-desc">Toggle the Controls Section</span></li>
                    <li><span class="material-symbols-rounded help-icon">help</span> <span class="material-symbols-rounded help-icon selected-help-icon">help</span><span class="button-desc">Toggle the Help Section</span></li>
                    <li><span class="material-symbols-rounded help-icon">visibility_off</span> <span class="material-symbols-rounded help-icon selected-help-icon">visibility</span><span class="button-desc">Toggle the Live Preview</span></li>
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
              <dt>CSS Override</dt>
                <dd>
                  <p>The set of <code>.pagy</code> rules currently applied.</p>
                  <ul style="list-style-type: none; padding-left: 0; margin: 0;">
                    <li><span class="material-symbols-rounded help-copy-icon">content_copy</span> <span class="button-desc">Copy the CSS Override</span></li>
                    <li><span class="material-symbols-rounded help-copy-icon success">check_circle</span> <span class="button-desc">Copied! Feedback</li>
                    <li><span class="material-symbols-rounded help-copy-icon failure">error</span> <span class="button-desc">Failed! Feedback</li>
                  </ul>
                </dd>
            </dl>
            <h4>Customizing</h4>
            <p>You can change Pagy's styling quite radically, by just setting a few CSS Custom Properties:
              the <code><i>pagy.css</i></code> or <code><i>pagy-tailwind.css</i></code> calculates all the other metrics.</p>
            <p>Pick a Presets as a starting point, customize it with the controls,
              and copy/paste the CSS Override in your Stylesheet.</p>
            <p>You can add further customization to the <code>.pagy</code> CSS Override, or override the calculated properties
              for full control over the final style.</p>
            <p><b>Important</b>: Do not link the Pagy CSS file. Copy its customized content in your CSS,
              in order to avoid unwanted cosmetic changes that could happen on update.</p>
          </div>
        </div>
      </div>
    `;
    initialize(shadow);
  }
  document.addEventListener("DOMContentLoaded", attachShadow);
})();
