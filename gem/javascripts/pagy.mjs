const Pagy = (() => {
  const rjsObserver = new ResizeObserver((entries) => entries.forEach((e) => e.target.querySelectorAll(".pagy-rjs").forEach((el) => el.pagyRender())));
  const b64 = {
    encode: (unicode) => btoa(String.fromCharCode(...new TextEncoder().encode(unicode))),
    toSafe: (unsafe) => unsafe.replace(/=/g, "").replace(/[+/]/g, (match) => match == "+" ? "-" : "_"),
    safeEncode: (unicode) => b64.toSafe(b64.encode(unicode)),
    decode: (base64) => new TextDecoder().decode(Uint8Array.from(atob(base64), (c) => c.charCodeAt(0)))
  };
  const initNav = (el, [opts]) => {
    initKeysetForUI(el, opts);
  };
  const initKeysetForUI_ = (el, opts) => {
    if (opts === undefined || !Array.isArray(opts.update)) {
      return;
    }
    if (typeof opts.cutoffs_param !== "string" || typeof opts.page_param !== "string") {
      console.warn("Failed Pagy.initKeysetForUI():%o\n bad opts \n%o", el, opts);
      return;
    }
    const [k, spliceArgs] = opts.update;
    let key = k;
    if (key === null) {
      let maxKey = localStorage.getItem("maxKey");
      if (maxKey === null) {
        maxKey = "0";
      }
      const n = parseInt(maxKey) + 1;
      localStorage.setItem("maxKey", n.toString());
      key = n.toString(36);
    }
    const c = localStorage.getItem(key);
    const cutoffs = c === null ? [null] : JSON.parse(c);
    if (spliceArgs !== undefined) {
      cutoffs.splice(...spliceArgs);
      localStorage.setItem(key, JSON.stringify(cutoffs));
    }
    const cutoff_name = opts.cutoffs_param;
    const page_name = opts.page_param;
    el.addEventListener("click", (e) => {
      const a = e.target;
      if (a && a.nodeName == "A" && a.href !== undefined) {
        const url = a.href;
        const re = new RegExp(`(?<=\\?.*)${page_name}=([\\d]+)`);
        const p = url.match(re)?.[1];
        if (typeof p !== "string") {
          return;
        }
        const page = parseInt(p);
        const value = b64.safeEncode(JSON.stringify([key, cutoffs.length, cutoffs[page - 1], cutoffs[page]]));
        a.href = url + (url.match(/\?/) === null ? "?" : "&") + `${cutoff_name}=${value}`;
      }
    });
  };
  const initKeysetForUI = (el, opts) => {
    if (opts === undefined || !Array.isArray(opts.update)) {
      return;
    }
    if (typeof opts.cutoffs_param !== "string" || typeof opts.page_param !== "string") {
      console.warn("Failed Pagy.initKeysetForUI():%o\n bad opts \n%o", el, opts);
      return;
    }
    const [k, spliceArgs] = opts.update;
    let key = k;
    if (key === null) {
      let maxKey = localStorage.getItem("maxKey");
      if (maxKey === null) {
        maxKey = "0";
      }
      const n = parseInt(maxKey) + 1;
      localStorage.setItem("maxKey", n.toString());
      key = n.toString(36);
    }
    const c = localStorage.getItem(key);
    const cutoffs = c === null ? [null] : JSON.parse(c);
    if (spliceArgs !== undefined) {
      cutoffs.splice(...spliceArgs);
      localStorage.setItem(key, JSON.stringify(cutoffs));
    }
    const cutoff_name = opts.cutoffs_param;
    const page_name = opts.page_param;
    for (const a of el.querySelectorAll("a[href]")) {
      const url = a.href;
      const re = new RegExp(`(?<=\\?.*)${page_name}=([\\d]+)`);
      const p = url.match(re)?.[1];
      if (typeof p !== "string") {
        return;
      }
      const page = parseInt(p);
      const value = b64.safeEncode(JSON.stringify([key, cutoffs.length, cutoffs[page - 1], cutoffs[page]]));
      a.href = url + (url.match(/\?/) === null ? "?" : "&") + `${cutoff_name}=${value}`;
    }
  };
  const initNavJs = (el, [tokens, sequels, labelSequels, opts]) => {
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
          const [keyword, ...args] = JSON.parse(b64.decode(el.getAttribute("data-pagy")));
          if (keyword === "nav") {
            initNav(el, args);
          } else if (keyword === "nav_js") {
            initNavJs(el, args);
          } else if (keyword === "combo_js") {
            initComboJs(el, args);
          } else if (keyword === "selector_js") {
            initSelectorJs(el, args);
          }
        } catch (err) {
          console.warn("Failed Pagy.init(): %o\n%s", el, err);
        }
      }
    }
  };
})();
export default Pagy;
