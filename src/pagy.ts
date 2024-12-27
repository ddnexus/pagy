type InitArgs       = ["nav", CutoffArgs] | ["nav_js", NavJsArgs] | ["combo_js", ComboJsArgs] | ["selector_js", SelectorJsArgs]
type CutoffArgs     = readonly [pageSym:string, update:[storageKey:string, splice?:SpliceArgs]]
type SpliceArgs     = readonly [start:number, deleteCount:number, ...items:Cutoff[]]
type Cutoff         = readonly (string | number | boolean)[]
type CutoffsParams  = [pagyId:string, storageKey:string, pageNumber:number, pages:number, prevCutoff?:Cutoff, pageCutoff?:Cutoff]
type NavJsArgs      = readonly [Tokens, Sequels, LabelSequels, CutoffArgs]
type ComboJsArgs    = readonly [urlToken:string]
type SelectorJsArgs = readonly [from:number, urlToken:string]
interface SyncData {
  from?: number
  to?: number
  key: string
  cutoffs?: string
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

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const Pagy = (() => {
  const storageSupport = 'sessionStorage' in window && 'BroadcastChannel' in window;
  let storage: Storage, sync: BroadcastChannel, tabId: number;
  if (storageSupport) {
    storage = sessionStorage; // shorten the .min.js
    sync    = new BroadcastChannel("pagy");
    tabId   = Date.now();
    // Sync the sessionStorage keys for the cutoffs opened in a new tab/window
    sync.addEventListener("message", (e:MessageEvent<SyncData>) => {
      if (e.data.from) { // request cutoffs
        const cutoffs = storage.getItem(e.data.key);
        if (cutoffs) {
          sync.postMessage(<SyncData>{to: e.data.from, key: e.data.key, cutoffs: cutoffs});
        } // send response
      } else if (e.data.to) {  // receive cutoffs
        if (e.data.to == tabId) {
          storage.setItem(e.data.key, <string>e.data.cutoffs);
        }
      }
    });
  }
  // The observer instance for responsive navs
  const rjsObserver = new ResizeObserver(
      entries => entries.forEach(e => {
        e.target.querySelectorAll<NavJsElement>(".pagy-rjs").forEach(el => el.pagyRender());
      }));

  const B64Encode     = (unicode:string) => btoa(String.fromCharCode(...(new TextEncoder).encode(unicode))),
        B64Safe       = (unsafe:string)  => unsafe.replace(/=/g, "").replace(/[+/]/g, (match) => match == "+" ? "-" : "_"),
        B64SafeEncode = (unicode:string) => B64Safe(B64Encode(unicode)),
        B64Decode     = (base64:string)  => (new TextDecoder()).decode(Uint8Array.from(atob(base64), c => c.charCodeAt(0)));
        // B64Unsafe     = (safe:string) => safe.replace(/[-_]/g, (match) => match == "-" ? "+" : "/"),
        // B64SafeDecode = (base64:string) => B64Decode(B64Unsafe(base64))

  // Init the Cutoffs features
  const initCutoffs = async (el:Element, [pageSym, [storageKey, spliceArgs]]:CutoffArgs) => {
    if (!storageSupport) { return }

    let browserId = document.cookie.split(/;\s+/)  // it works even if malformed
                            .find((row) => row.startsWith("pagy="))
                            ?.split("=")[1];
    if (!browserId) {
      document.cookie = "pagy=" + (browserId = Math.floor(Math.random() * 36 ** 3).toString(36));
    }
    if (storageKey && !(storageKey in storage)) {
      // Sync the sessiongStorage from other tabs/windows (e.g. open page in new tab/window)
      sync.postMessage(<SyncData>{ from: tabId, key: storageKey });
      // Wait for the listener to copy the cutoffs in the current sessionStorage
      await new Promise<string|null>((resolve) => setTimeout(() => resolve(""), 100));
    }
    storageKey  ||= "pagy-" + Date.now().toString(36);
    const data    = storage.getItem(storageKey),
          cutoffs = <Cutoff[]>(data ? JSON.parse(data) : [undefined]);
    if (spliceArgs) {
      cutoffs.splice(...spliceArgs);
      storage.setItem(storageKey, JSON.stringify(cutoffs));
    }
    // Augment the page param of each url
    for (const a of <HTMLAnchorElement[]><unknown>el.querySelectorAll('a[href]')) {
      const url     = a.href,
            re      = new RegExp(`(?<=\\?.*)\\b${pageSym}=([\\d]+)`),  // find the numeric page
            pageNum = parseInt(<string>url.match(re)?.[1]),            // page=\d+ is always in href
            value   = B64SafeEncode(JSON.stringify(<CutoffsParams>[browserId,
                                                                   storageKey,
                                                                   pageNum,
                                                                   cutoffs.length,       // pages
                                                                   cutoffs[pageNum - 1], // prevCutoff
                                                                   cutoffs[pageNum]]));  // pageCutoff
      a.href = url.replace(re, `${pageSym}=${value}`);
    }
  };

  // Init the *_nav_js helpers
  const initNavJs = (el:NavJsElement, [tokens, sequels, labelSequels, cutoffArgs]:NavJsArgs) => {
    const container = el.parentElement ?? el,
          widths    = Object.keys(sequels).map(w => parseInt(w)).sort((a, b) => b - a);
    let lastWidth   = -1;
    const fillIn    = (a:string, page:string, label:string) =>
                        a.replace(/__pagy_page__/g, page).replace(/__pagy_label__/g, label);
    (el.pagyRender = () => {
      const width = widths.find(w => w < container.clientWidth) || 0;
      if (width === lastWidth) { return } // no change: abort

      let html     = tokens.before;
      const series = sequels[width.toString()],
            labels = labelSequels?.[width.toString()] ?? series.map(l => l.toString());
      series.forEach((item, i) => {
        const label = labels[i];
        let filled;
        if (typeof item == "number") {
          filled = fillIn(tokens.a, item.toString(), label);
        } else if (item == "gap") {
          filled = tokens.gap;
        } else { // active page
          filled = fillIn(tokens.current, item, label);
        }
        html += filled;
      });
      html += tokens.after;

      el.innerHTML = "";
      el.insertAdjacentHTML("afterbegin", html);
      lastWidth = width;
      if (cutoffArgs) { void initCutoffs(el, cutoffArgs) }
    })();
    if (el.classList.contains("pagy-rjs")) { rjsObserver.observe(container) }
  };

  // Init the *_combo_nav_js helpers
  const initComboJs = (el:Element, [url_token]:ComboJsArgs) =>
      initInput(el, inputValue => url_token.replace(/__pagy_page__/, inputValue));

  // Init the limit_selector_js helper
  const initSelectorJs = (el:Element, [from, url_token]:SelectorJsArgs) => {
    initInput(el, inputValue => {
      const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString();
      return url_token.replace(/__pagy_page__/, page).replace(/__pagy_limit__/, inputValue);
    });
  };

  // Init the input element
  const initInput = (el:Element, getUrl:(v:string) => string) => {
    const input   = <HTMLInputElement>el.querySelector("input"),
          link    = <HTMLAnchorElement>el.querySelector("a"),
          initial = input.value,
          action  = () => {
      if (input.value === initial) { return }  // not changed
      const [min, val, max] = [input.min, input.value, input.max].map(n => parseInt(n) || 0);
      if (val < min || val > max) {  // reset invalid/out-of-range
        input.value = initial;
        input.select();
        return;
      }
      link.href = getUrl(input.value);
      link.click();
    };
    ["change", "focus"].forEach(e => input.addEventListener(e, () => input.select()));  // auto-select
    input.addEventListener("focusout", action);                                         // trigger action
    input.addEventListener("keypress", e => { if (e.key == "Enter") { action() } });    // trigger action
  };

  // Public interface
  return {
    version: "9.3.3",

    // Scan for elements with a "data-pagy" attribute and call their init functions with the decoded args
    init(arg?:Element) {
      const target   = arg instanceof Element ? arg : document,
            elements = target.querySelectorAll("[data-pagy]");
      for (const el of elements) {
        try {
          const [keyword, ...args] = <InitArgs>JSON.parse(B64Decode(<string>el.getAttribute("data-pagy")));
          if (keyword == "nav") {
            void initCutoffs(el, <CutoffArgs><unknown>args);
          } else if (keyword == "nav_js") {
            initNavJs(<NavJsElement>el, <NavJsArgs><unknown>args);
          } else if (keyword == "combo_js") {
            initComboJs(el, <ComboJsArgs><unknown>args);
          } else if (keyword == "selector_js") {
            initSelectorJs(el, <SelectorJsArgs><unknown>args);
          }
          //else { console.warn("Pagy.init() error: %o\nUnknown keyword '%s'", el, keyword) }
        } catch (err) { console.warn("Pagy.init() error: %o\n%s", el, err) }
      }
    }
  };
})();
