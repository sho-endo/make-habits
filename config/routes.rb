Rails.application.routes.draw do
  root "static_pages#home"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "/signup", to: "users#new"
  get "/auth/:provider/callback", to: "users#twitter_login"
  get "/admin/users", to: "users#index"
  patch "/users/:id/profile", to: "users#update_profile", as: "update_profile"
  patch "/users/:id/password", to: "users#update_password", as: "update_password"
  get "/users/:id/delete", to: "users#delete", as: "delete_page"
  resources :users, except: [:index, :update]

  resources :account_activations, only: [:new, :create, :edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :habits, only: [:destroy]
  get "/habits/select", to: "habits#select"

  resources :makes, only: [:create, :show, :update]
  get "/makes/new/1", to: "makes#new1"
  get "/makes/new/2", to: "makes#new2"
  get "/makes/new/3", to: "makes#new3"
  get "/makes/new/4", to: "makes#new4"
  get "/makes/new/5", to: "makes#new5"
  get "/makes/new/6", to: "makes#new6"
  get "/makes/new/7", to: "makes#new7"
  get "/makes/new/8", to: "makes#new8"
  get "/makes/new/9", to: "makes#new9"

  resources :quits, only: [:create, :show, :update]
  get "/quits/new/1", to: "quits#new1"
  get "/quits/new/2", to: "quits#new2"
  get "/quits/new/3", to: "quits#new3"
  get "/quits/new/4", to: "quits#new4"
  get "/quits/new/5", to: "quits#new5"
  get "/quits/new/6", to: "quits#new6"
  get "/quits/new/7", to: "quits#new7"
end
