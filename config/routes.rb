Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations'}
  root to: 'welcome#home'

  
  get 'search_friends', to: 'users#search'
  get 'search_stocks', to: 'stocks#search'

  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_friends', to: 'users#my_friends'
  post 'add_friend', to: 'users#add_friend'
  
  resources :user_stocks, only: %w[create destroy]
  resources :users, only: %w[show]
  resources :friendships
end