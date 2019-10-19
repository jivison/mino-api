require 'rubygems'
require 'bundler/setup'

# Httparty is an API request library
require "httparty"
require 'json'

# https://www.last.fm/api/
module LastFM
    class LastFmWrapper
        def initialize

            # Keep the api details a secret 
            @apifile = {
                "application_name" => ENV["LASTFM-APPLICATION-NAME"],
                "apikey" => ENV["LASTFM-APIKEY"],
                "secret" => ENV["LASTFM-SECRET"],
                "registered_to" => ENV["LASTFM-REGISTERED-TO"]
            }

            # The default parameters in a last.fm api query
            @default_params = {
                format: "json",
                api_key: @apifile["apikey"],
            }
        end
        

        # Generic query parser
        def query(http_params)
            # Build a URI (yes 'I' not 'L) string from a host, path 
            # and the desired query params (which need to be in the correct format hence the URI.encode_www...)
            HTTParty.get URI::HTTP.build(
                host: 'ws.audioscrobbler.com',
                path: '/2.0/',
                query: URI.encode_www_form(http_params)
            )
        end
        
        # Convienience method to return the correct thing for pretty_print
        def return_response(method, response)
            {
                response: response,
                method: method
            }
        end

        # Get the top artists
        def get_top_artists(params=@default_params)
            # merge the default params with the ones related to chart.gettopartists
            return_response "chart.gettopartists", query(params.merge({ method: "chart.gettopartists" }))
        end
        
        # Get information about an artist
        def get_artist(artist, params=@default_params)
            # merge the default params with the ones related to artist.getinfo
            return_response "artist.getinfo", query(params.merge({
                method: "artist.getinfo",
                artist: artist,
                autocorrect: 1,
            }))
        end 

        # Get information about an artist from an mbid
        def get_artist_from_mbid(mbid, params=@default_params)
            # merge the default params with the ones related to artist.getinfo
            return_response "artist.getinfo", query(params.merge({
                method: "artist.getinfo",
                mbid: mbid
            }))
        end 

        # Get information about an album
        def get_album(artist, album, params=@default_params)
            # merge the default params with the ones related to album.getinfo
            return_response "album.getinfo", query(params.merge({
                method: "album.getinfo",
                album: album,
                artist: artist,
                autocorrect: 1,
            }))
        end

        def get_track(artist, track, params=@default_params)
            # merge the default params with the ones related to track.getinfo
            return_response "track.getinfo", query(params.merge({
                method: "track.getinfo",
                track: track,
                artist: artist,
                autocorrect: 1
            }))
        end

        def pretty_print_response(method: "error", response: "No response passed!")
            if (response["error"])
                puts response["message"]
                return 
            end
            case method
        
            when "chart.gettopartists"
                response["artists"]["artist"].each_with_index { |artist, position|
                    puts "#{position}) #{artist['name']} - #{artist['playcount']} plays"
                }
        
            when "artist.getinfo"
                response = response["artist"]
                puts "Name: #{response['name']}\t(mbid: #{response['mbid']})"
                puts "Tags: " + response["tags"]["tag"].inject([]) { |acc, tag| 
                    acc << tag['name']
                }.join(", ")
                puts response["bio"]["content"]
        
            when "album.getinfo"
                response = response["album"]
                puts "Album Name: #{response['name']}\t(mbid: #{response['mbid']})"
                puts "Artist Name: #{response['artist']}"
                puts "Tracks: "
                response["tracks"]["track"].each_with_index.inject([]) { |acc, (track, track_no)| 
                    puts "\t#{track_no}) #{track['name']}"
                }
                puts "Tags:"
                response["tags"]["tag"].each_with_index.inject([]) { |acc, (tag, tag_no)| 
                    puts "\t#{tag_no}) #{tag['name']}"
                }
            when "track.getinfo"
                response = response["track"]
                puts "Track Name: #{response['name']} \t\t(mbid: #{response['mbid']})"
                puts "Artist Name: #{response['artist']['name']} \t(mbid: #{response['artist']['mbid']})"
                puts "Album Name: #{response['album']['title']} \t(mbid: #{response['album']['mbid']})" if response['album']
                puts "Top Tags:"
                response["toptags"]["tag"].each_with_index.inject([]) { |acc, (tag, tag_no)| 
                    puts "\t#{tag_no}) #{tag['name']}"
                }
                puts
                puts response["wiki"]["content"] if response["wiki"]

            when "error"
                puts response
            end
        end
    end
end