class Format < ApplicationRecord
    # Associations
    has_many :formattings, dependent: :destroy
    has_many :tracks, through: :formattings

    # Validations
    validates :name, uniqueness: true, presence: true

end
