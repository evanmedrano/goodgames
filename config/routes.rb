Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  get '/games/show/:id', to: 'games#show', as: 'game'
  get '/games/search',   to: 'games#search'
end
