class Tagging < ApplicationRecord
  
  # Associations
  belongs_to :track
  belongs_to :tag

  # Validations
  validates :tag_id, uniqueness: { scope: :track_id }

end
