import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    // Auto-dismiss after 5 seconds
    this.messageTargets.forEach(message => {
      setTimeout(() => {
        this.fadeOut(message)
      }, 5000)
    })
  }

  dismiss(event) {
    const message = event.currentTarget.closest('.flash-message')
    if (message) {
      this.fadeOut(message)
    }
  }

  fadeOut(element) {
    element.style.transition = 'opacity 0.3s ease, transform 0.3s ease'
    element.style.opacity = '0'
    element.style.transform = 'translateX(20px)'
    setTimeout(() => {
      element.remove()
      // Remove container if empty
      const container = document.querySelector('.flash-container')
      if (container && container.children.length === 0) {
        container.remove()
      }
    }, 300)
  }
}
