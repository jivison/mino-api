class TaggingsController < ApplicationController

    def create
        track = Track.find(params[:track_id])

        # A list of tag names
        # Turn it into an array if it's just a single tag
        tags = [params[:tags]].flatten

        created_taggings = tags.map do |tag_name|
            tagging = nil
            if tag_entity = Tag.find_by(name: normalize(tag_name))
                tagging = Tagging.create(tag_id: tag_entity.id, track_id: track.id)
            else
                tagging = Tagging.create(
                    tag_id: Tag.create(name: normalize(tag_name)).id,
                    track_id: track.id
                )
            end
            tagging
        end

        render_entities(created_taggings)
    end

    def destroy
        tag = Tag.find_by(name: normalize(params[:tag]))
        destroy_and_render(Tagging.find_by(track_id: params[:track_id], tag_id: tag.id))
    end

end
