class AlbumMapsController < ApplicationController
    before_action :find_album_map, only: :destroy

    def index
        album_map_hash = AlbumMap.group_by(:album_id)
        render json: album_map_hash, status: 200
    end

    def create
        album_map = AlbumMap.new album_map_params
        save_and_render(album_map)
    end

    def destroy
        destroy_and_render(@album_map)
    end

    private
    def find_album_map
        @album_map = AlbumMap.find(params[:id])
    end

    def album_map_params
        params.require(:album_map).permit(:input, :scope, :album_id)
    end
end
