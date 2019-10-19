Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :artists do
    post '/merge', to: "artists#merge"
  end
  resources :artist_maps, only: [:index, :create, :destroy]

  resources :albums do
    post '/merge', to: "albums#merge"
    post '/move', to: "albums#move"
  end
  resources :album_maps, only: [:index, :create, :destroy]


  resources :tracks, only: [:create, :update, :destroy, :show], shallow: true do
    post '/move', to: "tracks#move"
    resources :taggings, only: [:create, :destroy]
    resources :formattings, only: [:create, :destroy]
  end

  resources :additions, only: [:create, :index, :show, :destroy]

end
