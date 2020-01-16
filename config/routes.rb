Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users 

  resources :users do 
    member do
      get :games
    end
  end

  resources :games do
    resources :comments
  end

  get "discover/games-like-:id", to: "games#discover", as: "discover"

  resources :user_games, only: [:create, :update, :destroy]

  resources :genres,    only: [:index, :show]
  resources :platforms, only: [:index, :show]
end
