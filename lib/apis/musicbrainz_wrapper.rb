require 'rubygems'
require 'bundler/setup'

# Httparty is an API request library
require "httparty"
require 'json'

# https://musicbrainz.org/doc/Development/XML_Web_Service/Version_2
module Musicbrainz
    class MusicbrainzWrapper
        def initialize

            # Contains only the user-agent-string
            @apifile = {
                "user-agent-string" => ENV["MUSICBRAINZ-USER-AGENT-STRING"]
            }
        end

        # Generic query for the musicbrainz api
        def query(http_params, entity_path)
            # Build a url with a host, path, and query params (which need to be encoded) 
            HTTParty.get(URI::HTTPS.build(
                host: 'musicbrainz.org',
                path: "/ws/2/#{entity_path}",
                query: URI.encode_www_form(http_params)
            ), { 
                headers: { 
                    # Musicbrainz requires a User-Agent in the header
                    "User-Agent" =>  @apifile["user-agent-string"],
                    # Makes the api return json
                    "Accept" => "application/json"
                }
                })
        end

        def get_artist(mbid)
            {
                method: "artist:lookup",
                response: query({
                    # Makes the api return aliases and tags as well as all the default reponses
                    "inc" => "aliases+tags"
                    
                    # Musicbrainz api path (check documentation for more info)
                    }, "artist/#{mbid}/")
            }
            
            
        end

        def search_entity(query_string, entity="artist", limit=10)
            {
                method: "query:#{entity}",
                response: query({ query: "#{entity}:" + query_string, limit: limit}, "#{entity}/")
            }
            
        end

    end
end