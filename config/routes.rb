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

  resources :friend_requests, only: [:create]
  resources :friendships, only: [:create, :destroy]
  resources :genres,    only: [:index, :show]
  resources :platforms, only: [:index, :show]

  resources :users, only: [] do
    resources :friend_requests, only: [:index], module: :users
    resources :friendships, only: [:index], module: :users
    resource  :library, only: [:show], module: :users

    resources(
      :inbox,
      module: 'users/messages',
      only: [:index, :show],
      path: 'messages/inbox',
    )

    resources :messages, module: :users, only: [:new, :create, :destroy]

    resources(
      :sent,
      module: 'users/messages',
      only: [:index, :show],
      path: 'messages/sent',
    )
  end

  resources :user_games, only: [:update, :destroy]

  get '*unmatched_route', to: 'errors#show'
end
