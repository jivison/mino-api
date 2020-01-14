module Types
  class AlbumType < Types::BaseObject
    field :id, ID, null: false
    field :artist, Types::ArtistType, null: false
    field :title, String, null: false
    field :image_url, String, null: false
    field :tracks, [Types::TrackType], null: false
    field :album_maps, [Types::AlbumMapType], null: false
  end
end
