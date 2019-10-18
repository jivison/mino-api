class Artist < ApplicationRecord
    # ArtistMaps allow the user to essentially set multiple names for a single Artist
    has_many :artist_maps, dependent: :destroy

    # Callbacks (in order)
    after_initialize :set_default_image_url
    after_create :create_map

    # Validations
    validates :title, presence: true, uniqueness: true
    validate :check_maps, on: :create

    # This method is accessed from outside of the model as well
    def create_map(map_input: self.title)
        if !ArtistMap.exists?(input: map_input)
            ArtistMap.create(
                input: map_input,
                artist_id: id
            )
        end
    end

    private
    def check_maps
        if ArtistMap.exists?(input: self.title)
            errors.add(:title, "has already been mapped to another artist")
        end
    end

    def set_default_image_url
        self.image_url ||= "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxtVFrGlu-W8CsCKncYpJQ3pvQjRIwsraMmQDyIiquE3lOSnbu"
    end
end
