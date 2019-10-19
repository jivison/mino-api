require_relative "../../lib/api_manager"

class CreationsController < ApplicationController

    def download
        headers = [:title, :artist_title, :artist_id, :album_title, :album_id, :tags_names, :tags_ids, :formats_names, :formats_ids]

        collection_csv = [headers.dup()]

        collection_csv.concat(Track.all.sort_by{ |track| [track.artist.sort_title, track.album.sort_title] }.map do |track|
            headers.inject([]) do |acc, val|

                if val.to_s.ends_with?("_ids")
                    acc << track.send(val.to_s.gsub("_ids", "")).map(&:id).flatten.join(",")
                elsif val.to_s.ends_with?("_names")
                    acc << track.send(val.to_s.gsub("_names", "")).map(&:name).flatten.join(",")
                elsif val.to_s.ends_with?("_title")
                    acc << track.send(val.to_s.gsub("_title", "")).title
                else
                    acc << track.send(val).to_s
                end
                acc
            end
        end)

        send_data generate_csv(collection_csv), filename: "mino_collection.csv", type: "application/csv"

        render_success("Collection exported successfully")

    end

    def create_spotify_playlist
        # endpoints
        # POST      /v1/users/{user_id}/playlists                   # Create a playlist
        # POST      /v1/playlists/{playlist_id}/tracks              # Add tracks to a playlist
        # GET       /v1/me                                          # Current user
        access_token = params[:access_token]

        current_spotify_user = ApiManager.spotify.authorized_query("me", {}, access_token)
        user_id = current_spotify_user["id"]

        if user_id

            new_playlist = ApiManager.spotify.authorized_query("users/#{user_id}/playlists", {}, access_token, true, {
                name: "My Mino Collection",
                description: "Generated from Mino's external playlist tool."
            })

            playlist_id = new_playlist["id"]

            uris, lost, found = ApiManager.spotify.getUris Track.all.sort_by{ |track| [track.artist.sort_title, track.album.sort_title] }

            responses = []

            uris.each_slice(100) do |uris_chunk|
                responses << ApiManager.spotify.authorized_query("playlists/#{playlist_id}/tracks", {}, access_token, true, {
                    uris: uris_chunk
                })
            end

            lost = lost.sort_by { |track| track.sort_title }
            found = found.sort_by { |track| track.sort_title }
            
            render json: { responses: responses, lost_tracks: lost, found_tracks: found }, status: 200
        else
            render_errors("Something went wrong authenticating you.", 400)
        end
    end

    private
    def generate_csv(array)
        CSV.generate(headers: true) do |csv|
            array.each do |track|
                csv << track
            end
        end
    end

end
