class ArtistMap < ApplicationRecord
    belongs_to :artist

    validates :input, uniqueness: { scope: :artist_id }

    def artist_name
        self.artist.title
    end
    
end
