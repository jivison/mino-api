class User < ApplicationRecord
    has_secure_password

    has_many :additions
    has_many :album_maps
    has_many :albums
    has_many :artist_maps
    has_many :artists
    has_many :formattings
    has_many :taggings
    has_many :tracks

    validates :email, uniqueness: true, presence: true
    validates :username, uniqueness: { case_insensitive: true }, presence: true, length: { in: 3..30 }
    validate :no_spaces

    private
    def no_spaces
        if !username.match(/[\w\.\_]*/i)
            errors.add(:username, "can't contain special characters (except _ and .)")
        end
    end
end
