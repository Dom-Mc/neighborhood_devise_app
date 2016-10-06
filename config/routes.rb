Rails.application.routes.draw do

  root 'home#index'

  devise_for :users
  # NOTE: For adding OAuth
  # devise_for :users, controllers: {
  #   omniauth_callbacks: "users/omniauth_callbacks",
  #   registrations: 'users/registrations'
  # }

  resources :users, only: :show
  resources :posts

end
