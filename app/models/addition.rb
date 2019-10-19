class Addition < ApplicationRecord

    has_many :formattings, dependent: :destroy
    has_many :tracks, through: :formattings

end
