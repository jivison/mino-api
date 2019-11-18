class AlbumsController < ApplicationController

    before_action :find_album, only: [:show, :destroy, :update, :mergeable, :merge, :moveable, :move]

    def index
        render_entities(current_user.albums.sort_by { |album| album.sort_title })
    end
    
    def show
        render_entity(@album)
    end

    def create
        album = Album.new album_params
        album.user = current_user
        save_and_render(album)
    end

    def update
        @album.create_map(current_user) if album_params[:title] != @album.title && params[:create_map]
        update_and_render(@album, album_params)
    end

    def destroy
        destroy_and_render(@album)
    end

    def mergeable
        render_entities(@album.artist.albums.where.not(id: @album.id))
    end

    def merge
        target_album = current_user.albums.find(params[:target_id])
        @album.merge(target_album, current_user)
        render_entity(target_album)
    end

    def moveable
        render_entities(current_user.artists.where.not(id: @album.artist_id))
    end

    def move
        target_artist = current_user.artists.find(params[:target_id])
        @album.album_maps.each do |album_map|
            album_map.update scope: target_artist.id
        end
        @album.artist = target_artist
        @album.tracks.each do |track|
            track.artist = target_artist
            track.save
        end
        save_and_render(@album)
    end

    private
    def find_album
        @album = current_user.albums.find_by(id: params[:album_id])
        @album ||= current_user.albums.find(params[:id])
    end

    def album_params
        params.require(:album).permit(:title, :image_url, :artist_id)
    end

end
