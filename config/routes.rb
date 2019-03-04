Rails.application.routes.draw do
  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'users#twitter_login'
  get '/admin/users', to: 'users#index'
  patch '/users/:id/profile', to: 'users#update_profile', as: 'update_profile'
  patch '/users/:id/password', to: 'users#update_password', as: 'update_password'
  resources :users, except: [:index, :update ,:destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
