class ArtistMap < ApplicationRecord
    belongs_to :artist

    validates :input, uniqueness: { scope: :artist_id }

end
