class Album < ApplicationRecord
  # Associations
  has_many :album_maps, dependent: :destroy
  has_many :tracks, dependent: :destroy
  belongs_to :artist
  belongs_to :user
  
  # Callbacks (in order)
  after_initialize :set_default_image_url
  before_save :use_artist_maps
  after_create :create_map

  # Validations
  validates :title, presence: true, uniqueness: {scope: :artist_id}
  validate :check_maps, on: :create

  def create_map(current_user = self.user, map_input: self.title)
    if !current_user.album_maps.exists?(input: map_input, scope: self.artist.id)
      AlbumMap.create(
          input: map_input,
          album_id: id,
          scope: self.artist.id,
          user_id: current_user.id
      )
    end
  end

  def merge(target_album, current_user)
    self.tracks.each do |track|

      persisted_track = target_album.tracks.find_by(title: track.title)

      if persisted_track

        track.formattings.each do |formatting|
          Formatting.create(
              track_id: persisted_track.id,
              format_id: formatting.format_id,
              addition_id: formatting.addition_id,
              user_id: current_user.id
          )
          formatting.destroy
        end

        track.delete

      else
        new_track = Track.create({
            title: track.title,
            album_id: target_album.id,
            artist_id: track.artist_id,
            created_at: track.created_at,
            user: current_user.id
        })
        track.formattings.each do |formatting|
            Formatting.create({
                track_id: new_track.id,
                format_id: formatting.format_id,
                addition_id: formatting.addition_id,
                user_id: current_user.id
            })
        end
        
        track.destroy
      end

    end

    self.album_maps.each do |album_map|
        album_map.album = target_album
        album_map.save
    end

    AlbumMap.create({
        album_id: target_album.id,
        input: self.title,
        scope: self.artist_id,
        user_id: current_user.id
    })
    
    self.destroy
    
  end

  def sort_title
    self.title.gsub(/the /i, "").upcase.gsub(/“”"'/, "").gsub(/\W/, "*").gsub(/[0-9]/, "#")
  end

  def formats
    self.tracks.collect(&:formattings).flatten.collect(&:format).pluck(:name).uniq
  end

  private
  def set_default_image_url
    self.image_url ||= "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu4oc-oZdWxQV9--CBYadMyrQEKXd7-CSBsNdsN7L8KPCJD1Dt"
  end

  def check_maps
    if self.user.album_maps.exists?(input: self.title, scope: self.artist.id)
      errors.add(:title, "has already been mapped to another album for this artist")
    end
  end

  def use_artist_maps
    if map = self.user.artist_maps.find_by(input: self.artist.title)
      self.artist_id = map.artist_id
    end
  end

end
