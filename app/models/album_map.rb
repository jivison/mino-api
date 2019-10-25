class AlbumMap < ApplicationRecord
  belongs_to :album

  validates :input, uniqueness: { scope: :album_id }, presence: true

  def album_name
    self.album.title
  end
end
