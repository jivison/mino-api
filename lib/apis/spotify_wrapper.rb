require "rubygems"
require "bundler/setup"
require "base64"

require "httparty"

module Spotify
  class SpotifyWrapper
    def initialize
      @token_requested_time = DateTime.now
      @apifile = {
        "client-id" => ENV['SPOTIFY-CLIENT-ID'],
        "client-secret" => ENV['SPOTIFY-CLIENT-SECRET']
      }
     
      base64_auth = Base64.strict_encode64("#{@apifile["client-id"]}:#{@apifile["client-secret"]}")

      @auth = HTTParty.post(URI::HTTPS.build(
        host: "accounts.spotify.com",
        path: "/api/token",
        query: URI.encode_www_form({ grant_type: "client_credentials" }),
      ), {
        headers: {
          "Authorization" => "Basic #{base64_auth}",
        },
      })

    end

    def refresh_token
      if (DateTime.now >= @token_requested_time + 60.minutes)
        base64_auth = Base64.strict_encode64("#{@apifile["client-id"]}:#{@apifile["client-secret"]}")
        @auth = HTTParty.post(URI::HTTPS.build(
          host: "accounts.spotify.com",
          path: "/api/token",
          query: URI.encode_www_form({ grant_type: "client_credentials" }),
        ), {
          headers: {
            "Authorization" => "Basic #{base64_auth}",
          },
        })

      end
    end

    def query(path, http_params)
      refresh_token()
      HTTParty.get(URI::HTTPS.build(
        host: "api.spotify.com",
        path: "/v1/#{path}",
        query: URI.encode_www_form(http_params),
      ), {
        headers: {
          "Authorization" => "Bearer #{@auth['access_token']}",
        },
      })
    end

    def authorized_query(path, http_params, access_token, post=false, body={})
      uri = URI::HTTPS.build(
        host: "api.spotify.com",
        path: "/v1/#{path}",
        query: URI.encode_www_form(http_params)
      )

      post ? HTTParty.post(uri, {
          headers: {
            "Authorization" => "Bearer #{access_token}",
            "Content-Type" => "application/json"
          },
          body: JSON.dump(body)
        }) : HTTParty.get(uri, {
          headers: {
            "Authorization" => "Bearer #{access_token}"
          }
        })
    end
    
    # The spotify id is                 |   V  this part V    |
    # https://open.spotify.com/playlist/1iikst9y9yHGAc6vkVCRrm
    def get_playlist_tracks(spotify_id, limit=100)

      # Queries the Spotify API
      response = query("playlists/#{spotify_id}/tracks", {limit: limit})
      # Stores the next page url
      next_page = response["next"]
    
      # Hard cap the limit to 100 (the maximum that Spotify takes)
      limit = (limit > 100) ? 100 : limit
      # If the user wants more than one page of results, and the next page exists
      if limit == 100 && !next_page.nil?
        loop do
          # Get the next page with the next_page url
          next_response = HTTParty.get(next_page, {
            headers: {
              "Authorization" => "Bearer #{@auth['access_token']}",
            },
          })

          # Get the new next page
          next_page = next_response["next"]
          # Concat the tracks into the original response
          # So that seed_manager.rb can process them
          response["items"].concat(next_response["items"])
          # Keep going until there is no next_page
          break unless next_response["next"]
        end
      end


      {
        response: response,
        method: "playlist:tracks"
      }
    end

    def search_artist(name)
      query("search", {
        query: name,
        type: "artist", 
        limit: 1
      })
    end

    def search_album(name, artist)
      query("search", {
        q: "album:#{name} artist:#{artist}",
        type: "album",
        limit: 1
      })
    end

    def search_track(trackname, artist)
      response = query("search", {
        q: "track:#{trackname} artist:#{artist}",
        type: "track",
        limit: 1
      })
      if response["tracks"]["total"] != 0
        return response
      end
      response = query("search", {
        q: "track:#{trackname}",
        type: "track",
        limit: 1
      })
      response
    end

    def get_track(id) 
      query("tracks/#{id}", {})
    end

    def getUris(tracks)
      lost_tracks = []
      found_tracks = []

      uris = tracks.inject([]) do |acc, track|
          track_response = self.search_track(track.title, track.artist.title)

          if track_response["tracks"]["items"][0] && track_response["tracks"]["items"][0]["artists"][0]["name"] == track.artist.title
            acc << track_response["tracks"]["items"][0]["uri"]
            found_tracks << track.id
          else
            lost_tracks << track.id
          end

          acc
      end

      return [uris, lost_tracks, found_tracks]

    end

  end
end
