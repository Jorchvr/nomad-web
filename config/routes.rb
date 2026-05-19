Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Frontoffice — directorio público
  root "frontoffice/profiles#index"
  namespace :frontoffice do
    resources :profiles, only: [:index, :show] do
      get :portfolio, on: :member
    end
    resources :travel_stories, only: [:index, :show]
    get 'professions', to: 'professions#index', as: :professions
  end

  # OmniAuth callbacks (must be outside namespace — OAuth providers redirect here)
  get  "/auth/:provider/callback", to: "backoffice/omniauth_callbacks#github",        constraints: { provider: "github" }
  get  "/auth/:provider/callback", to: "backoffice/omniauth_callbacks#google_oauth2", constraints: { provider: "google_oauth2" }
  get  "/auth/failure",            to: "backoffice/omniauth_callbacks#failure"

  # Backoffice — área de miembros
  namespace :backoffice do
    root "dashboard#index"
    get  "tutorial", to: "dashboard#tutorial", as: :tutorial
    get  "confirm",       to: "confirmations#show",   as: :confirm_email
    post "resend-confirmation", to: "confirmations#resend", as: :resend_confirmation
    get  "two-factor/verify",  to: "two_factor#new",     as: :two_factor_verify
    post "two-factor/verify",  to: "two_factor#create"
    get  "two-factor/setup",   to: "two_factor#setup",   as: :two_factor_setup
    post "two-factor/enable",  to: "two_factor#enable",  as: :two_factor_enable
    delete "two-factor/disable", to: "two_factor#disable", as: :two_factor_disable

    # WebAuthn / Passkeys
    get  "passkeys/verify",     to: "webauthn_sessions#show",      as: :webauthn_verify
    get  "passkeys/challenge",  to: "webauthn_sessions#challenge", as: :webauthn_challenge
    post "passkeys/verify",     to: "webauthn_sessions#create"
    get  "passkeys/register",   to: "webauthn_credentials#challenge", as: :webauthn_registration_challenge
    post "passkeys",            to: "webauthn_credentials#create",    as: :webauthn_credentials
    delete "passkeys/:id",      to: "webauthn_credentials#destroy",   as: :webauthn_credential
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
