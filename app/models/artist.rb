class Artist < ApplicationRecord

    # Associations
    # ArtistMaps allow the user to essentially set multiple names for a single Artist
    has_many :artist_maps, dependent: :destroy
    has_many :albums, dependent: :destroy
    has_many :tracks, dependent: :destroy

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
    
    def merge(target_artist)

        # TODO Merge isn't merging properly (it's just deleting the tracks)
        # TODO Persisted album/track hasn't been tested yet
        # TODO none of ^ has been implemented/fixed in album

        self.albums.each do |album|
            persisted_album = target_artist.albums.find_by(title: album.title)
            unless persisted_album
                album.artist = target_artist
                album.save
            end

            album.tracks.each do |track|
                target_album = target_artist.albums.find_by(title: album.title)
                if target_album

                    persisted_track = target_album.tracks.find_by(title: track.title)

                    if persisted_track
                        persisted_track.formattings < track.formattings
                        persisted_track.save
                        track.delete
                    else                        
                        track.album = target_album
                        track.artist = target_artist
                        track.save
                    end

                else
                    track.artist = target_artist
                    track.save
                end

            end


            album.album_maps.each { |album_map| album_map.update scope: target_artist.id }
        end

        self.artist_maps.each do |artist_map|
            artist_map.artist = target_artist
            artist_map.save
        end

        byebug

        self.destroy

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
