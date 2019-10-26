class AlbumMapsController < ApplicationController
    before_action :find_album_map, only: :destroy

    def index
        album_map_hash = AlbumMap.group_by(:album_name)
        render json: {maps: album_map_hash, sort_titles: Album.all.inject({}) { |acc, album|
                acc[album.title] = album.sort_title
                acc
            }}, status: 200
    end

    def show
        render_entities(AlbumMap.where(album_id: params[:album_id]))
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
