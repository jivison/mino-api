class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :title, :sort_title, :image_url

  has_many :albums

  class AlbumSerializer < ActiveModel::Serializer
    attributes :id, :title, :image_url, :tracks
  end

end
