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
  patch "/users/:id/avatar", to: "users#update_avatar", as: "update_avatar" # デモアカウント用
  get "/users/:id/delete", to: "users#delete", as: "delete_page"
  resources :users, except: [:index, :update]

  resources :account_activations, only: [:new, :create, :edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :habits, only: [:destroy]
  get "/habits/select", to: "habits#select"

  get "/makes/title", to: "makes#title"
  get "/makes/norm_description", to: "makes#norm_description"
  get "/makes/norm_input", to: "makes#norm_input"
  get "/makes/rule1_description", to: "makes#rule1_description"
  get "/makes/rule1_input", to: "makes#rule1_input"
  get "/makes/situation_description", to: "makes#situation_description"
  get "/makes/situation_input", to: "makes#situation_input"
  get "/makes/rule2_description", to: "makes#rule2_description"
  get "/makes/rule2_input", to: "makes#rule2_input"
  resources :makes, only: [:create, :show, :update]

  get "/quits/title", to: "quits#title"
  get "/quits/situation_description", to: "quits#situation_description"
  get "/quits/situation_input", to: "quits#situation_input"
  get "/quits/rule1_description", to: "quits#rule1_description"
  get "/quits/rule1_input", to: "quits#rule1_input"
  get "/quits/rule2_description", to: "quits#rule2_description"
  get "/quits/rule2_input", to: "quits#rule2_input"
  resources :quits, only: [:create, :show, :update]
end
