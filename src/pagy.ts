// This file is the source that generates pagy.js, polyfilled with the `@babel/preset-env` `"useBuiltIns": "entry"`.
// You can generate a custom targeted javascript file for the browsers you need by changing that settings in package.json,
// then compile it with `npm run compile -w src`.

// Add pagyRender to Element
interface Element {
    pagyRender():void;
}

// Tags from the data-pagy-json of *nav_js helpers
interface NavTags {
    readonly before:string;
    readonly link:string;
    readonly active:string;
    readonly gap:string;
    readonly after:string;
}

// Tags from the data-pagy-json of *nav_js helpers
interface NavSequels {
    readonly [width:string]:(string|number|"gap")[];
}

// Tags from the data-pagy-json of *nav_js helpers
interface NavLabelSequels {
    [width:string]:(string|"gap")[];
}

// The Pagy object
const Pagy = {
    version: "5.6.8",

    // Scan for "data-pagy-json" elements, parse their JSON content and apply their functions
    init(arg?:HTMLElement|Document|Event) {
        const target = arg instanceof HTMLElement ? arg : document;
        const elements = target.querySelectorAll("[data-pagy-json]");
        for (const element of elements) {
            const json = element.getAttribute("data-pagy-json");
            if (json === null) {
                continue;
            }
            const args = JSON.parse(json);
            const fname = args.shift() as "nav"|"combo_nav"|"items_selector";
            if (fname === "nav") {
                Pagy.nav(element, ...args as [NavTags, NavSequels, null|NavLabelSequels, string]);
            } else if (fname === "combo_nav") {
                Pagy.combo_nav(element, ...args as [string, string, string]);
            } else if (fname === "items_selector") {
                Pagy.items_selector(element, ...args as [number, string, string]);
            }
        }
    },

    // Power the *_nav_js helpers
    nav(pagyEl:Element, tags:NavTags, sequels:NavSequels, opt_label_sequels:null|NavLabelSequels, trimParam?:string) {
        let label_sequels = {} as NavLabelSequels;
        // Handle null label_sequels
        if (opt_label_sequels === null) {
            for (const width in sequels) {
                label_sequels[width] = sequels[width].map((item) => item.toString());
            }
        } else {
            label_sequels = opt_label_sequels;
        }
        // Set and sort the widths as number[]
        const widths = Object.getOwnPropertyNames(sequels)
                             .map((w) => parseInt(w))
                             .sort((a, b) => b - a);
        let lastWidth:number;
        const fillIn = (string:string, item:string, label:string):string =>
            string.replace(/__pagy_page__/g, item)
                  .replace(/__pagy_label__/g, label);

        pagyEl.pagyRender = () => {
            // Find the width that fits in parent
            const width = widths.find((w) => pagyEl.parentElement !== null && pagyEl.parentElement.clientWidth > w) || 0;
            // Only if the width changed
            if (width !== lastWidth) {
                let html = tags.before;
                const series = sequels[width.toString()];
                const labels = label_sequels[width.toString()];
                for (const i in series) {
                    const item = series[i];
                    const label = labels[i];
                    if (typeof trimParam === "string" && item === 1) {
                        const link = fillIn(tags.link, item.toString(), label);
                        html += Pagy.trim(link, trimParam);
                    } else if (typeof item === "number") {
                        html += fillIn(tags.link, item.toString(), label);
                    } else if (item === "gap") {
                        html += tags.gap;
                    } else { // active page
                        html += fillIn(tags.active, item, label);
                    }
                }
                html += tags.after;
                pagyEl.innerHTML = "";
                pagyEl.insertAdjacentHTML("afterbegin", html);
                lastWidth = width;
            }
        };
        pagyEl.pagyRender();
        // If there is a window object then add a single "resize" event listener
        if (typeof window !== "undefined") {
            window.addEventListener("resize", Pagy.throttleRenderNavs, true);
        }
    },

    // throttleRenderNavs properties
    throttleRenderNavsTID:   0,      // private
    throttleRenderNavsDelay: 100,    // set a default delay

    // Avoid to fire the pagyRender multiple times
    throttleRenderNavs() {
        clearTimeout(Pagy.throttleRenderNavsTID);
        Pagy.throttleRenderNavsTID = window.setTimeout(Pagy.renderNavs, Pagy.throttleRenderNavsDelay);
    },

    // Render all *nav_js helpers (i.e. all the elements of class "pagy-njs")
    renderNavs() {
        const navs = document.getElementsByClassName("pagy-njs");
        Array.from(navs).forEach((nav) => nav.pagyRender());
    },

    // Power the *_combo_nav_js helpers
    combo_nav(pagyEl:Element, page:string, link:string, trimParam?:string) {
        const input = pagyEl.getElementsByTagName("input")[0];
        const goToPage = () => {
            if (page !== input.value) {
                let html = link.replace(/__pagy_page__/, input.value);
                if (typeof trimParam === "string" && input.value === "1") {
                    html = Pagy.trim(html, trimParam);
                }
                pagyEl.insertAdjacentHTML("afterbegin", html);
                pagyEl.getElementsByTagName("a")[0].click();
            }
        };
        Pagy.addInputBehavior(input, goToPage);
    },

    // Power the pagy_items_selector_js helper
    items_selector(pagyEl:Element, from:number, link:string, trimParam?:string) {
        const input = pagyEl.getElementsByTagName("input")[0];
        const current = input.value;
        const goToPage = () => {
            const items = input.value;
            if (items === "0" || items === "") {
                return;
            }
            if (current !== items) {
                const page = Math.max(Math.ceil(from / parseInt(items)), 1).toString();
                let html = link.replace(/__pagy_page__/, page)
                               .replace(/__pagy_items__/, items);
                if (typeof trimParam === "string" && page === "1") {
                    html = Pagy.trim(html, trimParam);
                }
                pagyEl.insertAdjacentHTML("afterbegin", html);
                pagyEl.getElementsByTagName("a")[0].click();
            }
        };
        Pagy.addInputBehavior(input, goToPage);
    },

    // Add behavior to input fields
    addInputBehavior(input:HTMLInputElement, goToPage:() => void) {
        // select the content on click: easier for direct typing
        input.addEventListener("click", input.select);
        // goToPage when the input loses focus
        input.addEventListener("focusout", goToPage);
        // goToPage when pressing enter while the input has focus
        input.addEventListener("keypress", (e:KeyboardEvent) => {
            if (e.key === "Enter") {
                goToPage();
            }
        });
    },

    // Power the trim extra for js helpers
    trim(link:string, param:string):string {
        const re = new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`);
        return link.replace(re, "");
    }
};
