module Types
  class AlbumMapType < Types::BaseObject
    field :input, String, null: false
    field :album, Types::AlbumType, null: false
    field :scope, Integer, null: false
  end
end
