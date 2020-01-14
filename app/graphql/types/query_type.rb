
module Types
  class QueryType < Types::BaseObject

    # TODO: Figure out how to send back a generic "messages"
    def authenticate
      if !context[:current_user]
        return nil, ["You must be signed in to access this API endpoint"]
      end
      return context[:current_user], []
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :artists, [Types::ArtistType], null: true do
        description "Returns a users artists"
        argument :limit, Integer, required: false
    end

    def artists(limit:)
      user, messages = authenticate
      if limit
        return user.artists[0..limit-1]
      end
      user.artists
    end

    field :artist, Types::ArtistType, null: true do 
        description "Returns an artist by id"
        argument :id, ID, required: true  
    end

    field :albums, [Types::AlbumType], null: true do
      description "Returns a users albums"
      argument :limit, Integer, required: false
    end

    def albums(limit:)
      user, messages = authenticate
      if limit 
        return user.albums.all[0..limit-1]
      end
      user.albums.all
    end

    def artist(id:)
      user, messages = authenticate
      user.artists.find(id)
    end

    field :album, Types::AlbumType, null: true do
      description "Returns an album by its id"
      argument :id, ID, required: true
    end

    def album(id:)
      user, messages = authenticate
      user.albums.find(id)
    end

    field :tracks, [Types::TrackType], null: true do
      description "Returns a user's tracks"
      argument :limit, Integer, required: false
      argument :random, Boolean, required: false
    end

    def tracks(limit: nil, random: false)
      user, messages = authenticate
      tracks = user.tracks
      tracks = tracks.shuffle if random
      tracks = tracks[0..limit-1] if !limit.nil?
      tracks
    end
  end
end
