type NavArgs      = readonly [Tags, Sequels, null|LabelSequels, string?]
type ComboArgs    = readonly [string, string?]
type SelectorArgs = readonly [number, string, string?]
interface Tags {
    readonly before: string
    readonly link:   string
    readonly active: string
    readonly gap:    string
    readonly after:  string
}
interface Sequels      { readonly [width:string]: (string|number|"gap")[] }
interface LabelSequels { readonly [width:string]: string[] }
interface NavElement extends Element { pagyRender(): void }

const Pagy = {
    version: "5.7.6",

    // Scan for "data-pagy-json" elements, parse their JSON content and call their init functions
    init(arg?:Element|never) {
        const target   = arg instanceof Element ? arg : document;
        const elements = target.querySelectorAll("[data-pagy-json]");
        for (const el of elements) {
            try {
                const [keyword, ...args] = JSON.parse(el.getAttribute("data-pagy-json") as string);
                if (keyword === "nav") {
                    Pagy.initNav(el as NavElement, args as NavArgs);
                } else if (keyword === "combo") {
                    Pagy.initCombo(el, args as ComboArgs);
                } else if (keyword === "selector") {
                    Pagy.initSelector(el, args as SelectorArgs);
                } else {
                    Pagy.initWarn(el, `Illegal PagyJSON keyword: expected "nav"|"combo"|"selector", got "${keyword}"`);
                }
            } catch (err) { Pagy.initWarn(el, err) }
        }
    },

    initWarn(el:Element, err:unknown) { console.warn("Pagy.init() skipped element: %o\n%s", el, err) },

    // Init the *_nav_js helpers
    initNav(el:NavElement, [tags, sequels, labelSequels, trimParam]:NavArgs) {
        const container = el.parentElement ?? el;
        const widths    = Object.keys(sequels).map(w => parseInt(w)).sort((a, b) => b - a);
        let lastWidth   = -1;
        const fillIn    = (link:string, page:string, label:string):string =>
                              link.replace(/__pagy_page__/g, page).replace(/__pagy_label__/g, label);
        (el.pagyRender = function() {
            const width = widths.find(w => w < container.clientWidth) || 0;
            if (width === lastWidth) { return } // no change: abort
            let html     = tags.before;
            const series = sequels[width.toString()];
            const labels = labelSequels?.[width.toString()] ?? series.map(l => l.toString());
            for (const i in series) {
                const item  = series[i];
                const label = labels[i];
                if (typeof trimParam === "string" && item === 1) {
                    html += Pagy.trim(fillIn(tags.link, item.toString(), label), trimParam);
                } else if (typeof item === "number") {
                    html += fillIn(tags.link, item.toString(), label);
                } else if (item === "gap") {
                    html += tags.gap;
                } else { // active page
                    html += fillIn(tags.active, item, label);
                }
            }
            html += tags.after;   // eslint-disable-line align-assignments/align-assignments
            el.innerHTML = "";
            el.insertAdjacentHTML("afterbegin", html);
            lastWidth = width;
        })();
        if (el.classList.contains("pagy-rjs")) { Pagy.rjsObserver.observe(container) }
    },

    // The observer instance for responsive navs
    rjsObserver: new ResizeObserver(entries => {
        entries.forEach(e => e.target.querySelectorAll<NavElement>(".pagy-rjs").forEach(el => el.pagyRender()));
    }),

    // Init the *_combo_nav_js helpers
    initCombo(el:Element, [link, trimParam]:ComboArgs) {
        Pagy.initInput(el, inputValue => [inputValue, link.replace(/__pagy_page__/, inputValue)], trimParam);
    },

    // Init the items_selector_js helper
    initSelector(el:Element, [from, link, trimParam]:SelectorArgs) {
        Pagy.initInput(el, inputValue => {
            const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString();
            const html = link.replace(/__pagy_page__/, page).replace(/__pagy_items__/, inputValue);
            return [page, html];
        }, trimParam);
    },

    // Init the input element
    initInput(el:Element, getVars:(v:string)=>[string, string], trimParam?:string) {
        const input   = el.querySelector("input") as HTMLInputElement;
        const initial = input.value;
        const action  = function() {
            if (input.value === initial) { return }  // not changed
            const [min, val, max] = [input.min, input.value, input.max].map(n => parseInt(n) || 0);
            if (val < min || val > max) {  // reset invalid/out-of-range
                input.value = initial;
                input.select();
                return;
            }
            let [page, html] = getVars(input.value);   // eslint-disable-line prefer-const
            if (typeof trimParam === "string" && page === "1") { html = Pagy.trim(html, trimParam) }
            el.insertAdjacentHTML("afterbegin", html);
            (el.querySelector("a") as HTMLAnchorElement).click();
        };
        ["change", "focus"].forEach(e => input.addEventListener(e, input.select));        // auto-select
        input.addEventListener("focusout", action);                                       // trigger action
        input.addEventListener("keypress", e => { if (e.key === "Enter") { action() } }); // trigger action
    },

    // Trim the ${page-param}=1 params in links
    trim: (link:string, param:string) => link.replace(new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`), "")
};
