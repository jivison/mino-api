class AlbumMap < ApplicationRecord
  belongs_to :album

  validates :input, uniqueness: { scope: :album_id }
end
