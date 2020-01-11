Rails.application.routes.draw do
  get 'genres/index'
  get 'genres/show'
  devise_for :users 

  resources :users do 
    resources :games, only: [:index], as: "game"
  end

  root to: 'home#index'

  resources :games
  get '/search/games',   to: 'games#search'

  resources :user_games, only: [:create, :destroy]

  resources :genres, only: [:index, :show]
end
