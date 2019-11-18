class ArtistMapsController < ApplicationController
    before_action :find_artist_map, only: :destroy

    def index
        artist_map_hash = group_entities(current_user.artist_maps, :artist_name)
        render json: {maps: artist_map_hash, sort_titles: current_user.artists.all.inject({}) { |acc, artist|
            acc[artist.title] = artist.sort_title
            acc 
        }}, status: 200
    end

    def show
        render_entities(current_user.artist_maps.where(artist_id: params[:artist_id]))
    end
    
    def create
        artist_map = ArtistMap.new artist_map_params
        artist_map.user = current_user
        save_and_render(artist_map)
    end

    def destroy
        destroy_and_render(@artist_map)
    end

    private
    def find_artist_map
        @artist_map = current_user.artist_maps.find(params[:id])
    end

    def artist_map_params
        params.require(:artist_map).permit(:input, :artist_id)
    end
end
