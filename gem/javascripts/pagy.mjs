const Pagy = (() => {
  const sS = sessionStorage, sync = new BroadcastChannel("pagy"), tabId = Date.now();
  sync.addEventListener("message", (e) => {
    if (e.data.from) {
      const cutoffs = sS.getItem(e.data.key);
      if (cutoffs) {
        sync.postMessage({ to: e.data.from, key: e.data.key, cutoffs });
      }
    } else if (e.data.to) {
      if (e.data.to == tabId) {
        sS.setItem(e.data.key, e.data.cutoffs);
      }
    }
  });
  const rjsObserver = new ResizeObserver((entries) => entries.forEach((e) => {
    e.target.querySelectorAll(".pagy-rjs").forEach((el) => el.pagyRender());
    e.target.querySelectorAll(".pagy-keyset").forEach((el) => el.completeUrls());
  }));
  const b64 = {
    encode: (unicode) => btoa(String.fromCharCode(...new TextEncoder().encode(unicode))),
    toSafe: (unsafe) => unsafe.replace(/=/g, "").replace(/[+/]/g, (match) => match == "+" ? "-" : "_"),
    safeEncode: (unicode) => b64.toSafe(b64.encode(unicode)),
    decode: (base64) => new TextDecoder().decode(Uint8Array.from(atob(base64), (c) => c.charCodeAt(0)))
  };
  const initNav = (el, [opts]) => {
    initCutoff(el, opts);
  };
  const initCutoff = async (el, opts) => {
    if (!opts || !Array.isArray(opts.update) || !opts.cutoffs_param || !opts.page_param) {
      return;
    }
    const pagyId = document.cookie.split(/;\s+/).find((row) => row.startsWith("pagy="))?.split("=")[1] || Math.floor(Math.random() * 36 ** 3).toString(36);
    document.cookie = "pagy=" + pagyId;
    let [key, ...spliceArgs] = opts.update;
    if (key && !(key in sS)) {
      sync.postMessage({ from: tabId, key });
      await new Promise((resolve) => setTimeout(() => resolve(""), 100));
    }
    key ||= "pagy-" + Date.now().toString(36);
    const cs = sS.getItem(key), cutoffs = cs ? JSON.parse(cs) : [null];
    if (spliceArgs) {
      cutoffs.splice(...spliceArgs);
      sS.setItem(key, JSON.stringify(cutoffs));
    }
    (el.completeUrls = () => {
      for (const a of el.querySelectorAll("a[href]")) {
        const url = a.href, re = new RegExp(`(?<=\\?.*)\\b${opts.page_param}=([\\d]+)`), page = parseInt(url.match(re)?.[1]), value = b64.safeEncode(JSON.stringify([
          pagyId,
          key,
          cutoffs.length,
          cutoffs[page - 1],
          cutoffs[page]
        ]));
        a.href = url + `&${opts.cutoffs_param}=${value}`;
      }
    })();
  };
  const initNavJs = (el, [tokens, sequels, labelSequels, opts]) => {
    const container = el.parentElement ?? el, widths = Object.keys(sequels).map((w) => parseInt(w)).sort((a, b) => b - a);
    let lastWidth = -1;
    const fillIn = (a, page, label) => a.replace(/__pagy_page__/g, page).replace(/__pagy_label__/g, label);
    (el.pagyRender = () => {
      const width = widths.find((w) => w < container.clientWidth) || 0;
      if (width === lastWidth) {
        return;
      }
      let html = tokens.before;
      const series = sequels[width.toString()], labels = labelSequels?.[width.toString()] ?? series.map((l) => l.toString());
      series.forEach((item, i) => {
        const label = labels[i];
        let filled;
        if (typeof item == "number") {
          filled = fillIn(tokens.a, item.toString(), label);
          if (typeof opts?.page_param == "string" && item == 1) {
            filled = trim(filled, opts.page_param);
          }
        } else if (item == "gap") {
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
      const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString(), url = url_token.replace(/__pagy_page__/, page).replace(/__pagy_limit__/, inputValue);
      return [page, url];
    }, opts);
  };
  const initInput = (el, getVars, opts) => {
    const input = el.querySelector("input"), link = el.querySelector("a"), initial = input.value;
    const action = () => {
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
      if (typeof opts?.page_param == "string" && page === "1") {
        url = trim(url, opts.page_param);
      }
      link.href = url;
      link.click();
    };
    ["change", "focus"].forEach((e) => input.addEventListener(e, () => input.select()));
    input.addEventListener("focusout", action);
    input.addEventListener("keypress", (e) => {
      if (e.key == "Enter") {
        action();
      }
    });
  };
  const trim = (a, param) => a.replace(new RegExp(`[?&]${param}=1\\b(?!&)|\\b${param}=1&`), "");
  return {
    version: "9.3.3",
    init(arg) {
      const target = arg instanceof Element ? arg : document, elements = target.querySelectorAll("[data-pagy]");
      for (const el of elements) {
        try {
          const [keyword, ...args] = JSON.parse(b64.decode(el.getAttribute("data-pagy")));
          if (keyword == "nav") {
            initNav(el, args);
          } else if (keyword == "nav_js") {
            initNavJs(el, args);
          } else if (keyword == "combo_js") {
            initComboJs(el, args);
          } else if (keyword == "selector_js") {
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
