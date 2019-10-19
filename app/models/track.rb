class Track < ApplicationRecord

  # Callbacks (in order)
  before_save :use_album_maps
  before_save :stop_duplicates

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
    # Nothing yet...
  end

end
