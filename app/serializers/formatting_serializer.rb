class FormattingSerializer < ActiveModel::Serializer
  belongs_to :format

  class FormatSerializer < ActiveModel::Serializer
    attributes :name
  end

end
