require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { confirmations: "confirmations" }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :games, only: [:index, :show, :create] do
    resources :comments, module: :games
    resources :discover, only: [:index]
  end

  resources :genres,    only: [:index, :show]
  resources :platforms, only: [:index, :show]

  resources :users, only: [] do
    resource :library, only: [:show], module: :users
  end

  resources :user_games, only: [:update, :destroy]

  get '*unmatched_route', to: 'errors#show'
end
