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
  const lightGray = 'rgba(220,220,220,.6)';
  const baseColor = '#484848';
  const pagyColor = '#81ffff';
  const icons     = 'check_circle,content_copy,error,help,tune,visibility,visibility_off';  // Alpha sorted icon names
  const linkTags  = `
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Pattaya&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=${icons}&display=block" />
  `;
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

  // Cookie functions
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

  // initialize function (Original structure)
  function initialize(shadow: ShadowRoot) {
    // Append CSS ovveride style tag in <head>
    const styleTagOverride = document.createElement('style');
    styleTagOverride.id    = 'pagy-wand-ovrride';
    document.head.appendChild(styleTagOverride);

    const panel         = <HTMLElement>shadow.getElementById('panel');
    const topBar        = <HTMLElement>shadow.getElementById('top-bar');
    const presetMenu    = <HTMLSelectElement>shadow.getElementById('preset-menu');

    const controlsChk   = <HTMLInputElement>shadow.getElementById('controls-chk');
    controlsChk.checked = decodeBool(getCookie(CONTROLS_CHK) ?? 'false');
    const controlsIcon  = <HTMLElement>shadow.getElementById('controls-icon');
    const controlsDiv   = <HTMLElement>shadow.getElementById('controls');

    const helpChk       = <HTMLInputElement>shadow.getElementById('help-chk');
    helpChk.checked     = decodeBool(getCookie(HELP_CHK) ?? 'false');
    const helpIcon      = <HTMLElement>shadow.getElementById('help-icon');
    const helpDiv       = <HTMLElement>shadow.getElementById('help');

    const liveChk       = <HTMLInputElement>shadow.getElementById('live-chk');
    liveChk.checked     = decodeBool(getCookie(LIVE_CHK) ?? 'true');
    const liveIcon      = <HTMLElement>shadow.getElementById('live-icon');
    const liveStyle     = <HTMLStyleElement>document.getElementById('pagy-wand-default');

    const copyIcon      = <HTMLElement>shadow.getElementById('copy-icon');
    const overrideArea  = <HTMLTextAreaElement>shadow.getElementById('override');

    // controls object (Original - units remain 'rem' as they apply to document override)
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
    function updateColorRamps() {
      const h = controls.hue.input!.value;
      const s = controls.saturation.input!.value;
      const l = controls.lightness.input!.value;
      controls.saturation.input!.style.background = `linear-gradient(to right, hsl(${h}, 0%, ${l}%), hsl(${h}, 100%, ${l}%))`;
      controls.lightness.input!.style.background = `linear-gradient(to right, hsl(${h}, ${s}%, 0%), hsl(${h}, ${s}%, 50%), hsl(${h}, ${s}%, 100%))`;
    }
    for (const [id, c] of Object.entries(controls)) {
      c.input = <HTMLInputElement>shadow.getElementById(id);
      c.input!.addEventListener('input', (e) => { // Added 'e' parameter
        updateStyle();
        if (['hue', 'saturation', 'lightness'].includes(id)) { updateColorRamps(); } // Added this line
        presetMenu.value = '';
        setCookie(PRESET, '');
      });
    }

    // PresetMenu (Original - units remain 'rem')
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
        --L: 43;
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

    // applyPreset function (Original logic)
    function applyPreset(name:string | null) {
      const css = name
                  ? (deleteCookie(OVERRIDE), presets[name])
                  : getCookie(OVERRIDE);
      css?.match(/--[^:]+:\s*[^;]+/g)?.forEach((match) => {
        let [cssVarName, value] = match.split(':');
        cssVarName = cssVarName.trim();
        value = value.trim().replace(/[a-zA-Z%]+$/, '');
        for (const c of Object.values(controls)) {
          if (c.name === cssVarName) {
            c.input!.value = value;
            break;
          }
        }
      });
      setCookie(PRESET, name || '');
      updateStyle();
    }
    presetMenu.addEventListener('change', (e) => applyPreset((<HTMLSelectElement>e.target).value));

    // Initial load logic
    const preset     = getCookie(PRESET) ?? 'Default';
    presetMenu.value = preset; // Set dropdown value first
    // Check for override *after* setting preset dropdown, apply override if exists
    const initialOverride = getCookie(OVERRIDE);
    if (initialOverride) {
      applyPreset(null); // Apply override
      presetMenu.value = ''; // Unselect preset in dropdown
    } else {
      applyPreset(preset); // Apply preset if no override
    }

    // Style handling (Original logic)
    function updateStyle() {
      let override = `.pagy {\n`;
      Object.values(controls).forEach((c) => {
        override += `  ${c.name}: ${c.input!.value}${c.unit};\n`; // Uses original units from controls object
      });
      override += '}';
      overrideArea!.value = override;
      styleTagOverride.textContent = liveChk.checked ? override : '';
      // Save override cookie only if a preset is NOT selected
      if (presetMenu.value === '') {
        setCookie(OVERRIDE, override);
      } else {
        // If a preset *is* selected, delete any override cookie
        deleteCookie(OVERRIDE);
      }
      updateColorRamps();
    }

    // getCookiePosition function
    function getCookiePosition() {
      const position = getCookie(POSITION);
      if (position) {
        const [left, top] = position.split(',');
        return { left: parseInt(left), top: parseInt(top) };
      }
      return null;
    }

    // setCookiePosition function
    function setCookiePosition(left: string|number, top: string|number) {
      setCookie(POSITION, `${left},${top}`);
    }

    // Viewport function
    const viewport = () => ({
      width:  window.visualViewport ? window.visualViewport.width  : document.documentElement.clientWidth,
      height: window.visualViewport ? window.visualViewport.height : document.documentElement.clientHeight,
    });

    // keepTopBarInView function
    function keepTopBarInView() {
      const v     = viewport();
      const rect  = topBar.getBoundingClientRect();
      let newLeft = panel.offsetLeft; // Use panel's current position
      let newTop  = panel.offsetTop;

      // Check if topBar is off-screen horizontally
      if (rect.left < 0) {
        newLeft = panel.offsetLeft - rect.left; // Adjust panel left
      } else if (rect.right > v.width) {
        // Correct calculation: adjust by how much the right edge is past the viewport width
        newLeft = panel.offsetLeft - (rect.right - v.width);
      }
      // Check if topBar is off-screen vertically
      if (rect.top < 0) {
        newTop = panel.offsetTop - rect.top; // Adjust panel top
      } else if (rect.bottom > v.height) {
        // Correct calculation: adjust by how much the bottom edge is past the viewport height
        newTop = panel.offsetTop - (rect.bottom - v.height);
      }

      // Apply potentially adjusted positions
      panel.style.left = `${newLeft}px`;
      panel.style.top  = `${newTop}px`;

      // Save the *panel's* final position
      setCookiePosition(newLeft, newTop);
    }

    // Resize event listener
    let resizeTimeout: number | undefined;   // debouncing
    window.addEventListener('resize', () => {
      if (resizeTimeout) clearTimeout(resizeTimeout);
      resizeTimeout = window.setTimeout(keepTopBarInView, 250);
    });

    // Set position from cookie (or transition-center it) (Original logic)
    const position = getCookiePosition();

    if (position && !isNaN(position.left) && !isNaN(position.top)) { // Added NaN check for robustness
      panel.style.left = `${position.left}px`;
      panel.style.top  = `${position.top}px`;
    } else {
      panel.classList.add('initial'); // Start with initial styles (transform/opacity)
      requestAnimationFrame(() => {
        panel.classList.add('centered'); // Add class to trigger transition
      });
      panel.addEventListener('transitionend', (e) => {
        // Only act when the transform transition ends
        if (e.propertyName === 'transform') {
          panel.style.transition = 'none'; // Remove transition for immediate positioning
          const rect       = panel.getBoundingClientRect();
          panel.style.top  = rect.top + 'px';
          panel.style.left = rect.left + 'px';
          setCookiePosition(rect.left, rect.top);
          panel.classList.remove('initial');
          panel.classList.remove('centered');
          // Optional: Restore short transition for dragging if desired
          // panel.style.transition = 'left 0.1s ease, top 0.1s ease';
        }
      }, { once: true }); // Important: Run only once
    }

    // Panel dragging
    let offsetX  = 0;
    let offsetY  = 0;
    let dragging = false;

    topBar.addEventListener('mousedown', (e) => {
      // Ignore clicks on interactive elements within the top bar
      if ((<HTMLElement>e.target).closest('#preset-menu, label')) return;

      dragging = true;
      offsetX  = e.clientX - panel.offsetLeft;
      offsetY  = e.clientY - panel.offsetTop;
      topBar.style.cursor    = 'grab';
      panel.style.transition = 'none'; // Disable transition during drag for responsiveness
    });

    document.addEventListener('mousemove', (e) => {
      if (!dragging) return;
      e.preventDefault(); // Prevent text selection

      const newLeft    = e.clientX - offsetX;
      const newTop     = e.clientY - offsetY;
      panel.style.left = `${newLeft}px`;
      panel.style.top  = `${newTop}px`;
      setCookiePosition(newLeft, newTop);
    });

    document.addEventListener('mouseup', () => {
      if (!dragging) return;

      dragging = false;
      topBar.style.cursor = 'move'; // Restore move cursor
      // Restore original transition after drag
      // panel.style.transition = 'transform 1s ease'; // Or whatever it should be
    });


    // Toggles (Original structure)
    // Controls
    function controlsSwitcher() {
      if (controlsChk.checked) {  // show controls
        controlsIcon.classList.add('selected-icon');
        controlsDiv.style.display = 'grid';
        helpChk.checked           = false;
        helpSwitcher(); // Ensure help updates if controls shown
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
        controlsSwitcher(); // Ensure controls updates if help shown
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
    liveSwitcher(); // <-- Call immediately after definition
    liveChk.addEventListener('change', liveSwitcher);

    // Copy override
    async function copyToClipboard() {
      const feedback     = shadow.getElementById('copy-feedback')!; // Get the new element
      const originalIcon = 'content_copy';
      feedback.classList.remove('visible');

      try {
        await navigator.clipboard.writeText(overrideArea.value);
        copyIcon.textContent = 'check_circle';
        copyIcon.style.color = 'limegreen';
        feedback.textContent = 'Copied!';
        feedback.classList.add('visible', 'success');

        setTimeout(() => {
          copyIcon.textContent = originalIcon;
          copyIcon.style.color = lightGray;
          feedback.classList.remove('visible', 'success');
        }, 3000);

      } catch (err) {
        console.error('Failed to copy! (navigator.clipboard requires "localhost" or HTTPS) - ', err);
        copyIcon.textContent = 'error';
        copyIcon.style.color = 'red';
        feedback.textContent = 'Failed!';
        feedback.classList.add('visible', 'failure');

        setTimeout(() => {
          copyIcon.textContent = originalIcon;
          copyIcon.style.color = lightGray;
          feedback.classList.remove('visible', 'failure');
        }, 5000);
      }
    }
    copyIcon.addEventListener('click', copyToClipboard);
  } // End initialize


  function attachShadow() {
    const host = document.createElement('div');
    host.id    = 'pagy-wand-host';
    document.body.appendChild(host);
    const scale = parseFloat((document.getElementById("pagy-wand"))!.getAttribute("data-scale")!);
    const style = <HTMLElement>document.getElementById('pagy-wand-default');
    document.head.appendChild(style);
    const shadow = host.attachShadow({ mode: 'closed' });
    // Append the gem-updated pagy.css, to override the user stylesheet
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
          font-size: ${scale * .8}rem;
          border-radius: ${scale}rem;
          padding-left: ${scale * 0.25}rem !important;
          border: none;
          box-shadow: inset 0 0 ${scale * 0.2}rem ${pagyColor};
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
                   ${scale * .75}rem
                   ${scale * 0.25}rem
                   ${scale * .875}rem;
          cursor: move;
          user-select: none;
          color: white;
          display: flex;
          align-items: center;
          justify-content: space-between;
          box-shadow: inset 0 0 ${scale * 0.2}rem ${pagyColor};
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
                       ${scale *  0.0625}rem 
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
          padding: ${scale * .8}rem ${scale}rem;
          border-top: ${scale * 0.15}rem solid ${pagyColor};
          border-bottom: ${scale * 0.15}rem solid ${pagyColor};
          height: ${scale * 29.7}rem;
        }
        #controls {
          display: grid;
          grid-template-columns: min-content 1fr;
          grid-template-rows: ${scale * 1.5}rem
                                  ${scale * .7}rem
                              repeat(3, ${scale * 1.3}rem)
                                  ${scale * .7}rem
                              repeat(4, ${scale * 1.3}rem)
                                  ${scale * .7}rem
                              repeat(3, ${scale * 1.3}rem)
                                  ${scale * .7}rem
                              ${scale * 12}rem;
          grid-column-gap: ${scale * 0.625}rem;
        }
        #controls hr.separator {
          grid-column: 1 / -1;
          border: none;
          border-bottom: ${scale * 0.15}rem dotted #909090; /* Style the line */
          width: 100%;
          height: ${scale * 0.03125}rem;
          align-self: center;
        }
        #controls input {
          margin: 0;
        }
        #controls input[type="range"] {
          align-self: center;
        }
        #hue {
          background: linear-gradient(to right, hsl(0, 100%, 50%), hsl(60, 100%, 50%), hsl(120, 100%, 50%), hsl(180, 100%, 50%), hsl(240, 100%, 50%), hsl(300, 100%, 50%), hsl(360, 100%, 50%));
          height: ${scale * .8}rem; /* Adjusted for thumb visibility */
        }
        #saturation {
          background: linear-gradient(to right, hsl(0, 0%, 50%), hsl(0, 100%, 50%)); /* Placeholder - JS will update */
          height: ${scale * .8}rem; /* Adjusted for thumb visibility */
        }
        #lightness {
          background: linear-gradient(to right, hsl(0, 100%, 0%), hsl(0, 100%, 50%), hsl(0, 100%, 100%)); /* Placeholder - JS will update */
          height: ${scale * .8}rem; /* Adjusted for thumb visibility */
        }
        #hue, #saturation, #lightness {
          -webkit-appearance: none;
          appearance: none;
          width: 100%;
          border-radius: ${scale * 0.5}rem; /* Rounded track */
          outline: none;
          box-shadow: inset 0 0 ${scale * 0.1}rem rgba(0,0,0,0.5);
        }
        #hue::-webkit-slider-thumb, #saturation::-webkit-slider-thumb, #lightness::-webkit-slider-thumb {
          -webkit-appearance: none;
          appearance: none;
          width: ${scale}rem; /* Thumb size */
          height: ${scale}rem; /* Thumb size */
          background: transparent;
          border: ${scale * 0.15}rem solid ${baseColor};
          border-radius: 50%;
          cursor: pointer;
        }
        #hue::-moz-range-thumb, #saturation::-moz-range-thumb, #lightness::-moz-range-thumb {
          width: ${scale}rem; /* Thumb size */
          height: ${scale}rem; /* Thumb size */
          background: transparent;
          border: ${scale * 0.15}rem solid ${baseColor};
          border-radius: 50%;
          cursor: pointer;
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
          padding: ${scale * .2}rem !important;
          border-radius: ${scale * .6}rem;
          line-height: 1.1;
          height: 100%;
          width: 100%;
          resize: none;
          font-weight: 500;
          box-sizing: border-box;  
          position: relative;
          margin-top: ${scale * .25}rem;
          color: white;
          background-color: black;
          opacity: .6;
        }
        #copy-icon {
          font-weight: 300;
          color: ${lightGray};
          position: absolute;
          top: ${scale * .8}rem;
          right: ${scale * .6}rem;
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
          margin-top: ${scale * .8}rem;
          margin-bottom: ${scale * .4}rem;
        }
        #help p {
          margin-top: ${scale * .4}rem;
          margin-bottom: ${scale * .3}rem;
        }
        #help dl {
          margin: 0;
        }
        #help dt {
          font-weight: bold;
          margin: ${scale * .4}rem 0 ${scale * .1}rem 0;
        }
        #help dd {
          margin-bottom: ${scale * .15}rem;
          margin-left: ${scale}rem;
        }
        #help .button-desc {
          margin-left: ${scale * .4}rem;
        }
        #help code {
          font-family: "Ubuntu Sans Mono", monospace;
          display: inline-block;
          line-height: ${scale * .8}rem;
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
            <hr class="separator">
            <label for="hue">Hue</label>
            <input type="range" id="hue" min="0" max="360">
            <label for="saturation">Saturation</label>
            <input type="range" id="saturation" min="0" max="100">
            <label for="lightness">Lightness</label>
            <input type="range" id="lightness" min="0" max="100">
            <hr class="separator">
            <label for="spacing">Spacing</label>
            <input type="range" id="spacing" min="0" max="1.5" step="0.0625">
            <label for="padding">Padding</label>
            <input type="range" id="padding" min="0" max="1.5" step="0.0625">
            <label for="rounding">Rounding</label>
            <input type="range" id="rounding" min="0" max="3" step="0.0625">
            <label for="borderWidth">Borders</label>
            <input type="range" id="borderWidth" min="0" max="0.25" step="0.03125">
            <hr class="separator">
            <label for="fontSize">Font Size</label>
            <input type="range" id="fontSize" min="0.75" max="2" step="0.0625">
            <label for="fontWeight">Font Weight</label>
            <input type="range" id="fontWeight" min="100" max="1000" step="50">
            <label for="lineHeight">Line Height</label>
            <input type="range" id="lineHeight" min="1.25" max="2.5" step="0.0625">
            <hr class="separator">
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
                <dd>There is no dynamic close button by design, so you won't forget to remove it in production.</dd>
            </dl>
            <h4>Controls</h4>
            <dl>
              <dt>Brightness</dt>
                <dd>Toggle between Light and Dark theming calculation. Adjust the lightness after toggling.</dd>
              <dt>Hue, Saturation, Lightness</dt>
                <dd>Generate any color, however notice that the automatic calculations work better within certain ranges/combinations.</dd>
              <dt>Spacing, Padding, Rounding, Borders</dt>
                <dd>Control the layout and overall look.</dd>
              <dt>Font Size, Font Weight, Line Height</dt>
                <dd>Control the typography of the page links.</dd>
              <dt>Interactions</dt>
                <dd>The combination of Padding, Font Size, Line Height, controls the internal proportions of the page links.</dd>
              <dt>CSS Override</dt>
                <dd>
                  <p>The set of <code>.pagy</code> rules currently applied.</p>
                  <ul style="list-style-type: none; padding-left: 0; margin: 0;">
                    <li><span class="material-symbols-rounded help-copy-icon">content_copy</span> <span class="button-desc">Copy the CSS Override</span></li>
                    <li><span class="material-symbols-rounded help-copy-icon success">check_circle</span> <span class="button-desc">Copied! Feedback</li>
                    <li><span class="material-symbols-rounded help-copy-icon failure">error</span> <span class="button-desc">Failed! Feedback</li>
                  </ul>
                </dd>
              <dt>Opacity</dt>
                <dd>It's a rarely used setting, so we didn't add it ATM. Just manually set the <code>--opacity</code> in your CSS Override if you need it.</dd>
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
  document.addEventListener('DOMContentLoaded', attachShadow);
})();
