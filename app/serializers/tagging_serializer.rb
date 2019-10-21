class TaggingSerializer < ActiveModel::Serializer
  belongs_to :tag

  class TagSerializer < ActiveModel::Serializer
    attributes :name
  end

end
