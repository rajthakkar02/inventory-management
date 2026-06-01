Rails.application.routes.draw do
  # Authentication
  get    "login",  to: "sessions#new",     as: :login
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Dashboard
  root "dashboard#index"

  # Products / Stock
  resources :products do
    member do
      patch :adjust_stock
    end
  end

  # Sales
  resources :sales, only: [:index, :new, :create]
  get "sales/product_info", to: "sales#product_info", as: :product_info

  # Reports
  get "reports/daily",          to: "reports#daily",          as: :daily_report
  get "reports/monthly",        to: "reports#monthly",        as: :monthly_report
  get "reports/financial_year", to: "reports#financial_year",  as: :financial_year_report
  get "reports/export_csv",     to: "reports#export_csv",      as: :export_csv

  # User Management (owner only)
  resources :users, except: [:show, :destroy] do
    member do
      patch :toggle_active
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
