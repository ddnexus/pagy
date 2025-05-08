interface SyncData {
  from?: number
  to?:   number
  key:   string
  str?:  string
}
type InitArgs = ["k",  KeynavArgs] |          // series_nav[_js] with keynav instance
                ["snj", SeriesNavJsArgs] |    // series_nav_js
                ["inj", InputNavJsArgs] |     // input_nav_js
                ["ltj", LimitTagJsArgs]       // limit_tag_js
type AugmentKeynav = (nav:HTMLElement, keynavArgs:KeynavArgs) => Promise<((page: string) => string)>
type KeynavArgs = readonly [storageKey:  string | null,
                            pageKey:     string,
                            last:        number,
                            spliceArgs?: SpliceArgs]
type SpliceArgs = readonly [start:       number,
                            deleteCount: number,     // it would be optional, but ts complains
                            ...items:    Cutoff[]]
type Cutoff = readonly (string | number | boolean)[]
type AugmentedPage = [browserId:   string,
                      storageKey:  string,
                      pageNumber:  number,
                      pages:       number,
                      priorCutoff: Cutoff | null,
                      pageCutoff:  Cutoff | null]
type SeriesNavJsArgs = readonly [NavJsTokens, NavJsSeries, KeynavArgs?]
type NavJsSeries = readonly [widths: number[],
                             series: (string | number)[][],
                             labels: string[][] | null]
type InputNavJsArgs = readonly [urlToken: string, KeynavArgs?]
type LimitTagJsArgs = readonly [from:     number,
                                urlToken: string]
type NavJsTokens = readonly [before:  string,
                             anchor:  string,
                             current: string,
                             gap:     string,
                             after:   string]
