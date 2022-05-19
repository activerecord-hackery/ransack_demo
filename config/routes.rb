Rails.application.routes.draw do
  resources :users, only: :index do
    match "advanced_search" => "users#advanced_search",
          on: :collection, via: [:get, :post], as: :advanced_search
  end
  root to: "users#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
