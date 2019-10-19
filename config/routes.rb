Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :artists
  resources :albums
  resources :tracks, only: [:create, :update, :destroy] do
    post '/move', to: "tracks#move"
  end

  resources :artist_maps, only: [:index, :create, :destroy]
  resources :album_maps, only: [:index, :create, :destroy]

end
