import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["productSelect", "productInfo", "productName", "productPrice",
                     "productStock", "quantity", "unitPrice", "discount", "totalDisplay"]

  productSelected() {
    const select = this.productSelectTarget
    const selectedOption = select.options[select.selectedIndex]

    if (selectedOption && selectedOption.value) {
      const price = selectedOption.dataset.price
      const stock = selectedOption.dataset.stock
      const name = selectedOption.dataset.name

      // Show product info card
      this.productInfoTarget.classList.add("visible")
      this.productNameTarget.textContent = name
      this.productPriceTarget.textContent = parseFloat(price).toLocaleString('en-IN')
      this.productStockTarget.textContent = stock

      // Set unit price
      this.unitPriceTarget.value = price

      // Set max quantity
      this.quantityTarget.max = stock
      this.quantityTarget.value = 1

      // Reset discount
      this.discountTarget.value = 0

      this.calculate()
    } else {
      this.productInfoTarget.classList.remove("visible")
      this.unitPriceTarget.value = ""
      this.totalDisplayTarget.textContent = "0"
    }
  }

  calculate() {
    const quantity = parseInt(this.quantityTarget.value) || 0
    const unitPrice = parseFloat(this.unitPriceTarget.value) || 0
    const discount = parseFloat(this.discountTarget.value) || 0

    const total = Math.max(0, (quantity * unitPrice) - discount)
    this.totalDisplayTarget.textContent = total.toLocaleString('en-IN')

    // Validate quantity against stock
    const select = this.productSelectTarget
    const selectedOption = select.options[select.selectedIndex]
    if (selectedOption && selectedOption.value) {
      const maxStock = parseInt(selectedOption.dataset.stock) || 0
      if (quantity > maxStock) {
        this.quantityTarget.setCustomValidity(`Only ${maxStock} available in stock`)
        this.quantityTarget.reportValidity()
      } else {
        this.quantityTarget.setCustomValidity("")
      }
    }
  }
}
