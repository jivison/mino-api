# Include wasn't working even after config-ing it to load
require_relative "../../lib/seed_manager"

class AdditionsController < ApplicationController
    before_action :find_addition, only: [:show, :destroy]

    include ActionView::Helpers::TextHelper

    def create
        # params = { format, options (to be passed to the seed function) }
        countBefore = {artist: Artist.all.count, album: Album.all.count, track: Track.all.count}
        begin
          case params[:format]
            
          when "spotify"
            SeedManager.seed_from_spotify params[:options]
      
          when "youtube"
            SeedManager.seed_from_youtube params[:options]
    
          when "vinyl"
            SeedManager.seed_from_vinyl JSON.parse(params[:options], symbolize_names: true)
      
          end
        rescue ArgumentError
          render json: { errors: "Invalid playlist ID!" }, status: 400
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
        render_entity(@addition)
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