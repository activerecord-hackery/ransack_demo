RansackDemo::Application.routes.draw do
  resources :users, only: :index do
    match 'advanced_search' => 'users#advanced_search',
          on: :collection, via: [:get, :post], as: :advanced_search
  end
  root to: 'users#index'
end
