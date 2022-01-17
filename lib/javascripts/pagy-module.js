const Pagy = {
    version: "5.8.1",
    // Scan for elements with a "data-pagy" attribute and call their init functions with the decoded args
    init(arg) {
        const target = arg instanceof Element ? arg : document;
        const elements = target.querySelectorAll("[data-pagy]");
        for (const el of elements) {
            try {
                const uint8array = Uint8Array.from(atob(el.getAttribute("data-pagy")), c => c.charCodeAt(0));
                const [keyword, ...args] = JSON.parse(new TextDecoder().decode(uint8array)); // base64-utf8 JSON -> Array
                if (keyword === "nav") {
                    Pagy.initNav(el, args);
                }
                else if (keyword === "combo") {
                    Pagy.initCombo(el, args);
                }
                else if (keyword === "selector") {
                    Pagy.initSelector(el, args);
                }
                else {
                    console.warn("Skipped Pagy.init() for: %o\nUnknown keyword '%s'", el, keyword);
                }
            }
            catch (err) {
                console.warn("Skipped Pagy.init() for: %o\n%s", el, err);
            }
        }
    },
    // Init the *_nav_js helpers
    initNav(el, [tags, sequels, labelSequels, trimParam]) {
        const container = el.parentElement ?? el;
        const widths = Object.keys(sequels).map(w => parseInt(w)).sort((a, b) => b - a);
        let lastWidth = -1;
        const fillIn = (link, page, label) => link.replace(/__pagy_page__/g, page).replace(/__pagy_label__/g, label);
        (el.pagyRender = function () {
            const width = widths.find(w => w < container.clientWidth) || 0;
            if (width === lastWidth) {
                return;
            } // no change: abort
            let html = tags.before;
            const series = sequels[width.toString()];
            const labels = labelSequels?.[width.toString()] ?? series.map(l => l.toString());
            for (const i in series) {
                const item = series[i];
                const label = labels[i];
                if (typeof trimParam === "string" && item === 1) {
                    html += Pagy.trim(fillIn(tags.link, item.toString(), label), trimParam);
                }
                else if (typeof item === "number") {
                    html += fillIn(tags.link, item.toString(), label);
                }
                else if (item === "gap") {
                    html += tags.gap;
                }
                else { // active page
                    html += fillIn(tags.active, item, label);
                }
            }
            html += tags.after; // eslint-disable-line align-assignments/align-assignments
            el.innerHTML = "";
            el.insertAdjacentHTML("afterbegin", html);
            lastWidth = width;
        })();
        if (el.classList.contains("pagy-rjs")) {
            Pagy.rjsObserver.observe(container);
        }
    },
    // The observer instance for responsive navs
    rjsObserver: new ResizeObserver(entries => {
        entries.forEach(e => e.target.querySelectorAll(".pagy-rjs").forEach(el => el.pagyRender()));
    }),
    // Init the *_combo_nav_js helpers
    initCombo(el, [link, trimParam]) {
        Pagy.initInput(el, inputValue => [inputValue, link.replace(/__pagy_page__/, inputValue)], trimParam);
    },
    // Init the items_selector_js helper
    initSelector(el, [from, link, trimParam]) {
        Pagy.initInput(el, inputValue => {
            const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString();
            const html = link.replace(/__pagy_page__/, page).replace(/__pagy_items__/, inputValue);
            return [page, html];
        }, trimParam);
    },
    // Init the input element
    initInput(el, getVars, trimParam) {
        const input = el.querySelector("input");
        const initial = input.value;
        const action = function () {
            if (input.value === initial) {
                return;
            } // not changed
            const [min, val, max] = [input.min, input.value, input.max].map(n => parseInt(n) || 0);
            if (val < min || val > max) { // reset invalid/out-of-range
                input.value = initial;
                input.select();
                return;
            }
            let [page, html] = getVars(input.value); // eslint-disable-line prefer-const
            if (typeof trimParam === "string" && page === "1") {
                html = Pagy.trim(html, trimParam);
            }
            el.insertAdjacentHTML("afterbegin", html);
            el.querySelector("a").click();
        };
        ["change", "focus"].forEach(e => input.addEventListener(e, input.select)); // auto-select
        input.addEventListener("focusout", action); // trigger action
        input.addEventListener("keypress", e => { if (e.key === "Enter") {
            action();
        } }); // trigger action
    },
    // Trim the ${page-param}=1 params in links
    trim: (link, param) => link.replace(new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`), "")
};
export default Pagy;
