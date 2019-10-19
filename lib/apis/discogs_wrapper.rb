require 'rubygems'
require 'bundler/setup'

require 'httparty'

module Discogs
    class DiscogsWrapper
        def initialize
            @apifile = {
                'client-key' => ENV["DISCOGS-CLIENT-KEY"],
                'client-secret' => ENV["DISCOGS-CLIENT-SECRET"],
                'user-agent-string' => ENV["DISCOGS-USER-AGENT-STRING"],
                
            }
            @default_params = {
                key: @apifile["client-key"],
                secret: @apifile["client-secret"]
            }
        end

        def query(http_params, endpoint="/database/search")
            HTTParty.get(URI::HTTPS.build(
                host: 'api.discogs.com',
                path: "#{endpoint}",
                query: URI.encode_www_form(@default_params.merge(http_params))
            ), { 
                headers: { 
                    # Discogs requires a User-Agent in the header
                    "User-Agent" =>  @apifile["user-agent-string"],
                    }
                })
        end
    
        def query_release(album: "", artist: "", year: "", format: "", catno: "", barcode: "", per_page: 10)
            {
                response: query({
                    release_title: album,
                    artist: artist,
                    year: year,
                    format: format,
                    catno: catno,
                    barcode: barcode,
                    per_page: per_page 
                    }),
                method: "query:release"
            }
        end

        def query_by_barcode(barcode, per_page=10)
            {
                response: query({
                    barcode: barcode,
                    per_page: per_page
                    }),
                method: "query:release"
            }
        end

        def get_release(id)
            query({}, "/masters/#{id}")
        end

    end
end

