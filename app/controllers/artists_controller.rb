class ArtistsController < ApplicationController
    
    before_action :find_artist, only: [:show, :destroy, :update, :merge, :mergeable]

    def index
        render_entities(current_user.artists.sort_by { |artist| artist.sort_title })
    end
    
    def show
        render_entity(@artist)
    end

    def create
        artist = Artist.new artist_params
        artist.user = current_user
        save_and_render(artist)
    end

    def update
        @artist.create_map(current_user) if artist_params[:title] != @artist.title && params[:create_map]
        update_and_render(@artist, artist_params)
    end

    def destroy
        destroy_and_render(@artist)
    end

    def mergeable
        render_entities(current_user.artists.where.not(id: @artist.id))
    end

    def merge
        target_artist = current_user.artists.find(params[:target_id])
        @artist.merge(target_artist, current_user)
        render_entity(target_artist)
    end

    private
    def find_artist
        @artist = current_user.artists.find_by(id: params[:artist_id])
        @artist ||= current_user.artists.find(params[:id]) 
    end

    def artist_params
        params.require(:artist).permit(:title, :image_url)
    end
end
