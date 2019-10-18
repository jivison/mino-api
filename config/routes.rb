Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :artists

  resources :artist_maps, only: [:index, :create, :destroy]

end
