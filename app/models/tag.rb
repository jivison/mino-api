class Tag < ApplicationRecord
    has_many :taggings, dependent: :destroy
    has_many :tracks, through: :taggings

    validates :name, uniqueness: true, presence: true
end
