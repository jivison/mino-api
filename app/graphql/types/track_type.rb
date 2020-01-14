module Types
  class TrackType < Types::BaseObject
    field :id, ID, null: false
    field :artist, Types::ArtistType, null: false
    field :album, Types::AlbumType, null: false
    field :title, String, null: false
  end
end
