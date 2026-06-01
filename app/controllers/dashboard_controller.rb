class DashboardController < ApplicationController
  before_action :require_login

  def index
    @today_sales = Sale.today
    @today_revenue = @today_sales.total_revenue
    @today_items = @today_sales.total_items_sold
    @today_transactions = @today_sales.total_transactions

    @total_products = Product.active_products.count
    @total_in_stock = Product.active_products.in_stock.count
    @low_stock_products = Product.active_products.low_stock.limit(10)
    @out_of_stock_products = Product.active_products.out_of_stock.limit(10)

    @recent_sales = Sale.includes(:product, :user).order(sold_at: :desc).limit(5)

    # Payment method breakdown for today
    @payment_breakdown = @today_sales.revenue_by_payment_method

    # This month stats
    @month_sales = Sale.this_month
    @month_revenue = @month_sales.total_revenue
  end
end
