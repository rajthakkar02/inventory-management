class UsersController < ApplicationController
  before_action :require_login
  before_action :require_superadmin!
  before_action :set_user, only: [:edit, :update, :toggle_active]

  def index
    @users = User.order(:name)
  end

  def new
    @user = User.new(role: "staff")
  end

  def create
    @user = User.new(user_params)
    @user.role = "staff"

    if @user.save
      flash[:notice] = "Staff member #{@user.name} created successfully!"
      redirect_to users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    filtered_params = user_params
    if filtered_params[:password].blank?
      filtered_params = filtered_params.except(:password, :password_confirmation)
    end

    if @user.superadmin? || @user.admin?
      filtered_params = filtered_params.except(:role)
    end

    if @user.update(filtered_params)
      flash[:notice] = "#{@user.name} updated successfully!"
      redirect_to users_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_active
    if @user == current_user
      flash[:alert] = "You cannot deactivate your own account."
    elsif @user.superadmin?
      flash[:alert] = "Cannot deactivate the Super Admin account."
    else
      @user.update!(active: !@user.active?)
      status = @user.active? ? "activated" : "deactivated"
      flash[:notice] = "#{@user.name} has been #{status}."
    end
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
