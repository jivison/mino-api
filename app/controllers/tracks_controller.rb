class TracksController < ApplicationController

    before_action :find_track, only: [:update, :destroy, :move, :show]

    def show
        render_entity(@track)
    end

    def create
        track = Track.new track_params
        save_and_render(track)
    end

    def update
        update_and_render(@track, track_params)
    end

    def destroy
        destroy_and_render(@track)
    end

    def move
        target_album = Album.find(params[:target_id])
        @track.album = target_album
        save_and_render(@track)
    end

    private
    def find_track
        @track = Track.find_by(id: params[:id]) 
        @track ||= Track.find(params[:track_id])
    end

    def track_params
        params.require(:track).permit(:title, :artist_id, :album_id)
    end

end
