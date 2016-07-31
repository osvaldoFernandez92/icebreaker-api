IcebreakerApi::Application.routes.draw do

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'application#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'


  api_version(module: 'v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :users, only: [:index, :create, :show, :update] do
      collection do
        get :me, to: "users#me"
      end
    end

    resources :activities, only: [:search, :create, :show] do
      collection do
        get :search
        get :my_activities
      end

      member do
        post :join
        post :add_comment
      end
    end


    post :login, to: 'user_sessions#login'
    delete :logout_from_all_devices, to: 'user_sessions#logout_from_all_devices'
    delete :logout, to: 'user_sessions#logout'
  end

end
