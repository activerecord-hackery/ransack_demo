RansackDemo::Application.routes.draw do
  resources :users, only: :index do
    post :search, on: :collection
  end
  root to: 'users#index'
end
