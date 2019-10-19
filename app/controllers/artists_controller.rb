class ArtistsController < ApplicationController
    before_action :find_artist, only: [:show, :destroy, :update]

    def index
        render_entities(Artist.all)
    end
    
    def show
        render_entity(@artist)
    end

    def create
        artist = Artist.new artist_params
        save_and_render(artist)
    end

    def update
        @artist.create_map if artist_params[:title] != @artist.title && params[:create_map]
        update_and_render(@artist, artist_params)
    end

    def destroy
        destroy_and_render(@artist)
    end

    private
    def find_artist
        @artist = Artist.find(params[:id])
    end

    def artist_params
        params.require(:artist).permit(:title, :img_url)
    end
end
