type NavArgs        = readonly [OptionArgs?]
type NavJsArgs      = readonly [Tokens, Sequels, null | LabelSequels, OptionArgs?]
type ComboJsArgs    = readonly [string, OptionArgs?]
type SelectorJsArgs = readonly [number, string, OptionArgs?]
type JsonArgs       = ['nav', NavArgs] | ['nav_js', NavJsArgs] | ['combo_js', ComboJsArgs] | ['selector_js', SelectorJsArgs]
type Cutoff         = readonly [string | number | boolean]
type SpliceArgs     = [number, number, Cutoff]
type Update         = [string, SpliceArgs]

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


  // const initNav = (el:Element, [opts]:NavArgs) => {
  //
  // }

  // const update = ([key, spliceArgs]:Update) => {
  //
  // };
  //
  // const cutoffsFor = (page:number, param:string) => {
  //   return page.toString('base64url');
  // };

  // if (typeof opts?.cutoffs_param === "string") {
  //   cutoffsFor(item, opts.cutoffs_param)
  // }


  // Init the *_nav_js helpers
  const initNavJs = (el:NavJsElement, [tokens, sequels, labelSequels, opts]:NavJsArgs) => {
    if (Array.isArray(opts?.update)) { update(opts.update) }
    const container = el.parentElement ?? el;
    const widths    = Object.keys(sequels).map(w => parseInt(w)).sort((a, b) => b - a);
    let lastWidth   = -1;
    const fillIn    = (a:string, page:string, label:string):string =>
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
          if (typeof opts?.cutoffs_param === "string") {
            cutoffsFor(item, opts.cutoffs_param)
          }
        } else if (item === "gap") {
          filled = tokens.gap;
        } else { // active page
          filled = fillIn(tokens.current, item, label);
        }
        html += filled;
      });
      html        += tokens.after;   // already trimmed by ruby in html
      el.innerHTML = "";
      el.insertAdjacentHTML("afterbegin", html);
      lastWidth = width;
    })();
    if (el.classList.contains("pagy-rjs")) { rjsObserver.observe(container) }
  };

  const update = ([key, spliceArgs]:Update) => {

  };

  const cutoffsFor = (page:number, param:string) => {
    return page.toString('base64url');
  };

  // Init the *_combo_nav_js helpers
  const initComboJs = (el:Element, [url_token, opts]:ComboJsArgs) =>
      initInput(el, inputValue => [inputValue, url_token.replace(/__pagy_page__/, inputValue)], opts);

  // Init the limit_selector_js helper
  const initSelectorJs = (el:Element, [from, url_token, opts]:SelectorJsArgs) => {
    initInput(el, inputValue => {
      const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString();
      const url  = url_token.replace(/__pagy_page__/, page).replace(/__pagy_limit__/, inputValue);
      return [page, url];
    }, opts);
  };

  // Init the input element
  const initInput = (el:Element, getVars:(v:string) => [string, string], opts?:OptionArgs) => {
    const input   = el.querySelector("input") as HTMLInputElement;
    const link    = el.querySelector("a") as HTMLAnchorElement;
    const initial = input.value;
    const action  = function () {
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
      const target   = arg instanceof Element ? arg : document;
      const elements = target.querySelectorAll("[data-pagy]");
      for (const el of elements) {
        try {
          const uint8array      = Uint8Array.from(atob(el.getAttribute("data-pagy") as string), c => c.charCodeAt(0));
          const [kind, ...args] = JSON.parse((new TextDecoder()).decode(uint8array)) as JsonArgs; // base64-utf8 -> JSON -> Array
          if (kind === "nav") {
            initNav(el, args as unknown as NavArgs);
          } else if (kind === "nav_js") {
            initNavJs(el as NavJsElement, args as unknown as NavJsArgs);
          } else if (kind === "combo_js") {
            initComboJs(el, args as unknown as ComboJsArgs);
          } else if (kind === "selector_js") {
            initSelectorJs(el, args as unknown as SelectorJsArgs);
          } else {
            console.warn("Skipped Pagy.init() for: %o\nUnknown kind '%s'", el, kind);
          }
        } catch (err) { console.warn("Skipped Pagy.init() for: %o\n%s", el, err) }
      }
    }
  };
})();

export default Pagy;
