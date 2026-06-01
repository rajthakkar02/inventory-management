class SalesController < ApplicationController
  before_action :require_login

  def index
    @sales = Sale.includes(:product, :user).order(sold_at: :desc)

    if params[:date_filter] == "today"
      @sales = @sales.today
    elsif params[:date_filter] == "this_week"
      @sales = @sales.this_week
    elsif params[:date_filter] == "this_month"
      @sales = @sales.this_month
    elsif params[:start_date].present? && params[:end_date].present?
      @sales = @sales.in_date_range(
        Date.parse(params[:start_date]),
        Date.parse(params[:end_date])
      )
    end

    @sales = @sales.by_payment_method(params[:payment_method])

    @total_revenue = @sales.total_revenue
    @total_items = @sales.total_items_sold
    @total_transactions = @sales.total_transactions
  end

  def new
    @sale = Sale.new
    @products = Product.active_products.in_stock.order(:name)
  end

  def create
    @sale = Sale.new(sale_params)
    @sale.user = current_user
    @sale.salesman_name = current_user.name if @sale.salesman_name.blank?

    if @sale.save
      flash[:notice] = "Sale recorded! #{@sale.product.display_name} × #{@sale.quantity} = ₹#{@sale.total_amount}"
      redirect_to sales_path
    else
      @products = Product.active_products.in_stock.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def product_info
    product = Product.find_by(id: params[:product_id])
    if product
      render json: {
        selling_price: product.selling_price,
        quantity: product.quantity,
        name: product.display_name,
        category: product.category,
        brand: product.brand
      }
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  private

  def sale_params
    params.require(:sale).permit(
      :product_id, :quantity, :unit_price, :discount,
      :salesman_name, :payment_method, :notes
    )
  end
end
