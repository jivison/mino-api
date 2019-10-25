# Include wasn't working even after config-ing it to load
require_relative "../../lib/seed_manager"

class AdditionsController < ApplicationController
    before_action :find_addition, only: [:show, :destroy]

    include ActionView::Helpers::TextHelper

    def create
        # params = { format, options (to be passed to the seed function) }
        countBefore = {artist: Artist.all.count, album: Album.all.count, track: Track.all.count}

        options = JSON.parse(params[:options], symbolize_names: true)

        begin
          case params[:format]
            
          when "spotify"
            SeedManager.seed_from_spotify options[:playlistId]
      
          when "youtube"
            SeedManager.seed_from_youtube options[:playlistId]
    
          when "vinyl"
            SeedManager.seed_from_vinyl options
      
          end
        rescue ArgumentError
          render json: { errors: "Invalid input!" }, status: 400
          Addition.last.destroy()
        rescue Exception => e
          render json: { errors: "Something went wrong..." }, status: 500
        else
          trackCount = Track.all.count - countBefore[:track]
          albumCount = Album.all.count - countBefore[:album]
          artistCount = Artist.all.count - countBefore[:artist]
    
          render json: { messages: "Added #{pluralize(trackCount, 'track')}, #{pluralize(albumCount, 'album')}, and #{pluralize(artistCount, 'artist')}" }, status: 200
        end
    end

    def index
        render_entities(Addition.all)
    end

    def show
        render json: @addition, serializer: AdditionShowSerializer
    end

    def destroy
        @addition.destroy_associated_tracks
        destroy_and_render(@addition)
    end

    private
    def find_addition
        @addition = Addition.find(params[:id])
    end

end
