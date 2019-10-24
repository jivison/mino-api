Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :artists do
    post '/merge', to: "artists#merge"
    get '/mergeable', to: "artists#mergeable"
    get '/maps', to: "artist_maps#show"
  end
  resources :artist_maps, only: [:index, :create, :destroy]

  resources :albums do
    post '/merge', to: "albums#merge"
    get '/mergeable', to: "albums#mergeable"
    post '/move', to: "albums#move"
    get '/moveable', to: "albums#moveable"
    get '/maps', to: "album_maps#show"
  end
  resources :album_maps, only: [:index, :create, :destroy]


  resources :tracks, shallow: true do
    post '/move', to: "tracks#move"
    get '/moveable', to: "tracks#moveable"
    resources :taggings, only: [:create]
    post "taggings/destroy", to: "taggings#destroy"
    resources :formattings, only: [:create]
    post "formattings/destroy", to: "formattings#destroy"
  end

  resources :additions, only: [:create, :index, :show, :destroy]

  get "/insights", to: "insights#index"

  # Creations controller
  scope :creations do
    post 'create_spotify_playlist', to: "creations#create_spotify_playlist"
    post 'download', to: "creations#download"
  end

  # Background controller
  scope "$" do
    post 'get_album_art', to: "background#get_album_art"
    post 'get_artist_art', to: "background#get_artist_art"
    post 'change_session', to: "background#change_session"
    post 'clean_collection', to: "background#clean_collection"
    post 'find_tags', to: "background#find_tags"
    post 'find_tags_for_artists_tracks', to: "background#find_tags_for_artists_tracks"
    post 'find_tags_for_albums_tracks', to: "background#find_tags_for_albums_tracks"
    post 'find_tags_for_every_track', to: "background#find_tags_for_every_track"
    post 'add_tags_to_album', to: "background#add_tags_to_album"
    post 'add_tags_to_artist', to: "background#add_tags_to_artist"
    get 'get_session', to: "background#get_session"
  end

end
