module Types
  class ArtistMapType < Types::BaseObject
    field :input, String, null: false
    field :artist, Types::ArtistType, null:false
  end
end
