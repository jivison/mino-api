class ArtistMapsController < ApplicationController
    before_action :find_artist_map, only: :destroy

    def index
        artist_map_hash = ArtistMap.group_by(:artist_name)
        render json: {maps: artist_map_hash, sort_titles: Artist.all.inject({}) { |acc, artist|
            acc[artist.title] = artist.sort_title
            acc 
        }}, status: 200
    end

    def show
        render_entities(ArtistMap.where(artist_id: params[:artist_id]))
    end
    
    def create
        artist_map = ArtistMap.new artist_map_params
        save_and_render(artist_map)
    end

    def destroy
        destroy_and_render(@artist_map)
    end

    private
    def find_artist_map
        @artist_map = ArtistMap.find(params[:id])
    end

    def artist_map_params
        params.require(:artist_map).permit(:input, :artist_id)
    end
end
