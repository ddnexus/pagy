const Pagy = (() => {
  const rjsObserver = new ResizeObserver((entries) => entries.forEach((e) => e.target.querySelectorAll(".pagy-rjs").forEach((el) => el.pagyRender())));
  const initNavJs = (el, [tokens, sequels, labelSequels, opts]) => {
    if (Array.isArray(opts?.update)) {
      update(opts.update);
    }
    const container = el.parentElement ?? el;
    const widths = Object.keys(sequels).map((w) => parseInt(w)).sort((a, b) => b - a);
    let lastWidth = -1;
    const fillIn = (a, page, label) => a.replace(/__pagy_page__/g, page).replace(/__pagy_label__/g, label);
    (el.pagyRender = function() {
      const width = widths.find((w) => w < container.clientWidth) || 0;
      if (width === lastWidth) {
        return;
      }
      let html = tokens.before;
      const series = sequels[width.toString()];
      const labels = labelSequels?.[width.toString()] ?? series.map((l) => l.toString());
      series.forEach((item, i) => {
        const label = labels[i];
        let filled;
        if (typeof item === "number") {
          filled = fillIn(tokens.a, item.toString(), label);
          if (typeof opts?.page_param === "string" && item === 1) {
            filled = trim(filled, opts.page_param);
          }
          if (typeof opts?.cutoffs_param === "string") {
            cutoffsFor(item, opts.cutoffs_param);
          }
        } else if (item === "gap") {
          filled = tokens.gap;
        } else {
          filled = fillIn(tokens.current, item, label);
        }
        html += filled;
      });
      html += tokens.after;
      el.innerHTML = "";
      el.insertAdjacentHTML("afterbegin", html);
      lastWidth = width;
    })();
    if (el.classList.contains("pagy-rjs")) {
      rjsObserver.observe(container);
    }
  };
  const initComboJs = (el, [url_token, opts]) => initInput(el, (inputValue) => [inputValue, url_token.replace(/__pagy_page__/, inputValue)], opts);
  const initSelectorJs = (el, [from, url_token, opts]) => {
    initInput(el, (inputValue) => {
      const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString();
      const url = url_token.replace(/__pagy_page__/, page).replace(/__pagy_limit__/, inputValue);
      return [page, url];
    }, opts);
  };
  const initInput = (el, getVars, opts) => {
    const input = el.querySelector("input");
    const link = el.querySelector("a");
    const initial = input.value;
    const action = function() {
      if (input.value === initial) {
        return;
      }
      const [min, val, max] = [input.min, input.value, input.max].map((n) => parseInt(n) || 0);
      if (val < min || val > max) {
        input.value = initial;
        input.select();
        return;
      }
      let [page, url] = getVars(input.value);
      if (typeof opts?.page_param === "string" && page === "1") {
        url = trim(url, opts.page_param);
      }
      link.href = url;
      link.click();
    };
    ["change", "focus"].forEach((e) => input.addEventListener(e, () => input.select()));
    input.addEventListener("focusout", action);
    input.addEventListener("keypress", (e) => {
      if (e.key === "Enter") {
        action();
      }
    });
  };
  const trim = (a, param) => a.replace(new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`), "");
  return {
    version: "9.3.3",
    init(arg) {
      const target = arg instanceof Element ? arg : document;
      const elements = target.querySelectorAll("[data-pagy]");
      for (const el of elements) {
        try {
          const uint8array = Uint8Array.from(atob(el.getAttribute("data-pagy")), (c) => c.charCodeAt(0));
          const [kind, ...args] = JSON.parse(new TextDecoder().decode(uint8array));
          if (kind === "nav_js") {
            initNavJs(el, args);
          } else if (kind === "combo_js") {
            initComboJs(el, args);
          } else if (kind === "selector_js") {
            initSelectorJs(el, args);
          } else {
            console.warn("Skipped Pagy.init() for: %o\nUnknown kind '%s'", el, kind);
          }
        } catch (err) {
          console.warn("Skipped Pagy.init() for: %o\n%s", el, err);
        }
      }
    }
  };
})();
export default Pagy;
