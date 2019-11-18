class TracksController < ApplicationController

    before_action :find_track, only: [:update, :destroy, :move, :show, :moveable]

    def index
        
        render_entities(current_user.tracks.sort_by { |track| track.sort_title })
    end

    def show
        render_entity(@track)
    end

    def create
        track = Track.new track_params
        track.user = current_user
        save_and_render(track)
    end

    def update
        update_and_render(@track, track_params)
    end

    def destroy
        destroy_and_render(@track)
    end

    def moveable
        render_entities(current_user.albums.where(artist_id: @track.artist_id).select{ |album| album.id != @track.album_id } )
    end

    def move
        target_album = current_user.albums.find(params[:target_id])
        @track.album = target_album
        @track.save
        render_entity(target_album)
    end

    private
    def find_track
        @track = current_user.tracks.find_by(id: params[:track_id])
        @track ||= current_user.tracks.find(params[:id]) 
    end

    def track_params
        params.require(:track).permit(:title, :artist_id, :album_id)
    end

end
