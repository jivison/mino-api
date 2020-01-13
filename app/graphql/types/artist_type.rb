module Types
  class ArtistType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :image_url, String, null: false
    field :albums, [Types::AlbumType], null: false
    field :tracks, [Types::TrackType], null: false
    field :artist_maps, [Types::ArtistMapType], null: false
  end
end
