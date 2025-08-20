const Pagy = (() => {
  const storageSupport = "sessionStorage" in window && "BroadcastChannel" in window, pageRe = "P ";
  let pagy = "pagy", storage, sync, tabId;
  if (storageSupport) {
    storage = sessionStorage;
    sync = new BroadcastChannel(pagy);
    tabId = Date.now();
    sync.addEventListener("message", (e) => {
      if (e.data.from) {
        const cutoffs = storage.getItem(e.data.key);
        if (cutoffs) {
          sync.postMessage({ to: e.data.from, key: e.data.key, str: cutoffs });
        }
      } else if (e.data.to) {
        if (e.data.to == tabId) {
          storage.setItem(e.data.key, e.data.str);
        }
      }
    });
  }
  const rjsObserver = new ResizeObserver((entries) => entries.forEach((e) => {
    e.target.querySelectorAll(".pagy-rjs").forEach((el) => el.render());
  }));
  const B64SafeEncode = (unicode) => btoa(String.fromCharCode(...new TextEncoder().encode(unicode))).replace(/[+/=]/g, (m) => m == "+" ? "-" : m == "/" ? "_" : ""), B64Decode = (base64) => new TextDecoder().decode(Uint8Array.from(atob(base64), (c) => c.charCodeAt(0)));
  const randKey = () => Math.floor(Math.random() * 36 ** 3).toString(36);
  const augmentKeynav = async (nav, [storageKey, pageKey, last, spliceArgs]) => {
    let augment;
    const browserKey = document.cookie.split(/;\s+/).find((row) => row.startsWith(pagy + "="))?.split("=")[1] ?? randKey();
    document.cookie = pagy + "=" + browserKey;
    if (storageKey && !(storageKey in storage)) {
      sync.postMessage({ from: tabId, key: storageKey });
      await new Promise((resolve) => setTimeout(() => resolve(""), 100));
      if (!(storageKey in storage)) {
        augment = (page) => page + "+" + last;
      }
    }
    if (!augment) {
      if (!storageKey) {
        do {
          storageKey = randKey();
        } while (storageKey in storage);
      }
      const data = storage.getItem(storageKey), cutoffs = data ? JSON.parse(data) : [undefined];
      if (spliceArgs) {
        cutoffs.splice(...spliceArgs);
        storage.setItem(storageKey, JSON.stringify(cutoffs));
      }
      augment = (page) => {
        const pageNum = parseInt(page);
        return B64SafeEncode(JSON.stringify([
          browserKey,
          storageKey,
          pageNum,
          cutoffs.length,
          cutoffs[pageNum - 1],
          cutoffs[pageNum]
        ]));
      };
    }
    for (const a of nav.querySelectorAll("a[href]")) {
      const url = a.href, re = new RegExp(`(?<=\\?.*)\\b${pageKey}=(\\d+)`);
      a.href = url.replace(re, pageKey + "=" + augment(url.match(re)[1]));
    }
    return augment;
  };
  const buildNavJs = (nav, [
    [before, anchor, current, gap, after],
    [widths, series, labels],
    keynavArgs
  ]) => {
    const parent = nav.parentElement;
    let lastWidth = -1;
    (nav.render = () => {
      const index = widths.findIndex((w) => w < parent.clientWidth);
      if (widths[index] === lastWidth) {
        return;
      }
      let html = before;
      series[index].forEach((item, i) => {
        html += item == "gap" ? gap : (typeof item == "number" ? anchor.replace(pageRe, item) : current).replace("L<", labels?.[index][i] ?? item + "<");
      });
      html += after;
      nav.innerHTML = "";
      nav.insertAdjacentHTML("afterbegin", html);
      lastWidth = widths[index];
      if (keynavArgs && storageSupport) {
        augmentKeynav(nav, keynavArgs);
      }
    })();
    if (nav.classList.contains(pagy + "-rjs")) {
      rjsObserver.observe(parent);
    }
  };
  const initInputNavJs = async (nav, [url_token, keynavArgs]) => {
    const augment = keynavArgs && storageSupport ? await augmentKeynav(nav, keynavArgs) : (page) => page;
    initInput(nav, (inputValue) => url_token.replace(pageRe, augment(inputValue)));
  };
  const initLimitTagJs = (span, [from, url_token]) => {
    initInput(span, (inputValue) => {
      return url_token.replace(pageRe, Math.max(Math.ceil(from / parseInt(inputValue)), 1)).replace("L ", inputValue);
    });
  };
  const initInput = (element, getUrl) => {
    const input = element.querySelector("input"), link = element.querySelector("a"), initial = input.value, action = () => {
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
    input.addEventListener("focus", () => input.select());
    input.addEventListener("focusout", action);
    input.addEventListener("keypress", (e) => {
      if (e.key == "Enter") {
        action();
      }
    });
  };
  return {
    version: "43.0.0.rc4",
    init(arg) {
      const target = arg instanceof HTMLElement ? arg : document, elements = target.querySelectorAll("[data-pagy]");
      for (const element of elements) {
        try {
          const [helperId, ...args] = JSON.parse(B64Decode(element.getAttribute("data-pagy")));
          if (helperId == "k") {
            augmentKeynav(element, ...args);
          } else if (helperId == "snj") {
            buildNavJs(element, args);
          } else if (helperId == "inj") {
            initInputNavJs(element, args);
          } else if (helperId == "ltj") {
            initLimitTagJs(element, args);
          }
        } catch (err) {
          console.warn("Pagy.init: %o\n%s", element, err);
        }
      }
    }
  };
})();
export default Pagy;
