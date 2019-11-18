class Formatting < ApplicationRecord

  # Associations
  belongs_to :format
  belongs_to :track
  belongs_to :addition
  belongs_to :user

end
