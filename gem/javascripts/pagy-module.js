const Pagy = (() => {
    // The observer instance for responsive navs
    const rjsObserver = new ResizeObserver(entries => entries.forEach(e => e.target.querySelectorAll(".pagy-rjs").forEach(el => el.pagyRender())));
    // Init the *_nav_js helpers
    const initNav = (el, [tokens, sequels, labelSequels, trimParam]) => {
        const container = el.parentElement ?? el;
        const widths = Object.keys(sequels).map(w => parseInt(w)).sort((a, b) => b - a);
        let lastWidth = -1;
        const fillIn = (a, page, label) => a.replace(/__pagy_page__/g, page).replace(/__pagy_label__/g, label);
        (el.pagyRender = function () {
            const width = widths.find(w => w < container.clientWidth) || 0;
            if (width === lastWidth) {
                return;
            } // no change: abort
            let html = tokens.before; // already trimmed in html
            const series = sequels[width.toString()];
            const labels = labelSequels?.[width.toString()] ?? series.map(l => l.toString());
            for (const i in series) {
                const item = series[i];
                const label = labels[i];
                let filled;
                if (typeof item === "number") {
                    filled = fillIn(tokens.a, item.toString(), label);
                }
                else if (item === "gap") {
                    filled = tokens.gap;
                }
                else { // active page
                    filled = fillIn(tokens.current, item, label);
                }
                html += (typeof trimParam === "string" && item == 1) ? trim(filled, trimParam) : filled;
            }
            html += tokens.after; // eslint-disable-line align-assignments/align-assignments
            el.innerHTML = "";
            el.insertAdjacentHTML("afterbegin", html);
            lastWidth = width;
        })();
        if (el.classList.contains("pagy-rjs")) {
            rjsObserver.observe(container);
        }
    };
    // Init the *_combo_nav_js helpers
    const initCombo = (el, [url_token, trimParam]) => initInput(el, inputValue => [inputValue, url_token.replace(/__pagy_page__/, inputValue)], trimParam);
    // Init the items_selector_js helper
    const initSelector = (el, [from, url_token, trimParam]) => {
        initInput(el, inputValue => {
            const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString();
            const url = url_token.replace(/__pagy_page__/, page).replace(/__pagy_items__/, inputValue);
            return [page, url];
        }, trimParam);
    };
    // Init the input element
    const initInput = (el, getVars, trimParam) => {
        const input = el.querySelector("input");
        const link = el.querySelector("a");
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
            let [page, url] = getVars(input.value); // eslint-disable-line prefer-const
            if (typeof trimParam === "string" && page === "1") {
                url = trim(url, trimParam);
            }
            link.href = url;
            link.click();
        };
        ["change", "focus"].forEach(e => input.addEventListener(e, input.select)); // auto-select
        input.addEventListener("focusout", action); // trigger action
        input.addEventListener("keypress", e => { if (e.key === "Enter") {
            action();
        } }); // trigger action
    };
    // Trim the ${page-param}=1 params in links
    const trim = (a, param) => a.replace(new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`), "");
    // Public interface
    return {
        version: "8.2.2",
        // Scan for elements with a "data-pagy" attribute and call their init functions with the decoded args
        init(arg) {
            const target = arg instanceof Element ? arg : document;
            const elements = target.querySelectorAll("[data-pagy]");
            for (const el of elements) {
                try {
                    const uint8array = Uint8Array.from(atob(el.getAttribute("data-pagy")), c => c.charCodeAt(0));
                    const [keyword, ...args] = JSON.parse((new TextDecoder()).decode(uint8array)); // base64-utf8 -> JSON -> Array
                    if (keyword === "nav") {
                        initNav(el, args);
                    }
                    else if (keyword === "combo") {
                        initCombo(el, args);
                    }
                    else if (keyword === "selector") {
                        initSelector(el, args);
                    }
                    else {
                        console.warn("Skipped Pagy.init() for: %o\nUnknown keyword '%s'", el, keyword);
                    }
                }
                catch (err) {
                    console.warn("Skipped Pagy.init() for: %o\n%s", el, err);
                }
            }
        }
    };
})();
export default Pagy;
