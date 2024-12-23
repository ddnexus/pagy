type InitArgs       = ["nav", NavArgs] | ["nav_js", NavJsArgs] | ["combo_js", ComboJsArgs] | ["selector_js", SelectorJsArgs]
type NavArgs        = readonly [OptionArgs?]
type NavJsArgs      = readonly [Tokens, Sequels, null | LabelSequels, OptionArgs?]
type ComboJsArgs    = readonly [string, OptionArgs?]
type SelectorJsArgs = readonly [number, string, OptionArgs?]
type Cutoff         = readonly [string | number | boolean]
type SpliceArgs     = readonly [number, number, ...Cutoff[]] | [number, number]
type Update         = [string, SpliceArgs] | [string]
type Cutoffs        = [null, ...Cutoff[]]
type CutoffsParam   = [string, string, number, null | Cutoff, Cutoff | undefined]

interface SyncData {
  from?: number
  to?: number
  key: string
  cutoffs?: string
}

interface OptionArgs {
  readonly page_param?: string
  readonly cutoffs_param?: string
  readonly update?: Update
}

interface Tokens {
  readonly before: string
  readonly a: string
  readonly current: string
  readonly gap: string
  readonly after: string
}

interface Sequels {readonly [width:string]:(string | number)[]}
interface LabelSequels {readonly [width:string]:string[]}
interface NavJsElement extends Element {pagyRender():void}
interface CutoffElement extends NavJsElement, Element {completeUrls():void}

