class Track < ApplicationRecord

  # Callbacks (in order)
  before_validation :stop_duplicates
  before_save :use_album_maps

  # Associations
  belongs_to :album
  belongs_to :artist

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  
  has_many :formattings, dependent: :destroy
  has_many :formats, through: :formattings

  # Validations
  validates :title, presence: true, uniqueness: { scope: :album_id }

  private
  def use_album_maps
    if map = AlbumMap.find_by(input: self.album.title)
      self.album_id = map.album_id
    end
  end

  def stop_duplicates
    if persisted_track = Track.find_by(album_id: self.album.id, title: self.title)
      false
    end 
  end

end
