// pagy.ts
window.Pagy = (() => {
  const storageSupport = "sessionStorage" in window && "BroadcastChannel" in window;
  let storage, sync, tabId;
  if (storageSupport) {
    storage = sessionStorage;
    sync = new BroadcastChannel("pagy");
    tabId = Date.now();
    sync.addEventListener("message", (e) => {
      if (e.data.from) {
        const cutoffs = storage.getItem(e.data.key);
        if (cutoffs) {
          sync.postMessage({ to: e.data.from, key: e.data.key, cutoffs });
        }
      } else if (e.data.to) {
        if (e.data.to == tabId) {
          storage.setItem(e.data.key, e.data.cutoffs);
        }
      }
    });
  }
  const rjsObserver = new ResizeObserver((entries) => entries.forEach((e) => {
    e.target.querySelectorAll(".pagy-rjs").forEach((el) => el.pagyRender());
  }));
  const B64Encode = (unicode) => btoa(String.fromCharCode(...new TextEncoder().encode(unicode))), B64Safe = (unsafe) => unsafe.replace(/=/g, "").replace(/[+/]/g, (match) => match == "+" ? "-" : "_"), B64SafeEncode = (unicode) => B64Safe(B64Encode(unicode)), B64Decode = (base64) => new TextDecoder().decode(Uint8Array.from(atob(base64), (c) => c.charCodeAt(0)));
  const initCutoffs = async (el, [pageSym, [storageKey, spliceArgs]]) => {
    if (!storageSupport) {
      return;
    }
    let browserId = document.cookie.split(/;\s+/).find((row) => row.startsWith("pagy="))?.split("=")[1];
    if (!browserId) {
      document.cookie = "pagy=" + (browserId = Math.floor(Math.random() * 36 ** 3).toString(36));
    }
    if (storageKey && !(storageKey in storage)) {
      sync.postMessage({ from: tabId, key: storageKey });
      await new Promise((resolve) => setTimeout(() => resolve(""), 100));
    }
    storageKey ||= "pagy-" + Date.now().toString(36);
    const data = storage.getItem(storageKey), cutoffs = data ? JSON.parse(data) : [undefined];
    if (spliceArgs) {
      cutoffs.splice(...spliceArgs);
      storage.setItem(storageKey, JSON.stringify(cutoffs));
    }
    for (const a of el.querySelectorAll("a[href]")) {
      const url = a.href, re = new RegExp(`(?<=\\?.*)\\b${pageSym}=([\\d]+)`), pageNum = parseInt(url.match(re)?.[1]), value = B64SafeEncode(JSON.stringify([
        browserId,
        storageKey,
        pageNum,
        cutoffs.length,
        cutoffs[pageNum - 1],
        cutoffs[pageNum]
      ]));
      a.href = url.replace(re, `${pageSym}=${value}`);
    }
  };
  const initNavJs = (el, [tokens, sequels, labelSequels, cutoffArgs]) => {
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
      if (cutoffArgs) {
        initCutoffs(el, cutoffArgs);
      }
    })();
    if (el.classList.contains("pagy-rjs")) {
      rjsObserver.observe(container);
    }
  };
  const initComboJs = (el, [url_token]) => initInput(el, (inputValue) => url_token.replace(/__pagy_page__/, inputValue));
  const initSelectorJs = (el, [from, url_token]) => {
    initInput(el, (inputValue) => {
      const page = Math.max(Math.ceil(from / parseInt(inputValue)), 1).toString();
      return url_token.replace(/__pagy_page__/, page).replace(/__pagy_limit__/, inputValue);
    });
  };
  const initInput = (el, getUrl) => {
    const input = el.querySelector("input"), link = el.querySelector("a"), initial = input.value, action = () => {
      if (input.value === initial) {
        return;
      }
      const [min, val, max] = [input.min, input.value, input.max].map((n) => parseInt(n) || 0);
      if (val < min || val > max) {
        input.value = initial;
        input.select();
        return;
      }
      link.href = getUrl(input.value);
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
  return {
    version: "9.3.3",
    init(arg) {
      const target = arg instanceof Element ? arg : document, elements = target.querySelectorAll("[data-pagy]");
      for (const el of elements) {
        try {
          const [keyword, ...args] = JSON.parse(B64Decode(el.getAttribute("data-pagy")));
          if (keyword == "nav") {
            initCutoffs(el, args);
          } else if (keyword == "nav_js") {
            initNavJs(el, args);
          } else if (keyword == "combo_js") {
            initComboJs(el, args);
          } else if (keyword == "selector_js") {
            initSelectorJs(el, args);
          }
        } catch (err) {
          console.warn("Pagy.init() error: %o\n%s", el, err);
        }
      }
    }
  };
})();

//# debugId=0974C14BAD5BAB2A64756E2164756E21
//# sourceMappingURL=pagy.js.map
