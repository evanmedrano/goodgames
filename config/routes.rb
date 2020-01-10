Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'my_registrations' }
  root to: 'home#index'

  resources :games
  get '/search/games',   to: 'games#search'

  resources :user_games, only: [:create, :destroy]
end
