Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  get 'about', to: 'application#about'
  get 'memo', to: 'memo#index'
  get 'memo/images', to: 'memo#images'
  # get 'actors', to: 'actor#index'
  # get 'actors/:id', to: 'actor#actor'
  resources :actors
  get 'actors-scrapper', to: 'actors#scrapper'
  mount ActionCable.server, at: '/cable'
  get 'nicknames', to: 'nicknames#index'

end
