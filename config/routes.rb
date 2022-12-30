Rails.application.routes.draw do
  # Devise Routes
  devise_for :users,
             defaults: { format: :json },
             path: '',
             path_names: {
               sign_in: 'api/v1/login',
               sign_out: 'api/v1/logout',
               registration: 'api/v1/signup',
               confirmation: 'api/v1/confirmation',
               password: 'api/v1/password'
             },
             controllers: {
               sessions: 'api/v1/sessions',
               registrations: 'api/v1/registrations',
               confirmations: 'api/v1/confirmations',
               passwords: 'api/v1/passwords'
             }

  # API - Version 1 Routes
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Project-Specific Routes
      resources :projects, only: %i[index show create update destroy] do
        resources :sections, only: %i[create]
        resources :tasks, only: %i[create]
      end

      # Section-Specific Routes
      resources :sections, only: %i[update destroy] do
        resources :tasks, only: %i[create]
      end

      # Task-Specific Routes
      resources :tasks, only: %i[index update destroy]
    end
  end

  # Route to ping heroku server to wake up
  get '/ping', to: 'pings#ping', defaults: { format: :json }
end
