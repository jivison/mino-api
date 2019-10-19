
# Requiring the api modules
require_relative "apis/last_fm_wrapper"
require_relative "apis/discogs_wrapper"
require_relative "apis/spotify_wrapper"
require_relative "apis/youtube_wrapper"

require "json"

module ApiManager

  # Create the api objects
  LASTFM = LastFM::LastFmWrapper.new
  DISCOGS = Discogs::DiscogsWrapper.new
  SPOTIFY = Spotify::SpotifyWrapper.new
  YOUTUBE = Youtube::YoutubeWrapper.new

  def self.last_fm
    LASTFM
  end

  def self.discogs
    DISCOGS
  end

  def self.spotify
    SPOTIFY
  end

  def self.youtube
    YOUTUBE
  end

  def self.get_album_from_trackname(trackname, artist)
    response = self.spotify.search_track(trackname, artist)
    if response["tracks"]["total"] > 0
      response["tracks"]["items"][0]["album"]["name"]
    else
      trackname
    end
  end

  def self.get_artist_art(name)
    response = ApiManager.spotify.search_artist(name)
    if response["artists"]
      response = response["artists"]["items"]
      (response.length > 0 && response[0]["images"].length > 0) ? response[0]["images"][0]["url"] : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxtVFrGlu-W8CsCKncYpJQ3pvQjRIwsraMmQDyIiquE3lOSnbu"
    else
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxtVFrGlu-W8CsCKncYpJQ3pvQjRIwsraMmQDyIiquE3lOSnbu"
    end
  end

  def self.get_album_art(name, artist="")
    response = ApiManager.spotify.search_album(name, artist)["albums"]["items"]
    (response.length > 0 && response[0]["images"].length > 0) ? response[0]["images"][0]["url"] : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu4oc-oZdWxQV9--CBYadMyrQEKXd7-CSBsNdsN7L8KPCJD1Dt"
  end

  def self.get_track_tags(track, artist)
    response = ApiManager.last_fm.get_track(artist, track)
    return response[:response]["track"] ? response[:response]["track"]["toptags"]["tag"].map { |track| track["name"] } : []
  end
end