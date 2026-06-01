import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.timeout = null
  }

  perform() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      const query = this.inputTarget.value
      const url = new URL(window.location.href)
      url.searchParams.set("query", query)

      // Keep existing filters
      const currentParams = new URLSearchParams(window.location.search)
      if (currentParams.has("category")) {
        url.searchParams.set("category", currentParams.get("category"))
      }
      if (currentParams.has("stock_filter")) {
        url.searchParams.set("stock_filter", currentParams.get("stock_filter"))
      }

      this.element.classList.add("loading")

      fetch(url, {
        headers: {
          "Accept": "text/html",
          "X-Requested-With": "XMLHttpRequest"
        }
      })
        .then(response => response.text())
        .then(html => {
          const parser = new DOMParser()
          const doc = parser.parseFromString(html, "text/html")
          const newList = doc.querySelector("#products-list") || doc.querySelector("turbo-frame#products-list")

          if (newList) {
            const currentList = document.querySelector("turbo-frame#products-list")
            if (currentList) {
              currentList.innerHTML = newList.innerHTML
            }
          }

          // Update URL without reload
          window.history.replaceState({}, "", url)
          this.element.classList.remove("loading")
        })
        .catch(() => {
          this.element.classList.remove("loading")
        })
    }, 300) // 300ms debounce
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
