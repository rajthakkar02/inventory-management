class ReportsController < ApplicationController
  before_action :require_login
  before_action :require_superadmin!

  def daily
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @sales = Sale.includes(:product, :user)
                 .in_date_range(@date, @date)
                 .order(sold_at: :desc)

    @total_revenue = @sales.total_revenue
    @total_items = @sales.total_items_sold
    @total_transactions = @sales.total_transactions
    @payment_breakdown = @sales.revenue_by_payment_method
    @top_products = @sales.top_selling_products(5)

    mobile_sales = @sales.joins(:product).where(products: { category: "mobile" })
    accessory_sales = @sales.joins(:product).where(products: { category: "accessory" })
    @category_breakdown = {
      "Mobiles" => mobile_sales.sum(:total_amount),
      "Accessories" => accessory_sales.sum(:total_amount)
    }
  end

  def monthly
    @year = (params[:year] || Date.current.year).to_i
    @month = (params[:month] || Date.current.month).to_i
    @start_date = Date.new(@year, @month, 1)
    @end_date = @start_date.end_of_month

    @sales = Sale.in_date_range(@start_date, @end_date)
    @total_revenue = @sales.total_revenue
    @total_items = @sales.total_items_sold
    @total_transactions = @sales.total_transactions
    @avg_daily = @total_transactions > 0 ? (@total_revenue / @end_date.day) : 0
    @payment_breakdown = @sales.revenue_by_payment_method
    @top_products = @sales.top_selling_products(10)

    @daily_data = @sales.daily_breakdown(@start_date, @end_date)

    mobile_sales = @sales.joins(:product).where(products: { category: "mobile" })
    accessory_sales = @sales.joins(:product).where(products: { category: "accessory" })
    @category_breakdown = {
      "Mobiles" => mobile_sales.sum(:total_amount),
      "Accessories" => accessory_sales.sum(:total_amount)
    }
  end

  def financial_year
    @fy_start, @fy_end = Sale.financial_year_range
    @fy_label = Sale.financial_year_label

    if params[:fy_start_year].present?
      @fy_start = Date.new(params[:fy_start_year].to_i, 4, 1)
      @fy_end = @fy_start + 1.year - 1.day
      year_end = @fy_start.year + 1
      @fy_label = "FY #{@fy_start.year}-#{year_end.to_s[-2..]}"
    end

    @sales = Sale.in_date_range(@fy_start, @fy_end)
    @total_revenue = @sales.total_revenue
    @total_items = @sales.total_items_sold
    @total_transactions = @sales.total_transactions
    @payment_breakdown = @sales.revenue_by_payment_method
    @top_products = @sales.top_selling_products(10)
    @monthly_data = @sales.monthly_breakdown(@fy_start, @fy_end)

    mobile_sales = @sales.joins(:product).where(products: { category: "mobile" })
    accessory_sales = @sales.joins(:product).where(products: { category: "accessory" })
    @category_breakdown = {
      "Mobiles" => mobile_sales.sum(:total_amount),
      "Accessories" => accessory_sales.sum(:total_amount)
    }

    @total_cost = @sales.joins(:product).sum("products.purchase_price * sales.quantity")
    @estimated_profit = @total_revenue - @total_cost if @total_cost > 0
  end

  def export_csv
    @fy_start, @fy_end = Sale.financial_year_range
    @sales = Sale.includes(:product, :user).in_date_range(@fy_start, @fy_end).order(sold_at: :asc)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Date", "Product", "Brand", "Category", "Quantity", "Unit Price", "Discount", "Total", "Payment", "Salesman", "Sold By"]
      @sales.each do |sale|
        csv << [
          sale.sold_at.strftime("%d-%m-%Y %I:%M %p"),
          sale.product.name,
          sale.product.brand,
          sale.product.category.capitalize,
          sale.quantity,
          sale.unit_price,
          sale.discount,
          sale.total_amount,
          sale.payment_method.upcase,
          sale.salesman_name || sale.user.name,
          sale.user.name
        ]
      end
    end

    send_data csv_data, filename: "sales_report_#{@fy_start.year}_#{@fy_end.year}.csv", type: "text/csv"
  end
end
