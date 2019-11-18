class AlbumMapsController < ApplicationController
    before_action :find_album_map, only: :destroy

    def index
        album_map_hash = group_entities(current_user.album_maps, :album_name)
        render json: {maps: album_map_hash, sort_titles: current_user.albums.inject({}) { |acc, album|
                acc[album.title] = album.sort_title
                acc
            }}, status: 200
    end

    def show
        render_entities(current_user.album_maps.where(album_id: params[:album_id]))
    end

    def create
        album_map = AlbumMap.new album_map_params
        album_map.user = current_user
        save_and_render(album_map)
    end

    def destroy
        destroy_and_render(@album_map)
    end

    private
    def find_album_map
        @album_map = current_user.album_maps.find(params[:id])
    end

    def album_map_params
        params.require(:album_map).permit(:input, :scope, :album_id)
    end
end
