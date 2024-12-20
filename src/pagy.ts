type NavArgs = readonly [OptionArgs?]
type NavJsArgs = readonly [Tokens, Sequels, null | LabelSequels, OptionArgs?]
type ComboJsArgs = readonly [string, OptionArgs?]
type SelectorJsArgs = readonly [number, string, OptionArgs?]
type InitArgs = ["nav", NavArgs] | ["nav_js", NavJsArgs] | ["combo_js", ComboJsArgs] | ["selector_js", SelectorJsArgs]
type Cutoff = readonly [string | number | boolean]
type CutoffsParam = [string, number, null | Cutoff, Cutoff | undefined]
type UpdateArgs = [string, number, Cutoff] | undefined
type Update = [string, UpdateArgs]

interface Cutoffs {
  [key:string]:Cutoff
}

interface OptionArgs {
  readonly page_param?:string
  readonly cutoffs_param?:string
  readonly update?:Update
}


interface Tokens {
  readonly before:string
  readonly a:string
  readonly current:string
  readonly gap:string
  readonly after:string
}

interface Sequels {readonly [width:string]:(string | number)[]}

interface LabelSequels {readonly [width:string]:string[]}

interface NavJsElement extends Element {pagyRender():void}

const Pagy = (() => {
  // The observer instance for responsive navs
  const rjsObserver = new ResizeObserver(
      entries => entries.forEach(e => e.target.querySelectorAll<NavJsElement>(".pagy-rjs")
                                       .forEach(el => el.pagyRender())));

  const b64 = {
    encode:     (unicode:string) => btoa(String.fromCharCode(...(new TextEncoder).encode(unicode))),
    toSafe:      (unsafe:string) => unsafe.replace(/=/g, "").replace(/[+/]/g, (match) => match == "+" ? "-" : "_"),
    safeEncode: (unicode:string) => b64.toSafe(b64.encode(unicode)),
    decode:      (base64:string) => (new TextDecoder()).decode(Uint8Array.from(atob(base64), c => c.charCodeAt(0))),
    // toUnsafe:      (safe:string) => safe.replace(/[-_]/g, (match) => match == "-" ? "+" : "/"),
    // safeDecode:  (base64:string) => b64.decode(b64.toUnsafe(base64))
  };

  // Init the *_nav helpers
  const initNav = (el:Element, [opts]:NavArgs) => {
    initKeysetForUI(el, opts);
  };

  // Init the keyset features
  const initKeysetForUI = (el:Element, opts:OptionArgs | undefined) => {
    if (opts === undefined || !Array.isArray(opts.update)) { return } // not enabled
    if (typeof opts.cutoffs_param !== "string" || typeof opts.page_param !== "string") {
      console.warn("Failed Pagy.initKeysetForUI():%o\n bad opts \n%o", el, opts);
      return;
    }
    const cutoffs_name = opts.cutoffs_param;
    const page_name    = opts.page_param;
    // Remove the cutoffs param from the address bar
    history.replaceState(null, null, location.href.replace(RegExp(`&?${cutoffs_name}=.*$`), ''));

    // Get key
    const prefix = 'pagy-';

    // eslint-disable-next-line prefer-const
    let [key, updateArgs] = opts.update;
    if (key === null) { key = prefix + Date.now().toString(36) }
    // The case of an unknown key and page > 1 should create links that go to
    // Get updated cutoffs
    const c = sessionStorage.getItem(key);
    const cutoffs = c === null ? {} as Cutoffs : JSON.parse(c) as Cutoffs;
      if (updateArgs !== undefined) {
        const [op, page, cutoff] = updateArgs;
        if (op === 'add') { cutoffs[(page).toString()] = cutoff }
      sessionStorage.setItem(key, JSON.stringify(cutoffs));
        console.warn("%o \n", cutoffs);
      }
    // Add cutoff param/value to the query string of the clicked links
    el.addEventListener("click", (e) => {
      const a:HTMLAnchorElement = e.target as HTMLAnchorElement; // checked below
      if (a && a.nodeName == "A" && a.href !== undefined) {
        const url = a.href;
        // find page from url
        const re = new RegExp(`(?<=\\?.*)${page_name}=([\\d]+)`);  // refactor removing the page param
        const p = url.match(re)?.[1]; // no trim allowed
        if (typeof p !== "string") {
          return;
        }
        const page  = parseInt(p);
        const value = b64.safeEncode(JSON.stringify([key,
                                                     Object.keys(cutoffs).length + 1,
                                                     cutoffs[(page - 1).toString()],
                                                     cutoffs[page.toString()]] as CutoffsParam));
        a.href      = url + (url.match(/\?/) === null ? "?" : "&") + `${cutoffs_name}=${value}`;
      }
    });

  };

  // Init the *_nav_js helpers
  const initNavJs = (el:NavJsElement, [tokens, sequels, labelSequels, opts]:NavJsArgs) => {
    const container = el.parentElement ?? el;
    const widths = Object.keys(sequels).map(w => parseInt(w)).sort((a, b) => b - a);
    let lastWidth = -1;
    const fillIn = (a:string, page:string, label:string):string =>
        a.replace(/__pagy_page__/g, page).replace(/__pagy_label__/g, label);
    (el.pagyRender = function () {
      const width = widths.find(w => w < container.clientWidth) || 0;
      if (width === lastWidth) { return } // no change: abort
      let html     = tokens.before;       // already trimmed by ruby in html
      const series = sequels[width.toString()];
      const labels = labelSequels?.[width.toString()] ?? series.map(l => l.toString());
      series.forEach((item, i) => {
        const label = labels[i];
        let filled;
        if (typeof item === "number") {
          filled = fillIn(tokens.a, item.toString(), label);
          if (typeof opts?.page_param === "string" && item === 1) { filled = trim(filled, opts.page_param) }
        } else if (item === "gap") {
          filled = tokens.gap;
        } else { // active page
          filled = fillIn(tokens.current, item, label);
        }
        html += filled;
      });
      html += tokens.after;   // already trimmed by ruby in html
      el.innerHTML = "";
      el.insertAdjacentHTML("afterbegin", html);
      lastWidth = width;
    })();
    if (el.classList.contains("pagy-rjs")) { rjsObserver.observe(container) }
  };

  // Init the *_combo_nav_js helpers
  const initComboJs = (el:Element, [url_token, opts]:ComboJsArgs) =>
      initInput(el, inputValue => [inputValue, url_token.replace(/__pagy_page__/, inputValue)], opts);

  // Init the limit_selector_js helper
  const initSelectorJs = (el:Element, [from, url_token, opts]:SelectorJsArgs) => {
    initInput(el, inputValue => {
      const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString();
      const url = url_token.replace(/__pagy_page__/, page).replace(/__pagy_limit__/, inputValue);
      return [page, url];
    }, opts);
  };

  // Init the input element
  const initInput = (el:Element, getVars:(v:string) => [string, string], opts?:OptionArgs) => {
    const input = el.querySelector("input") as HTMLInputElement;
    const link = el.querySelector("a") as HTMLAnchorElement;
    const initial = input.value;
    const action = function () {
      if (input.value === initial) { return }  // not changed
      const [min, val, max] = [input.min, input.value, input.max].map(n => parseInt(n) || 0);
      if (val < min || val > max) {  // reset invalid/out-of-range
        input.value = initial;
        input.select();
        return;
      }
      let [page, url] = getVars(input.value);   // eslint-disable-line prefer-const
      if (typeof opts?.page_param === "string" && page === "1") { url = trim(url, opts.page_param) }
      link.href = url;
      link.click();
    };
    ["change", "focus"].forEach(e => input.addEventListener(e, () => input.select()));  // auto-select
    input.addEventListener("focusout", action);                                         // trigger action
    input.addEventListener("keypress", e => { if (e.key === "Enter") { action() } });   // trigger action
  };

  // Trim the ${page-param}=1 params in links
  const trim = (a:string, param:string) =>
      a.replace(new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`), "");

  // Public interface
  return {
    version: "9.3.3",

    // Scan for elements with a "data-pagy" attribute and call their init functions with the decoded args
    init(arg?:Element) {
      const target = arg instanceof Element ? arg : document;
      const elements = target.querySelectorAll("[data-pagy]");
      for (const el of elements) {
        try {
          // const uint8array = Uint8Array.from(atob(el.getAttribute("data-pagy") as string), c => c.charCodeAt(0));
          // const [keyword, ...args] = JSON.parse((new TextDecoder()).decode(uint8array)) as InitArgs; // base64-utf8 -> JSON ->// Array
          const [keyword, ...args] = JSON.parse(b64.decode(el.getAttribute("data-pagy") as string)) as InitArgs; // base64-utf8 -> JSON ->// Array
          if (keyword === "nav") {
            initNav(el, args as unknown as NavArgs);
          } else if (keyword === "nav_js") {
            initNavJs(el as NavJsElement, args as unknown as NavJsArgs);
          } else if (keyword === "combo_js") {
            initComboJs(el, args as unknown as ComboJsArgs);
          } else if (keyword === "selector_js") {
            initSelectorJs(el, args as unknown as SelectorJsArgs);
          }
          //else { console.warn("Failed Pagy.init(): %o\nUnknown keyword '%s'", el, keyword) }
        } catch (err) { console.warn("Failed Pagy.init(): %o\n%s", el, err) }
      }
    }
  };
})();

export default Pagy;
