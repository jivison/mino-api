class AlbumMap < ApplicationRecord
  belongs_to :album
  belongs_to :user

  validates :input, uniqueness: { scope: :album_id }, presence: true

  def album_name
    self.album.title
  end
end
