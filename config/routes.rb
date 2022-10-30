Rails.application.routes.draw do
  devise_for :users,
             defaults: { format: :json },
             path: '',
             path_names: {
               sign_in: 'api/v1/login',
               sign_out: 'api/v1/logout',
               registration: 'api/v1/signup'
             },
             controllers: {
               sessions: 'api/v1/sessions',
               registrations: 'api/v1/registrations'
             }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :projects, only: %i[show create update destroy] do
        resources :sections, only: %i[create]
        resources :tasks, only: %i[create]
      end

      resources :sections, only: %i[update destroy] do
        resources :tasks, only: %i[create]
      end

      resources :tasks, only: %i[update destroy] do
        resource :tasks, only: %i[create]
      end
    end
  end
end
