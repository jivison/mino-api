class Addition < ApplicationRecord

    has_many :formattings, dependent: :destroy
    has_many :tracks, through: :formattings
    belongs_to :user

    def destroy_associated_tracks(current_user)
        self.formattings.map(&:destroy).each do |formatting|
            persisted_track = current_user.tracks.find(formatting.track.id)
            if persisted_track&.formattings.count == 0
                persisted_track.destroy
            end
        end
    end

    def is_unassociated?
        self.title == "unassociated_add"
    end

    def humanized_type
        self.addition_type.humanize
    end

    def humanized_date
        ActionController::Base.helpers.time_ago_in_words(self.created_at)
    end

end
