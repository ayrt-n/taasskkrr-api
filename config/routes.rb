Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[show create update destroy]
    end
  end
end
