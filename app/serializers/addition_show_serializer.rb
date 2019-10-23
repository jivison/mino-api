class AdditionShowSerializer < ActiveModel::Serializer
  attributes :id, :humanized_date, :humanized_type, :id_string

  has_many :tracks

  class TrackSerializer < ActiveModel::Serializer
    attributes :title, :id, :sort_title, :album
  end

end
