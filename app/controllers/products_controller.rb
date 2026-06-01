class ProductsController < ApplicationController
  before_action :require_login
  before_action :set_product, only: [:show, :edit, :update, :destroy, :adjust_stock]
  before_action :require_owner!, only: [:destroy]

  def index
    @products = Product.active_products
                       .search(params[:query])
                       .by_category(params[:category])
                       .order(updated_at: :desc)

    if params[:stock_filter] == "low"
      @products = @products.low_stock
    elsif params[:stock_filter] == "out"
      @products = @products.out_of_stock
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @recent_sales = @product.sales.order(sold_at: :desc).limit(10)
  end

  def new
    @product = Product.new(category: params[:category] || "mobile")
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:notice] = "#{@product.display_name} added to stock successfully!"
      redirect_to products_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "#{@product.display_name} updated successfully!"
      redirect_to products_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.sales.any?
      flash[:alert] = "Cannot delete a product with sales history. Deactivate it instead."
    else
      @product.destroy
      flash[:notice] = "Product deleted."
    end
    redirect_to products_path
  end

  def adjust_stock
    adjustment = params[:adjustment].to_i
    new_quantity = @product.quantity + adjustment

    if new_quantity < 0
      flash[:alert] = "Stock cannot go below zero."
    else
      @product.update!(quantity: new_quantity)
      flash[:notice] = "Stock updated to #{new_quantity}."
    end

    redirect_to products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :category, :brand, :model_number, :imei, :color,
      :storage, :accessory_type, :purchase_price, :selling_price,
      :quantity, :description, :active
    )
  end
end
