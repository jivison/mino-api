class TrackSerializer < ActiveModel::Serializer
  attributes :id, :title, :sort_title, :addition_ids, :album_id
  attribute :format_names, key: :formats
  attribute :tag_names, key: :tags

  belongs_to :artist
  belongs_to :album

  class ArtistSerializer < ActiveModel::Serializer
    attributes :title
  end 

  class AlbumSerializer < ActiveModel::Serializer
    attributes :id, :image_url
  end 
end
