// This file is the source that generates pagy.js, polyfilled with the `@babel/preset-env` `"useBuiltIns": "entry"`.
// You can generate a custom targeted javascript file for the browsers you need by changing that settings in package.json,
// then compile it with `npm run compile -w ts`.

// Add pagyRender to Element
interface Element {
    pagyRender():void;
}

// Add pagyRender to HTMLElement
interface HTMLElement {
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
    init(arg?:any) {
        const target:Document|HTMLElement = arg instanceof HTMLElement ? arg : document;
        const elements = target.querySelectorAll("[data-pagy-json]");
        for (const element of elements) {
            const json = element.getAttribute("data-pagy-json");
            if (json === null) {
                continue;
            }
            let args = JSON.parse(json);
            const fname:"nav"|"combo_nav"|"items_selector" = args.shift();
            if (fname === "nav") {
                Pagy.nav(element, ...<[NavTags, NavSequels, null|NavLabelSequels, string]>args);
            }
            else if (fname === "combo_nav") {
                Pagy.combo_nav(element, ...<[string, string, string]>args);
            }
            else if (fname === "items_selector") {
                Pagy.items_selector(element, ...<[number, string, string]>args);
            }
        }
    },

    // Power the *_nav_js helpers
    nav(pagyEl:Element, tags:NavTags, sequels:NavSequels, opt_label_sequels:null|NavLabelSequels, trimParam?:string) {
        let label_sequels:NavLabelSequels = {};
        // Handle null label_sequels
        if (opt_label_sequels === null) {
            for (const width in sequels) {
                label_sequels[width] = sequels[width].map((item) => item.toString());
            }
        }
        else {
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

        pagyEl.pagyRender = function (this:Element) {
            let width:number = 0;
            for (const w of widths) {
                if (this.parentElement !== null && this.parentElement.clientWidth > w) {
                    width = w;
                    break;
                }
            }
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
                html += tags.after;
                this.innerHTML = "";
                this.insertAdjacentHTML("afterbegin", html);
                lastWidth = width;
            }
        }.bind(pagyEl);
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
        const navs:HTMLCollectionOf<Element> = document.getElementsByClassName("pagy-njs");
        for (const nav of navs) {
            nav.pagyRender();
        }
    },

    // Power the *_combo_nav_js helpers
    combo_nav(pagyEl:Element, page:string, link:string, trimParam?:string) {
        const input:HTMLInputElement = pagyEl.getElementsByTagName("input")[0];
        const goToPage = function () {
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

    // Power the trim extra for js helpers
    trim(link:string, param:string):string {
        const re = new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`);
        return link.replace(re, "");
    },

    // Power the pagy_items_selector_js helper
    items_selector(pagyEl:Element, from:number, link:string, trimParam?:string) {
        const input:HTMLInputElement = pagyEl.getElementsByTagName("input")[0];
        const current = input.value;
        const goToPage = function () {
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
    addInputBehavior(input:HTMLInputElement, goToPage:Function) {
        // select the content on click: easier for direct typing
        input.addEventListener("click", function (_e) {
            this.select();
        });
        // goToPage when the input loses focus
        input.addEventListener("focusout", function (_e) {
            goToPage();
        });
        // goToPage when pressing enter while the input has focus
        input.addEventListener("keypress", function (e:KeyboardEvent) {
            if (e.key === "Enter") {
                goToPage();
            }
        }.bind(this));
    }
};
