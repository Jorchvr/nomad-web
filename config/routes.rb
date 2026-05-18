Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Frontoffice — directorio público
  root "frontoffice/profiles#index"
  namespace :frontoffice do
    resources :profiles, only: [:index, :show] do
      get :portfolio, on: :member
    end
    resources :travel_stories, only: [:index, :show]
  end

  # Backoffice — área de miembros
  namespace :backoffice do
    root "dashboard#index"
    get  "tutorial", to: "dashboard#tutorial", as: :tutorial
    get  "confirm",  to: "confirmations#show", as: :confirm_email
    get  "two-factor/verify",  to: "two_factor#new",     as: :two_factor_verify
    post "two-factor/verify",  to: "two_factor#create"
    get  "two-factor/setup",   to: "two_factor#setup",   as: :two_factor_setup
    post "two-factor/enable",  to: "two_factor#enable",  as: :two_factor_enable
    delete "two-factor/disable", to: "two_factor#disable", as: :two_factor_disable
    get  "login",    to: "sessions#new",           as: :login
    post "login",    to: "sessions#create"
    delete "logout", to: "sessions#destroy",        as: :logout
    get  "register", to: "registrations#new",       as: :register
    post "register", to: "registrations#create"
    resource  :profile, only: [:show, :edit, :update] do
      delete :avatar, on: :member, action: :destroy_avatar
    end
    resources :profile_links, only: [:create, :destroy]
    resources :work_photos,     only: [:index, :create, :destroy]
    resources :travel_stories
    resources :messages, only: [:index, :create]
    get 'messages/:user_id', to: 'messages#show', as: :message_conversation
    resources :friendships,   only: [:index, :create, :update, :destroy]
    resources :members, only: [:index, :show] do
      patch :verify, on: :member
    end
    resources :forums do
      resources :posts, only: [:create, :destroy], module: :forums
    end
  end
end
