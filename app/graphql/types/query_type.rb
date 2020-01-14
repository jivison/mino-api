module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :artists, [Types::ArtistType], null: false do
        description "Returns a users artists"
        argument :limit, Integer, required: false
    end

    def artists(limit:)
      user = context[:current_user]
      if limit
        return user.artists[0..limit-1]
      end
      user.artists
    end

    field :artist, Types::ArtistType, null: true do 
        description "Returns an artist by id"
        argument :id, ID, required: true  
    end

    field :albums, [Types::AlbumType], null: false do
      description "Returns a users albums"
      argument :limit, Integer, required: false
    end

    def albums(limit:)
      if limit 
        return Album.all[0..limit-1]
      end
      Album.all
    end

    def artist(id:)
        Artist.find(id)
    end

    field :album, Types::AlbumType, null: true do
      description "Returns an album by its id"
      argument :id, ID, required: true
    end

    def album(id:)
      Album.find(id)
    end

  end
end
