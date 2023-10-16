Rails.application.routes.draw do
  post 'users/forgot_password', to: 'users#forgot_password'
  post 'users/reset_password', to: 'users#reset_password'
  post "user_login", to: "users#user_login"
  get "dishes/search", to: "dishes#search"
  resource :users, only: [:create,:show,:update,:destroy]
  resources :restaurants, only: [:index,:create,:show,:update,:destroy] do
    resources :dishes
  end
  resources :categories, only: [:index,:create,:show,:update]
  resources :carts, only: [:create]
  resources :cart_items, only: [:index, :create, :update, :destroy]
  resources :orders, only: [:index, :create, :show, :destroy]
end
