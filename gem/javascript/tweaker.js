(()=>{const X=(x)=>btoa(String.fromCharCode(...new TextEncoder().encode(x))).replace(/[+/=]/g,(F)=>F=="+"?"-":F=="/"?"_":""),M=(x)=>new TextDecoder().decode(Uint8Array.from(atob(x),(F)=>F.charCodeAt(0))),Y=(x)=>document.cookie=`${x}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`,E=(x,F)=>document.cookie=`${x}=${X(F)}; path=/`,T=(x)=>{const F=`${x}=`,j=document.cookie.split(";");for(let H=0;H<j.length;H++){let L=j[H].trim();if(L.startsWith(F))return M(L.substring(F.length))}return null},N=16,I=(x)=>{const F=x.getElementById("overlay"),j=x.getElementById("panel"),H=x.getElementById("top-bar"),L=x.getElementById("toggle"),K=x.getElementById("controls"),U=x.getElementById("help-icon"),J=x.getElementById("help"),V=()=>{const q=T("pagy-tweaker-position");if(q){const[$,Q]=q.split(",");return{left:parseInt($),top:parseInt(Q)}}return null},A=(q,$)=>{E("pagy-tweaker-position",`${q},${$}`)},_=()=>{const q=parseInt(j.style.left),$=parseInt(j.style.top),Q=j.getBoundingClientRect();if(Q.left<0)j.style.left="0px";else if(Q.right>window.innerWidth)j.style.left=`${window.innerWidth-j.offsetWidth}px`;if(Q.top<0)j.style.top="0px";else if(Q.bottom>window.innerHeight)j.style.top=`${window.innerHeight-j.offsetHeight}px`;if(Q.top<0&&j.offsetHeight<window.innerHeight)j.style.top="0px";A(q,$)};window.addEventListener("resize",_);const z=V();if(z){j.style.left=`${z.left}px`;j.style.top=`${z.top}px`}else{j.style.left=`${(window.innerWidth-j.offsetWidth)/2}px`;j.style.top=`${(window.innerHeight-j.offsetHeight)/2}px`;_()}let G=0,W=0,O=!1;H.addEventListener("mousedown",(q)=>{if(q.target.closest("#preset-menu"))return;O=!0;G=q.clientX-j.offsetLeft;W=q.clientY-j.offsetTop});j.addEventListener("mousedown",(q)=>{if(!(q.target===H||q.ctrlKey||q.metaKey))return;O=!0;G=q.clientX-j.offsetLeft;W=q.clientY-j.offsetTop});document.addEventListener("mousemove",(q)=>{if(!O)return;j.style.left=`${q.clientX-G}px`;j.style.top=`${q.clientY-W}px`;A(q.clientX-G,q.clientY-W)});document.addEventListener("mouseup",()=>O=!1);document.addEventListener("keydown",(q)=>{if(q.ctrlKey||q.metaKey){F.style.display="block";F.style.width=`${j.offsetWidth}px`;F.style.height=`${j.offsetHeight}px`}});document.addEventListener("keyup",(q)=>{if(!q.ctrlKey&&!q.metaKey)F.style.display="none"});const Z=()=>{if(K.style.display!=="none"||J.style.display!=="none"){K.style.display="none";J.style.display="none"}else K.style.display="grid"};L.addEventListener("click",Z);H.addEventListener("dblclick",Z);U.addEventListener("click",()=>{J.style.display="block";J.style.height=`${K.clientHeight-N*2}px`;K.style.display="none"});J.addEventListener("click",()=>{J.style.display="none";K.style.display="grid"})},R=(x)=>{const F=document.createElement("style");F.id="pagy-tweaker-override-style-tag";document.head.appendChild(F);let j={brightness:{name:"--B",unit:""},hue:{name:"--H",unit:""},saturation:{name:"--S",unit:""},lightness:{name:"--L",unit:""},spacing:{name:"--spacing",unit:"rem"},padding:{name:"--padding",unit:"rem"},rounding:{name:"--rounding",unit:"rem"},borderWidth:{name:"--border-width",unit:"rem"},fontSize:{name:"--font-size",unit:"rem"},fontWeight:{name:"--font-weight",unit:""},lineHeight:{name:"--line-height",unit:""}};for(const[z,G]of Object.entries(j))G.input=x.getElementById(z);const H=document.getElementById("pagy-tweaker-override-style-tag"),L=x.getElementById("override"),K=()=>{let z=".pagy {\n";Object.values(j).forEach((G)=>{z+=`  ${G.name}: ${G.input.value}${G.unit};\n`});z+="}";L.value=z;H.textContent=z;E("pagy-tweaker-override",z)},U={Default:`
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
      `,Dark:`
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
      `,MidnighExpress:`
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
      `,Pilloween:` 
      .pagy {
        --B: -1;
        --H: 10;
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
      `,Peppermint:`
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
      `,CocoaBeans:`
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
      `,PurpleStripe:`
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
      `,GhostInThought:`
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
      `,VintageScent:`
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
      `},J=x.getElementById("preset-menu");for(const z in U){const G=document.createElement("option");G.value=z;G.textContent=z;J.appendChild(G)}const V=(z)=>{(z?(Y("pagy-tweaker-override"),U[z]):T("pagy-tweaker-override"))?.match(/--[^:]+:\s*[^;]+/g)?.forEach((W)=>{let[O,Z]=W.split(":");O=O.trim();Z=Z.trim().replace(/[a-zA-Z%]+$/,"");for(const q of Object.values(j))if(q.name===O){q.input.value=Z;break}});E("pagy-tweaker-preset",z||"");K()};J.addEventListener("change",(z)=>V(z.target.value));const A=()=>{J.value="";E("pagy-tweaker-preset","")};Object.values(j).forEach((z)=>{z.input.addEventListener("input",K);z.input.addEventListener("input",A)});const _=T("pagy-tweaker-preset")??"Default";J.value=_;V(_)},b=()=>{const x=document.createElement("div");x.id="pagy-tweaker-host";document.body.appendChild(x);[{rel:"preconnect",href:"https://fonts.googleapis.com"},{rel:"preconnect",href:"https://fonts.gstatic.com",crossorigin:"anonymous"},{href:"https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&family=Ubuntu+Sans+Mono:ital,wght@0,400..700;1,400..700&display=swap",rel:"stylesheet"}].forEach((L)=>{const K=document.createElement("link");Object.entries(L).forEach(([U,J])=>{K.setAttribute(U,J)});document.head.appendChild(K)});const F=document.createElement("style");F.id="pagy-tweaker-style-tag";const j=document.getElementById("pagy-tweaker");F.textContent=M(j.getAttribute("data-pagy-css"));document.head.appendChild(F);const H=x.attachShadow({mode:"open"});H.innerHTML=`
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
          background: rgba(0, 0, 0, 0);
          cursor: move;
          z-index: 10;
          display: none;
        }
        #panel {
          accent-color: var(--base-color);
          font-family: 'Nunito Sans', sans-serif !important;
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
    `;R(H);I(H)};document.addEventListener("DOMContentLoaded",b)})();