class FormattingsController < ApplicationController

    def create
        # params = { format }
        track = Track.find(params[:track_id])
        unless format = Format.find_by(name: normalize(params[:format]))
            format = Format.create name: normalize(params[:format])
        end
        addition = Addition.create({
            addition_type: "unassociated_add",
            id_string: "add-format:#{format.name}"
        })
        save_and_render(Formatting.new(
            track_id: track.id,
            format_id: format.id,
            addition_id: addition.id
        ))
    end

    def destroy
        format = Format.find_by(name: normalize(params[:format]))
        destroy_and_render(Formatting.find_by(track_id: params[:track_id], format_id: format.id))
    end

end
