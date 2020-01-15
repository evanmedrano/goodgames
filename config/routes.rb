Rails.application.routes.draw do
  get 'platforms/index'
  get 'platforms/show'
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

  resources :user_games, only: [:create, :update, :destroy]

  resources :genres,    only: [:index, :show]
  resources :platforms, only: [:index, :show]
end
