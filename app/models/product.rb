class Product < ApplicationRecord
  has_many :sales, dependent: :restrict_with_error

  CATEGORIES = %w[mobile accessory].freeze
  ACCESSORY_TYPES = %w[case charger earphone screen_guard cable power_bank speaker other].freeze

  validates :name, presence: true, length: { maximum: 200 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :selling_price, presence: true, numericality: { greater_than: 0 }
  validates :purchase_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :imei, uniqueness: true, allow_blank: true
  validates :accessory_type, inclusion: { in: ACCESSORY_TYPES }, allow_blank: true

  scope :mobiles, -> { where(category: "mobile") }
  scope :accessories, -> { where(category: "accessory") }
  scope :in_stock, -> { where("quantity > 0") }
  scope :out_of_stock, -> { where(quantity: 0) }
  scope :low_stock, -> { where("quantity > 0 AND quantity <= 3") }
  scope :active_products, -> { where(active: true) }

  scope :search, ->(query) {
    return all if query.blank?
    where(
      "LOWER(name) LIKE :q OR LOWER(brand) LIKE :q OR LOWER(model_number) LIKE :q OR LOWER(imei) LIKE :q OR LOWER(accessory_type) LIKE :q",
      q: "%#{query.downcase}%"
    )
  }

  scope :by_category, ->(cat) {
    return all if cat.blank? || cat == "all"
    where(category: cat)
  }

  def mobile?
    category == "mobile"
  end

  def accessory?
    category == "accessory"
  end

  def in_stock?
    quantity > 0
  end

  def low_stock?
    quantity > 0 && quantity <= 3
  end

  def out_of_stock?
    quantity == 0
  end

  def stock_status
    if out_of_stock?
      "out_of_stock"
    elsif low_stock?
      "low_stock"
    else
      "in_stock"
    end
  end

  def stock_status_label
    case stock_status
    when "in_stock" then "In Stock"
    when "low_stock" then "Low Stock"
    when "out_of_stock" then "Out of Stock"
    end
  end

  def profit_per_unit
    return nil unless purchase_price.present?
    selling_price - purchase_price
  end

  def display_name
    parts = [brand, name].compact
    parts << "(#{color})" if color.present?
    parts << "#{storage}" if storage.present?
    parts.join(" ")
  end
end
