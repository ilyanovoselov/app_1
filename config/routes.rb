Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  get 'about', to: 'application#about'
  get 'actors', to: 'actor#index'
  get 'actors/:id', to: 'actor#actor'



end
