import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileFields", "accessoryFields", "categoryRadio"]

  selectCategory(event) {
    const category = event.params.category

    // Update radio buttons
    this.categoryRadioTargets.forEach(radio => {
      radio.checked = radio.value === category
    })

    // Update tab styles
    event.currentTarget.parentElement.querySelectorAll('.filter-tab').forEach(tab => {
      tab.classList.remove('active')
    })
    event.currentTarget.classList.add('active')

    // Toggle field visibility
    if (category === "mobile") {
      this.mobileFieldsTarget.classList.remove("hidden")
      this.accessoryFieldsTarget.classList.add("hidden")
    } else {
      this.mobileFieldsTarget.classList.add("hidden")
      this.accessoryFieldsTarget.classList.remove("hidden")
    }
  }
}
