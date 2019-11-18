class ArtistMap < ApplicationRecord
    belongs_to :artist
    belongs_to :user

    validates :input, uniqueness: { scope: :artist_id }, presence: true

    def artist_name
        self.artist.title
    end
    
end
