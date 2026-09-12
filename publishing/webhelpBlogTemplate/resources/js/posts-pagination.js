"use strict";

(function () {
  const POSTS_PER_PAGE = 9;

  const section = document.querySelector(".stripe-all-posts");
  if (!section) {
    return;
  }

  const grid = section.querySelector(".all-posts-grid");
  const heading = section.querySelector(".all-posts-heading");
  const nav = section.querySelector(".posts-pagination");
  const pills = document.querySelectorAll(".topic-pill");
  const entries = grid ? Array.from(grid.querySelectorAll(".entry")) : [];

  if (!grid || !nav || entries.length === 0) {
    return;
  }

  let currentTopic = "all";
  let currentPage = 1;
  let persistHash = false;
  let skipScroll = true;

  function parseHash() {
    const hash = window.location.hash.replace(/^#/, "");
    if (!hash || hash === "all-posts" || hash === "browse-by-topics") {
      return { topic: "all", page: 1 };
    }
    const params = new URLSearchParams(hash);
    const topic = params.get("topic") || "all";
    const page = parseInt(params.get("page") || "1", 10);
    return {
      topic: topic,
      page: Number.isFinite(page) && page > 0 ? page : 1
    };
  }

  function isPostsHash(hash) {
    const value = (hash || "").replace(/^#/, "");
    if (!value || value === "all-posts" || value === "browse-by-topics") {
      return true;
    }
    const params = new URLSearchParams(value);
    return params.has("page") || params.has("topic");
  }

  function hashFor(topic, page) {
    const params = new URLSearchParams();
    if (topic !== "all") {
      params.set("topic", topic);
    }
    params.set("page", String(page));
    return "#" + params.toString();
  }

  function writeHash(topic, page) {
    const url = window.location.pathname + window.location.search + hashFor(topic, page);
    const current = window.location.pathname + window.location.search + window.location.hash;
    if (current !== url) {
      history.replaceState(null, "", url);
    }
  }

  function scrollToPosts() {
    const target = document.getElementById("browse-by-topics") || section;
    target.scrollIntoView({ behavior: "smooth", block: "start" });
  }

  function filteredEntries() {
    if (currentTopic === "all") {
      return entries;
    }
    return entries.filter(function (entry) {
      return entry.getAttribute("data-topic") === currentTopic;
    });
  }

  function pageNumbers(current, total) {
    if (total <= 5) {
      return Array.from({ length: total }, function (_, i) {
        return i + 1;
      });
    }

    if (current <= 3) {
      return [1, 2, 3, "…", total];
    }
    if (current >= total - 2) {
      return [1, "…", total - 2, total - 1, total];
    }
    return [1, "…", current - 1, current, current + 1, "…", total];
  }

  function createPageLink(label, page, options) {
    const opts = options || {};
    const el = document.createElement(opts.disabled ? "span" : "a");
    el.className = opts.className;
    el.textContent = label;
    if (opts.disabled) {
      el.setAttribute("aria-disabled", "true");
      return el;
    }
    el.href = hashFor(currentTopic, page);
    if (opts.current) {
      el.setAttribute("aria-current", "page");
    }
    return el;
  }

  function renderPagination(totalPages) {
    nav.replaceChildren();
    nav.hidden = totalPages <= 1;
    if (totalPages <= 1) {
      return;
    }

    nav.appendChild(
      createPageLink("‹ Previous", currentPage - 1, {
        className: "posts-pagination-nav" + (currentPage === 1 ? " is-disabled" : ""),
        disabled: currentPage === 1
      })
    );

    pageNumbers(currentPage, totalPages).forEach(function (item) {
      if (item === "…") {
        const dots = document.createElement("span");
        dots.className = "posts-pagination-ellipsis";
        dots.textContent = "…";
        dots.setAttribute("aria-hidden", "true");
        nav.appendChild(dots);
        return;
      }
      nav.appendChild(
        createPageLink(String(item), item, {
          className: "posts-pagination-page" + (item === currentPage ? " is-active" : ""),
          current: item === currentPage
        })
      );
    });

    nav.appendChild(
      createPageLink("Next ›", currentPage + 1, {
        className: "posts-pagination-nav" + (currentPage === totalPages ? " is-disabled" : ""),
        disabled: currentPage === totalPages
      })
    );
  }

  function render() {
    const visible = filteredEntries();
    const totalPages = Math.max(1, Math.ceil(visible.length / POSTS_PER_PAGE));
    if (currentPage > totalPages) {
      currentPage = totalPages;
    }

    const start = (currentPage - 1) * POSTS_PER_PAGE;
    const end = start + POSTS_PER_PAGE;

    entries.forEach(function (entry) {
      entry.classList.add("is-hidden");
    });
    visible.slice(start, end).forEach(function (entry) {
      entry.classList.remove("is-hidden");
    });

    const activePill = document.querySelector('.topic-pill[data-topic="' + currentTopic + '"]');
    if (heading) {
      heading.textContent = currentTopic === "all"
        ? "All Posts"
        : (activePill ? activePill.textContent.trim() : "All Posts");
    }

    pills.forEach(function (pill) {
      const isActive = pill.getAttribute("data-topic") === currentTopic;
      pill.classList.toggle("is-active", isActive);
      pill.setAttribute("aria-selected", isActive ? "true" : "false");
    });

    renderPagination(totalPages);
    section.classList.remove("posts-pending");
    if (persistHash) {
      writeHash(currentTopic, currentPage);
    }
  }

  function applyState(topic, page, scroll) {
    currentTopic = topic || "all";
    currentPage = page;
    render();
    if (scroll) {
      scrollToPosts();
    }
  }

  pills.forEach(function (pill) {
    pill.addEventListener("click", function () {
      const topic = pill.getAttribute("data-topic") || "all";
      const next = hashFor(topic, 1);
      if (window.location.hash === next) {
        applyState(topic, 1, true);
        return;
      }
      window.location.hash = next;
    });
  });

  window.addEventListener("hashchange", function () {
    if (!isPostsHash(window.location.hash)) {
      return;
    }
    const state = parseHash();
    applyState(state.topic, state.page, !skipScroll);
  });

  const initial = parseHash();
  currentTopic = initial.topic;
  currentPage = initial.page;
  render();
  persistHash = true;
  skipScroll = false;
})();
