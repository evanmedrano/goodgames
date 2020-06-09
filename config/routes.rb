Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  # Fixes issue of devise receiving a get request as opposed to delete for the original sign out path signing out 
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :users do
    member do
      get :games
    end
  end

  resources :games, only: [:index, :show, :create] do
    resources :discover, only: [:index]
    resources :comments, module: :games
  end

  resources :user_games, only: [:create, :update, :destroy]

  resources :genres,    only: [:index, :show]
  resources :platforms, only: [:index, :show]
end
