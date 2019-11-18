# Include wasn't working even after config-ing it to load
require_relative "../../lib/seed_manager"

class AdditionsController < ApplicationController
    before_action :find_addition, only: [:show, :destroy]

    include ActionView::Helpers::TextHelper

    def create
        # params = { format, options (to be passed to the seed function) }
        countBefore = {artist: current_user.artists.count, album: current_user.albums.count, track: current_user.tracks.count}

        options = JSON.parse(params[:options], symbolize_names: true)

        begin
          case params[:format]
            
          when "spotify"
            SeedManager.seed_from_spotify(options[:playlistId], current_user)
      
          when "youtube"
            SeedManager.seed_from_youtube(options[:playlistId], current_user)
    
          when "vinyl"
            SeedManager.seed_from_vinyl(options, current_user)
      
          end
        rescue ArgumentError => e
          current_user.additions.last&.destroy()
          render_errors("Invalid input!", 400)
        rescue Exception => e
          render_errors(e, 500)
        else
          trackCount = current_user.tracks.count - countBefore[:track]
          albumCount = current_user.albums.count - countBefore[:album]
          artistCount = current_user.artists.count - countBefore[:artist]
    
          render_success "Added #{pluralize(trackCount, 'track')}, #{pluralize(albumCount, 'album')}, and #{pluralize(artistCount, 'artist')}"
        end
    end

    def index
        render_entities(current_user.additions.reverse)
    end

    def show
        render json: @addition, serializer: AdditionShowSerializer
    end

    def destroy
        @addition.destroy_associated_tracks(current_user)
        destroy_and_render(@addition)
    end

    private
    def find_addition
        @addition = current_user.additions.find(params[:id])
    end

end