interface NavJsElement extends HTMLElement {
  render(): void
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const Pagy = (() => {
  const storageSupport = 'sessionStorage' in window && 'BroadcastChannel' in window,
        pageRe         = "P ";  // shorten the compiled size
  // eslint-disable-next-line prefer-const
  let pagy = "pagy", storage: Storage, sync: BroadcastChannel, tabId: number;
  if (storageSupport) {
    storage = sessionStorage; // shorten the compiled size
    sync    = new BroadcastChannel(pagy);
    tabId   = Date.now();
    // Sync the sessionStorage keys for the cutoffs opened in a new tab/window
    sync.addEventListener("message", (e:MessageEvent<SyncData>) => {
      if (e.data.from) { // request cutoffs
        const cutoffs = storage.getItem(e.data.key);
        if (cutoffs) {
          sync.postMessage(<SyncData>{to: e.data.from, key: e.data.key, str: cutoffs});
        } // send response
      } else if (e.data.to) {  // receive cutoffs
        if (e.data.to == tabId) {
          storage.setItem(e.data.key, <string>e.data.str);
        }
      }
    });
  }
  // The observer instance for responsive navs
  const rjsObserver = new ResizeObserver(
      entries => entries.forEach(e => {
        e.target.querySelectorAll<NavJsElement>(".pagy-rjs").forEach(el => el.render());
      }));

  /* Full set of B64 functions
  const B64Encode     = (unicode:string) => btoa(String.fromCharCode(...(new TextEncoder).encode(unicode))),
        B64Safe       = (unsafe:string)  => unsafe.replace(/[+/=]/g, (m) => m == "+" ? "-" : m == "/" ? "_" : ""),
        B64SafeEncode = (unicode:string) => B64Safe(B64Encode(unicode)),
        B64Decode     = (base64:string)  => (new TextDecoder()).decode(Uint8Array.from(atob(base64), c => c.charCodeAt(0))),
        B64Unsafe     = (safe:string)    => safe.replace(/[-_]/g, (match) => match == "-" ? "+" : "/"),
        B64SafeDecode = (base64:string)  => B64Decode(B64Unsafe(base64))
  */
  const B64SafeEncode = (unicode:string) => btoa(String.fromCharCode(...(new TextEncoder).encode(unicode)))
                                            .replace(/[+/=]/g, (m) => m == "+" ? "-" : m == "/" ? "_" : ""),
        B64Decode     = (base64:string)  => (new TextDecoder()).decode(Uint8Array.from(atob(base64), c => c.charCodeAt(0)));

  // Return a random key: 3 chars max, base-36 number < 36**3
  const randKey = () => Math.floor(Math.random() * 36 ** 3).toString(36);

  // Manage the page augmentation for Keynav, called only if storageSupport
  const augmentKeynav: AugmentKeynav = async (nav, [storageKey, pageKey, last, spliceArgs]) => {
    let augment;
    const browserKey = document.cookie.split(/;\s+/)  // it works even if malformed
                               .find((row) => row.startsWith(pagy + "="))
                               ?.split("=")[1] ?? randKey();
    document.cookie = pagy + "=" + browserKey;  // Smaller .min size: set the cookie without checking
    if (storageKey && !(storageKey in storage)) {
      // Sync the sessiongStorage from other tabs/windows (e.g. open page in new tab/window)
      sync.postMessage(<SyncData>{ from: tabId, key: storageKey });
      // Wait for the listener to copy the cutoffs in the current sessionStorage
      await new Promise<string|null>((resolve) => setTimeout(() => resolve(""), 100));
      if (!(storageKey in storage)) { // the storageKey didn't get copied: fallback to countless pagination
        augment = (page: string) => page + '+' + last;
      }
    }
    if (!augment) { // regular keynav pagination
      if (!storageKey) { do { storageKey = randKey() } while (storageKey in storage) } // no dup keys
      const data = storage.getItem(storageKey),
          cutoffs = <Cutoff[]>(data ? JSON.parse(data) : [undefined]);
      if (spliceArgs) {
        cutoffs.splice(...spliceArgs);
        storage.setItem(storageKey, JSON.stringify(cutoffs));
      }
      // Augment function
      augment = (page:string) => {
        const pageNum = parseInt(page);
        return B64SafeEncode(JSON.stringify(
            <AugmentedPage>[browserKey,
                            storageKey,
                            pageNum,
                            cutoffs.length,       // pages/last
                            cutoffs[pageNum - 1], // priorCutoff
                            cutoffs[pageNum]]));  // pageCutoff
      };
    }
    // Augment the page param of each href
    for (const a of <NodeListOf<HTMLAnchorElement>><unknown>nav.querySelectorAll('a[href]')) {
      const url = a.href,
            re  = new RegExp(`(?<=\\?.*)\\b${pageKey}=(\\d+)`);   // find the numeric page from pageKey
      a.href    = url.replace(re, pageKey + "=" + augment(url.match(re)![1]));  // eslint-disable-line @typescript-eslint/no-non-null-assertion
    }
    // Return the augment function for furter augmentation (i.e. url token in input_nav_js)
    return augment;
  };

  // Build the series_nav_js helper
  const buildNavJs = (nav:NavJsElement, [[before, anchor, current, gap, after],
                                        [widths, series, labels], keynavArgs]:SeriesNavJsArgs) => {
    const  parent = <HTMLElement>nav.parentElement;
    let lastWidth = -1;
    (nav.render = () => {
      const index = widths.findIndex(w => w < parent.clientWidth);
      if (widths[index] === lastWidth) { return } // no change: abort

      let html = before;
      series[index].forEach((item, i) => {
        // Avoid if blocks and chain results for shorter .min and easier reading
        html += item == "gap" ? gap :
                // @ts-expect-error the item may be a number, but 'replace' type converts it to string (shorter .min)
                (typeof item == "number" ? anchor.replace(pageRe, item) : current)
                    .replace("L<", labels?.[index][i] ?? item + "<");
      });
      html         += after;
      nav.innerHTML = "";
      nav.insertAdjacentHTML("afterbegin", html);
      lastWidth = widths[index];
      if (keynavArgs && storageSupport) { void augmentKeynav(nav, keynavArgs) }
    })();
    if (nav.classList.contains(pagy + "-rjs")) { rjsObserver.observe(parent) }
  };

  // Init the input_nav_js helpers
  const initInputNavJs = async (nav:HTMLElement, [url_token, keynavArgs]:InputNavJsArgs) => {
    const augment = keynavArgs && storageSupport
                    ? await augmentKeynav(nav, keynavArgs)
                    : (page: string) => page;
    initInput(nav, inputValue => url_token.replace(pageRe, augment(inputValue)));
  };

  // Init the limit_tag_js helper
  const initLimitTagJs = (span:HTMLSpanElement, [from, url_token]:LimitTagJsArgs) => {
    initInput(span, inputValue => {
      // @ts-expect-error the page is a number, but 'replace' type converts it to string (shorter .min)
      return url_token.replace(pageRe, Math.max(Math.ceil(from / parseInt(inputValue)), 1))
                      .replace('L ', inputValue);
    });
  };

  // Init the input element
  const initInput = (element:HTMLElement, getUrl:(v:string) => string) => {
    const input   = <HTMLInputElement>element.querySelector("input"),
          link    = <HTMLAnchorElement>element.querySelector("a"),
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
    input.addEventListener("focus", () => input.select());
    input.addEventListener("focusout", action);
    input.addEventListener("keypress", e => { if (e.key == "Enter") { action() } });
  };

  // Public interface
  return {
    version: "43.0.0",

    // Scan for elements with a "data-pagy" attribute and call their init functions with the decoded args
    init(arg?:HTMLElement) {
      const target   = arg instanceof HTMLElement ? arg : document,
            elements = target.querySelectorAll("[data-pagy]");
      for (const element of <NodeListOf<HTMLElement>>elements) {
        try {
          const [helperId, ...args] = <InitArgs>JSON.parse(B64Decode(<string>element.getAttribute("data-pagy")));
          if (helperId == "k") {
            // @ts-expect-error spread 2 arguments, not 3 as it complains about
            void augmentKeynav(element, ...<KeynavArgs><unknown>args);
          } else if (helperId == "snj") {
            buildNavJs(<NavJsElement>element, <SeriesNavJsArgs><unknown>args);
          } else if (helperId == "inj") {
            void initInputNavJs(element, <InputNavJsArgs><unknown>args);
          } else if (helperId == "ltj") {
            initLimitTagJs(element, <LimitTagJsArgs><unknown>args);
          }
          // else { console.warn("Pagy.init: %o\nUnknown helperId '%s'", element, helperId) }
        } catch (err) { console.warn("Pagy.init: %o\n%s", element, err) }
      }
    }
  };
})();
