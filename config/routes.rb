IcebreakerApi::Application.routes.draw do
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'application#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'


  api_version(module: 'v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :users, only: [:create, :show, :update] do
      collection do
        get :me, to: "users#me"
        get :send_confirmation, to: "users#send_confirmation"
      end
    end

    post :login, to: 'user_sessions#login'
    delete :logout_from_all_devices, to: 'user_sessions#logout_from_all_devices'
    delete :logout, to: 'user_sessions#logout'
  end

end
