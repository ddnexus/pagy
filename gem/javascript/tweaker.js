(()=>{const T=(x)=>btoa(String.fromCharCode(...new TextEncoder().encode(x))).replace(/[+/=]/g,(F)=>F=="+"?"-":F=="/"?"_":""),X=(x)=>new TextDecoder().decode(Uint8Array.from(atob(x),(F)=>F.charCodeAt(0))),Y=(x)=>document.cookie=`${x}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`,$=(x,F)=>document.cookie=`${x}=${T(F)}; path=/`,M=(x)=>{const F=`${x}=`,j=document.cookie.split(";");for(let J=0;J<j.length;J++){let Q=j[J].trim();if(Q.startsWith(F))return X(Q.substring(F.length))}return null},N=16,B=(x)=>{const F=x.getElementById("overlay"),j=x.getElementById("panel"),J=x.getElementById("top-bar"),Q=x.getElementById("toggle"),K=x.getElementById("controls"),A=x.getElementById("help-icon"),H=x.getElementById("help"),V=()=>{const q=M("pagy-tweaker-position");if(q){const[_,O]=q.split(",");return{left:parseInt(_),top:parseInt(O)}}return null},E=(q,_)=>{$("pagy-tweaker-position",`${q},${_}`)},Z=()=>{const q=parseInt(j.style.left),_=parseInt(j.style.top),O=j.getBoundingClientRect();if(O.left<0)j.style.left="0px";else if(O.right>window.innerWidth)j.style.left=`${window.innerWidth-j.offsetWidth}px`;if(O.top<0)j.style.top="0px";else if(O.bottom>window.innerHeight)j.style.top=`${window.innerHeight-j.offsetHeight}px`;if(O.top<0&&j.offsetHeight<window.innerHeight)j.style.top="0px";E(q,_)};window.addEventListener("resize",Z);const z=V();if(z){j.style.left=`${z.left}px`;j.style.top=`${z.top}px`}else{j.style.left=`${(window.innerWidth-j.offsetWidth)/2}px`;j.style.top=`${(window.innerHeight-j.offsetHeight)/2}px`;Z()}let G=0,U=0,L=!1;J.addEventListener("mousedown",(q)=>{if(q.target.closest("#preset-menu"))return;L=!0;G=q.clientX-j.offsetLeft;U=q.clientY-j.offsetTop});j.addEventListener("mousedown",(q)=>{if(!(q.target===J||q.ctrlKey||q.metaKey))return;L=!0;G=q.clientX-j.offsetLeft;U=q.clientY-j.offsetTop});document.addEventListener("mousemove",(q)=>{if(!L)return;j.style.left=`${q.clientX-G}px`;j.style.top=`${q.clientY-U}px`;E(q.clientX-G,q.clientY-U)});document.addEventListener("mouseup",()=>L=!1);document.addEventListener("keydown",(q)=>{if(q.ctrlKey||q.metaKey){F.style.display="block";F.style.width=`${j.offsetWidth}px`;F.style.height=`${j.offsetHeight}px`}});document.addEventListener("keyup",(q)=>{if(!q.ctrlKey&&!q.metaKey)F.style.display="none"});const W=()=>{if(K.style.display!=="none"||H.style.display!=="none"){K.style.display="none";H.style.display="none"}else{H.style.display="block";K.style.display="grid"}};Q.addEventListener("click",W);J.addEventListener("dblclick",W);A.addEventListener("click",()=>{H.style.display="block";H.style.height=`${K.clientHeight-N*2}px`;K.style.display="none"});H.addEventListener("click",()=>{H.style.display="none";K.style.display="grid"})},I=(x)=>{const F=document.createElement("style");F.id="pagy-tweaker-override-style-tag";document.head.appendChild(F);let j={brightness:{name:"--B",unit:""},hue:{name:"--H",unit:""},saturation:{name:"--S",unit:""},lightness:{name:"--L",unit:""},opacity:{name:"--opacity",unit:""},spacing:{name:"--spacing",unit:"rem"},padding:{name:"--padding",unit:"rem"},rounding:{name:"--rounding",unit:"rem"},borderWidth:{name:"--border-width",unit:"rem"},fontSize:{name:"--font-size",unit:"rem"},fontWeight:{name:"--font-weight",unit:""},lineHeight:{name:"--line-height",unit:""}};for(const[z,G]of Object.entries(j))G.input=x.getElementById(z);const J=document.getElementById("pagy-tweaker-override-style-tag"),Q=x.getElementById("override"),K=()=>{let z=".pagy {\n";Object.values(j).forEach((G)=>{z+=`  ${G.name}: ${G.input.value}${G.unit};\n`});z+="}";Q.value=z;J.textContent=z;$("pagy-tweaker-override",z)},A={Default:`
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
      `,Dark:`
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
      `,MidnighExpress:`
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
      `,Pilloween:` 
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
      `,Peppermint:`
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
      `,CocoaBeans:`
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
      `,PurpleStripe:`
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
      `,GhostInThought:`
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
      `,VintageScent:`
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
      `},H=x.getElementById("preset-menu");for(const z in A){const G=document.createElement("option");G.value=z;G.textContent=z;H.appendChild(G)}const V=(z)=>{(z?(Y("pagy-tweaker-override"),A[z]):M("pagy-tweaker-override"))?.match(/--[^:]+:\s*[^;]+/g)?.forEach((U)=>{let[L,W]=U.split(":");L=L.trim();W=W.trim().replace(/[a-zA-Z%]+$/,"");for(const q of Object.values(j))if(q.name===L){q.input.value=W;break}});$("pagy-tweaker-preset",z||"");K()};H.addEventListener("change",(z)=>V(z.target.value));const E=()=>{H.value="";$("pagy-tweaker-preset","")};Object.values(j).forEach((z)=>{z.input.addEventListener("input",K);z.input.addEventListener("input",E)});const Z=M("pagy-tweaker-preset")??"Default";H.value=Z;V(Z)},b=()=>{const x=document.createElement("div");x.id="pagy-tweaker-host";document.body.appendChild(x);const F=x.attachShadow({mode:"open"});F.innerHTML=`
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
          padding: ${N}px;
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
          <span id="toggle">\u2630</span><span id="title">PagyTweaker</span>
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
              <dd>Click on the <b>\u2630</b> icon or double-click on the Top Bar.</dd>
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
    `;I(F);B(F)};document.addEventListener("DOMContentLoaded",b)})();