class TrackSerializer < ActiveModel::Serializer
  attributes :id, :title, :sort_title

  belongs_to :artist
  belongs_to :album

  class ArtistSerializer < ActiveModel::Serializer
    attributes :title
  end 

  class AlbumSerializer < ActiveModel::Serializer
    attributes :id, :image_url
  end 
end
