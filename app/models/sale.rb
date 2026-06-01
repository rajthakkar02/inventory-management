class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :user

  PAYMENT_METHODS = %w[cash upi card].freeze

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_method, presence: true, inclusion: { in: PAYMENT_METHODS }
  validates :sold_at, presence: true
  validates :discount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :sufficient_stock, on: :create

  before_validation :set_sold_at, on: :create
  before_validation :calculate_total
  after_create :reduce_stock!

  # Time-based scopes
  scope :today, -> { where(sold_at: Date.current.beginning_of_day..Date.current.end_of_day) }
  scope :yesterday, -> { where(sold_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }
  scope :this_week, -> { where(sold_at: Date.current.beginning_of_week..Date.current.end_of_week) }
  scope :this_month, -> { where(sold_at: Date.current.beginning_of_month..Date.current.end_of_month) }

  # Indian Financial Year: April 1 – March 31
  scope :this_financial_year, -> {
    today = Date.current
    fy_start = if today.month >= 4
                 Date.new(today.year, 4, 1)
               else
                 Date.new(today.year - 1, 4, 1)
               end
    fy_end = fy_start + 1.year - 1.day
    where(sold_at: fy_start.beginning_of_day..fy_end.end_of_day)
  }

  scope :in_date_range, ->(start_date, end_date) {
    where(sold_at: start_date.beginning_of_day..end_date.end_of_day)
  }

  scope :by_payment_method, ->(method) {
    return all if method.blank? || method == "all"
    where(payment_method: method)
  }

  # Aggregation helpers
  def self.total_revenue
    sum(:total_amount)
  end

  def self.total_items_sold
    sum(:quantity)
  end

  def self.total_transactions
    count
  end

  def self.revenue_by_payment_method
    group(:payment_method).sum(:total_amount)
  end

  def self.top_selling_products(limit = 10)
    joins(:product)
      .group("products.id", "products.name", "products.brand")
      .select("products.id, products.name, products.brand, SUM(sales.quantity) as total_qty, SUM(sales.total_amount) as total_revenue")
      .order("total_qty DESC")
      .limit(limit)
  end

  def self.daily_breakdown(start_date, end_date)
    in_date_range(start_date, end_date)
      .group("DATE(sold_at)")
      .select("DATE(sold_at) as sale_date, SUM(total_amount) as day_revenue, SUM(quantity) as day_items, COUNT(*) as day_transactions")
      .order("sale_date ASC")
  end

  def self.monthly_breakdown(fy_start, fy_end)
    in_date_range(fy_start, fy_end)
      .group("strftime('%Y-%m', sold_at)")
      .select("strftime('%Y-%m', sold_at) as sale_month, SUM(total_amount) as month_revenue, SUM(quantity) as month_items, COUNT(*) as month_transactions")
      .order("sale_month ASC")
  end

  # Financial year helper
  def self.financial_year_label(date = Date.current)
    if date.month >= 4
      "FY #{date.year}-#{(date.year + 1).to_s[-2..]}"
    else
      "FY #{date.year - 1}-#{date.year.to_s[-2..]}"
    end
  end

  def self.financial_year_range(date = Date.current)
    fy_start = date.month >= 4 ? Date.new(date.year, 4, 1) : Date.new(date.year - 1, 4, 1)
    fy_end = fy_start + 1.year - 1.day
    [fy_start, fy_end]
  end

  private

  def set_sold_at
    self.sold_at ||= Time.current
  end

  def calculate_total
    return unless unit_price.present? && quantity.present?
    self.total_amount = (unit_price * quantity) - (discount || 0)
  end

  def sufficient_stock
    return unless product.present?
    if product.quantity < (quantity || 0)
      errors.add(:quantity, "exceeds available stock (#{product.quantity} available)")
    end
  end

  def reduce_stock!
    product.decrement!(:quantity, quantity)
  end
end
