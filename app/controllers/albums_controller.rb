class AlbumsController < ApplicationController

    before_action :find_album, only: [:show, :destroy, :update]

    def index
        render_entities(Album.all)
    end
    
    def show
        render_entity(@album)
    end

    def create
        album = Album.new album_params
        save_and_render(album)
    end

    def update
        byebug    
        @album.create_map if album_params[:title] != @album.title && params[:create_map]
        update_and_render(@album, album_params)
    end

    def destroy
        destroy_and_render(@album)
    end

    private
    def find_album
        @album = Album.find(params[:id])
    end

    def album_params
        params.require(:album).permit(:title, :img_url, :artist_id)
    end

end
