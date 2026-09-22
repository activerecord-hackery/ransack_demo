Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: :index do
    match "advanced_search" => "users#advanced_search",
      on: :collection, via: [:get, :post], as: :advanced_search
  end
  root to: "users#index"
end
