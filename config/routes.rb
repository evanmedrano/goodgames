Rails.application.routes.draw do
  get 'users/games'
  root to: 'home#index'
  devise_for :users 

  resources :users do 
    member do
      get :games
    end
  end

  resources :games do
    collection do
      get :search
    end
  end

  resources :user_games, only: [:create, :destroy]

  resources :genres, only: [:index, :show]
end
