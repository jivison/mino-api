class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :title, :image_url, :sort_title, :formats, :artist_id
  
  belongs_to :artist
  has_many :tracks

  class ArtistSerializer < ActiveModel::Serializer
    attributes :id, :title
  end

end