const Pagy = (() => {

  // Sync the sessionStorage keys for the cutoffs used in the new tab/window
  // e.g. copy/paste the page number link in a new window or page link right-click "Open in a new tab/window"
  const sS    = sessionStorage, // shorten the .min.js
        sync  = new BroadcastChannel("pagy"),
        tabId = Date.now();

  sync.addEventListener("message", (e: MessageEvent<SyncData>) => {
    if (e.data.from) { // request cutoffs
     const cutoffs = sS.getItem(e.data.key);
      if (cutoffs) { sync.postMessage(<SyncData>{to: e.data.from, key: e.data.key, cutoffs: cutoffs}) } // send response
    } else if (e.data.to) {  // receive cutoffs
      if (e.data.to == tabId) {
        sS.setItem(e.data.key, <string>e.data.cutoffs);
      }
    }
  });

  // The observer instance for responsive navs
  const rjsObserver = new ResizeObserver(
      entries => entries.forEach(e => {
        e.target.querySelectorAll<NavJsElement>(".pagy-rjs").forEach(el => el.pagyRender());
        e.target.querySelectorAll<CutoffElement>(".pagy-keyset").forEach(el => el.completeUrls());
      }));

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
    void initCutoff(<CutoffElement>el, opts);
  };

// Init the Cutoff features
  const initCutoff = async (el:CutoffElement, opts?:OptionArgs) => {
    if (!opts || !Array.isArray(opts.update)                 // not enabled
              || !opts.cutoffs_param || !opts.page_param) {  // Bad opts
      // console.warn("Failed Pagy.initCutoff():%o\n Bad opts \n%o", el, opts);
      return;
    }
    const pagyId    = document.cookie.split(/;\s+/)  // it works even if malformed
                              .find((row) => row.startsWith("pagy="))
                              ?.split("=")[1] || Math.floor(Math.random() * 36 ** 3).toString(36);
    document.cookie = "pagy=" + pagyId;

    // eslint-disable-next-line prefer-const
    let [key, ...spliceArgs] = opts.update;
    if (key && !(key in sS)) {
      // Sync the sessiongStorage from other tabs/windows (e.g. open page in new tab/window)_
      sync.postMessage(<SyncData>{ from: tabId, key: key });
      // Wait for the listener to copy the cutoffs in the current sessionStorage
      await new Promise<string|null>((resolve) => setTimeout(() => resolve(""), 100) );
    }
    key ||= "pagy-" + Date.now().toString(36);
    const cs      = sS.getItem(key),
          cutoffs = <Cutoffs>(cs ? JSON.parse(cs) : [null]);
    if (spliceArgs) {
      // @ts-expect-error: spliceArgs should be a tuple type or passed to a rest param, but it contains all the args
      cutoffs.splice(...spliceArgs);
      sS.setItem(key, JSON.stringify(cutoffs));
    }
    (el.completeUrls = () => {
      for (const a of <HTMLAnchorElement[]><unknown>el.querySelectorAll('a[href]')) {
        const url   = a.href,
              re    = new RegExp(`(?<=\\?.*)\\b${opts.page_param}=([\\d]+)`),  // find the numeric page
              page  = parseInt(<string>url.match(re)?.[1]),                    // sure that page=\d+ is in href
              value = b64.safeEncode(JSON.stringify(<CutoffsParam>[pagyId,
                                                                   key,
                                                                   cutoffs.length,   // actual cutoffs + 1 (first null)
                                                                   cutoffs[page - 1],
                                                                   cutoffs[page]]));
        a.href = url + `&${opts.cutoffs_param}=${value}`;   // "&" because the query_string is always present
      }
    })();
  };

  // Init the *_nav_js helpers
  const initNavJs = (el:NavJsElement, [tokens, sequels, labelSequels, opts]:NavJsArgs) => {
    const container = el.parentElement ?? el,
          widths    = Object.keys(sequels).map(w => parseInt(w)).sort((a, b) => b - a);
    let lastWidth   = -1;
    const fillIn    = (a:string, page:string, label:string) =>
                        a.replace(/__pagy_page__/g, page).replace(/__pagy_label__/g, label);
    (el.pagyRender = () => {
      const width = widths.find(w => w < container.clientWidth) || 0;
      if (width === lastWidth) { return } // no change: abort
      let html     = tokens.before;       // already trimmed by ruby in html
      const series = sequels[width.toString()],
            labels = labelSequels?.[width.toString()] ?? series.map(l => l.toString());
      series.forEach((item, i) => {
        const label = labels[i];
        let filled;
        if (typeof item == "number") {
          filled = fillIn(tokens.a, item.toString(), label);
          if (typeof opts?.page_param == "string" && item == 1) { filled = trim(filled, opts.page_param) }
        } else if (item == "gap") {
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
      const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString(),
            url  = url_token.replace(/__pagy_page__/, page).replace(/__pagy_limit__/, inputValue);
      return [page, url];
    }, opts);
  };

  // Init the input element
  const initInput = (el:Element, getVars:(v:string) => [string, string], opts?:OptionArgs) => {
    const input   = el.querySelector("input") as HTMLInputElement,
          link    = el.querySelector("a") as HTMLAnchorElement,
          initial = input.value;
    const action  = () => {
      if (input.value === initial) { return }  // not changed
      const [min, val, max] = [input.min, input.value, input.max].map(n => parseInt(n) || 0);
      if (val < min || val > max) {  // reset invalid/out-of-range
        input.value = initial;
        input.select();
        return;
      }
      let [page, url] = getVars(input.value);   // eslint-disable-line prefer-const
      if (typeof opts?.page_param == "string" && page === "1") { url = trim(url, opts.page_param) }
      link.href = url;
      link.click();
    };
    ["change", "focus"].forEach(e => input.addEventListener(e, () => input.select()));  // auto-select
    input.addEventListener("focusout", action);                                         // trigger action
    input.addEventListener("keypress", e => { if (e.key == "Enter") { action() } });   // trigger action
  };

  // Trim the ${page-param}=1 params in links
  const trim = (a:string, param:string) =>
      a.replace(new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`), "");

  // Public interface
  return {
    version: "9.3.3",

    // Scan for elements with a "data-pagy" attribute and call their init functions with the decoded args
    init(arg?:Element) {
      const target   = arg instanceof Element ? arg : document,
            elements = target.querySelectorAll("[data-pagy]");
      for (const el of elements) {
        try {
          const [keyword, ...args] = <InitArgs>JSON.parse(b64.decode(<string>el.getAttribute("data-pagy")));
          if (keyword == "nav") {
            initNav(el, <NavArgs>args);
          } else if (keyword == "nav_js") {
            initNavJs(<NavJsElement>el, <NavJsArgs><unknown>args);
          } else if (keyword == "combo_js") {
            initComboJs(el, <ComboJsArgs><unknown>args);
          } else if (keyword == "selector_js") {
            initSelectorJs(el, <SelectorJsArgs><unknown>args);
          }
          //else { console.warn("Failed Pagy.init(): %o\nUnknown keyword '%s'", el, keyword) }
        } catch (err) { console.warn("Failed Pagy.init(): %o\n%s", el, err) }
      }
    }
  };
})();

export default Pagy;
