require_relative "api_manager"
require_relative "scrubber"

module SeedManager
  def self.seed_from_vinyl(params)

    # Create a format if it doesn't already exist
    unless format = Format.find_by(name: "vinyl")
      format = Format.create(name: "vinyl")
    end

    # Pull relevant data from the raw data
    release = ApiManager.discogs.query_release(params)[:response]
    release_id = release["results"][0]["master_id"] if release["results"]
    
    album = ApiManager.discogs.get_release(release_id)
    tracks = album["tracklist"].map {|track| track["title"] }
    artist_name = album["artists"][0]["name"]

    # Create the addition to associate the tracks with
    addition = Addition.create({
      addition_type: "discogs-vinyl",
      id_string: "#{artist_name}-#{album['title']}"
    })

    # Attempt to create an artist
    Artist.create(
      title: artist_name,
      image_url: ApiManager.get_artist_art(artist_name),
    )

    # Attempt to create an album
    Album.create(
      title: album["title"],
      artist_id: ArtistMap.find_by(input: artist_name).artist_id,
      image_url: ApiManager.get_album_art(album["title"], artist_name),
    )

    # Whether or not the above creations succeded, check the map databases
    # to get the artist's and album's ids
    artist_map = ArtistMap.find_by(input: artist_name)
    album_map = AlbumMap.find_by(input: album["title"], scope: artist_map.artist_id)

    # Create the all the tracks
    tracks.each do |track|
      track = Track.create(
        title: track,
        artist_id: artist_map.artist_id,
        album_id: album_map.album_id,
      )
      _formatting = Formatting.create({
        format: format,
        track: track,
        addition: addition
      })
    end

  end

  def self.seed_from_spotify(spotify_id)
    
    unless format = Format.find_by(name: "spotify")
      format = Format.create(name: "spotify")
    end

    response = self.parse_spotify_data ApiManager.spotify.get_playlist_tracks(spotify_id, 100)

    addition = Addition.create({
      addition_type: "spotify_playlist",
      id_string: spotify_id
    })
    
    self.seed_from_linked_hash(response, addition, format)

  end

  def self.seed_from_youtube(playlist_id)

    unless format = Format.find_by(name: "youtube")
      format = Format.create(name: "youtube")
    end

    # Returns an array of { track, artist }
    songs = Scrub.get_songs playlist_id

    addition = Addition.create({
      addition_type: "youtube_playlist",
      id_string: playlist_id
    })
    
    data = {}

    songs.each do |song|
        artist = song[:artist]
        track = song[:track]
        
        # Youtube Videos don't have an album, so we have to find one ourself
        album = ApiManager.get_album_from_trackname(track, artist)
        
        data[artist] ||= {}
        data[artist][album] ||= []
    
        data[artist][album] << track

    end

    self.seed_from_linked_hash(data, addition, format)

  end

  def self.seed_from_linked_hash(linked_hash, addition, format)
    linked_hash.each do |artist, albums|
        
        # Attempt to create an artist
        Artist.create(
            title: artist,
            image_url: ApiManager.get_artist_art(artist),
        )

        albums.each do |album, tracks|

            # Attempt to create an album
            Album.create(
                title: album,
                artist_id: ArtistMap.find_by(input: artist).artist_id,
                image_url: ApiManager.get_album_art(album, artist),
            )

            tracks.each do |track|
                
                # Whether or not the above creations succeded, check the maps for
                # The artist/album id
                artist_map = ArtistMap.find_by(input: artist)
                album_map = AlbumMap.find_by(input: album, scope: artist_map.artist_id)

                created_artist = Artist.find(artist_map.artist_id)
                created_album = Album.find(album_map.album_id)

                created_track = Track.create(
                    artist_id: artist_map.artist_id,
                    album_id: album_map.album_id,
                    title: track
                )
                Formatting.create(
                    track_id: Track.find_by({
                      artist_id: created_artist.id,
                      album_id: created_album.id
                      }).id,
                    format_id: format.id,
                    addition_id: addition.id
                )

            end # Tracks each
        end # Albums each
    end # Artists each
  end

  def self.parse_spotify_data(api_response)
    raise ArgumentError.new "Invalid playlist ID!" unless api_response[:response]["items"]

    # Schema for `data`
    # artist: {
    #   album: {
    #     [tracks]
    #   }
    # }

    data = {}

    api_response[:response]["items"].each do |item|

      # Pull the artists, album, and track from each item
      artists = item["track"]["artists"]
      album = item["track"]["album"]["name"]
      track = item["track"]["name"]

      # Join the multiple artists
      artists_name = item["track"]["artists"].map { |artist| artist["name"] }.join(", ")

      data[artists_name] ||= {}
      data[artists_name][album] ||= []

      data[artists_name][album] << track
    end

    data

  end

end