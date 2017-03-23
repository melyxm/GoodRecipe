Rails.application.routes.draw do
  get 'braintree/new'

  get 'sessions/new'

  get 'users/new'

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"
  root :to => "homes#index"
  post 'braintree/checkout'
  resources :users
  resources :sessions
  resources :recipes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
