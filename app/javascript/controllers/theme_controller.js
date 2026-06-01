import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    const saved = localStorage.getItem("theme")
    if (saved === "light") {
      document.documentElement.classList.add("light")
      this.updateIcon("light")
    } else {
      document.documentElement.classList.remove("light")
      this.updateIcon("dark")
    }
  }

  toggle() {
    const isLight = document.documentElement.classList.toggle("light")
    const theme = isLight ? "light" : "dark"
    localStorage.setItem("theme", theme)
    this.updateIcon(theme)
  }

  updateIcon(theme) {
    if (this.hasIconTarget) {
      this.iconTarget.textContent = theme === "light" ? "🌙" : "☀️"
    }
  }
}
