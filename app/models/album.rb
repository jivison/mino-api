class Album < ApplicationRecord
  # Associations
  has_many :album_maps, dependent: :destroy
  has_many :tracks, dependent: :destroy
  belongs_to :artist
  
  # Callbacks (in order)
  after_initialize :set_default_image_url
  before_save :use_artist_maps
  after_create :create_map

  # Validations
  validates :title, presence: true, uniqueness: {scope: :artist_id}
  validate :check_maps, on: :create

  def create_map(map_input: self.title)
    if !AlbumMap.exists?(input: map_input, scope: self.artist.id)
      AlbumMap.create(
          input: map_input,
          album_id: id,
          scope: self.artist.id
      )
    end
  end

  def merge(target_album)
    self.tracks.each do |track|

      persisted_track = target_album.tracks.find_by(title: track.title)

      if persisted_track

        track.formattings.each do |formatting|
          Formatting.create(
              track: persisted_track,
              format: formatting.format,
              addition: formatting.addition
          )
          formatting.destroy
        end

        track.delete

      else
        track.album = target_album
        track.save
      end

    end

    self.album_maps.each do |album_map|
        album_map.album = target_album
        album_map.save
    end

    self.destroy

  end

  def sort_title
    self.title.gsub(/the /i, "").upcase.gsub(/“”"'/, "").gsub(/\W/, "*").gsub(/[0-9]/, "#")
  end

  def formats
    self.tracks.collect(&:formattings).flatten.collect(&:format).pluck(&:name)
  end

  private
  def set_default_image_url
    self.image_url ||= "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu4oc-oZdWxQV9--CBYadMyrQEKXd7-CSBsNdsN7L8KPCJD1Dt"
  end

  def check_maps
    if AlbumMap.exists?(input: self.title, scope: self.artist.id)
      errors.add(:title, "has already been mapped to another album for this artist")
    end
  end

  def use_artist_maps
    if map = ArtistMap.find_by(input: self.artist.title)
      self.artist_id = map.artist_id
    end
  end

end
