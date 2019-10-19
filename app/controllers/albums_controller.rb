class AlbumsController < ApplicationController

    before_action :find_album, only: [:show, :destroy, :update, :merge, :move]

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

    def merge
        target_album = Album.find(params[:target_id])
        @album.merge(target_album)
        render_entity(target_album)
    end

    def move
        target_artist = Artist.find(params[:target_id])
        @album.artist_maps.each do |album_map|
            album_map.update scope: target_artist.id
        end
        @album.artist = target_artist
        save_and_render(@album)
    end

    private
    def find_album
        @album = Album.find(params[:id])
    end

    def album_params
        params.require(:album).permit(:title, :img_url, :artist_id)
    end

end
