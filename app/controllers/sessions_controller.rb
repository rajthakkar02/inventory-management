class SessionsController < ApplicationController
  layout "login"

  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:notice] = "Welcome back, #{user.name}!"
        redirect_to root_path
      else
        flash.now[:alert] = "Your account has been deactivated. Contact the owner."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    flash[:notice] = "You have been logged out."
    redirect_to login_path
  end
end
