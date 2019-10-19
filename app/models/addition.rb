class Addition < ApplicationRecord

    has_many :formattings, dependent: :destroy
    has_many :tracks, through: :formattings

    def destroy_associated_tracks
        self.formattings.map(&:destroy).each do |formatting|
            persisted_track = Track.find(formatting.track.id)
            if persisted_track&.formattings.count == 0
                persisted_track.destroy
            end
        end
    end

end
