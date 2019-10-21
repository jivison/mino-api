class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :title, :sort_title, :image_url, :formats

  has_many :albums

  class AlbumSerializer < ActiveModel::Serializer
    attributes :id, :title, :image_url
    attribute :serialized_tracks, key: :tracks

    def serialized_tracks
      object.tracks.map { |track| track.attributes.to_options.merge({
        formats: track.format_names
      }) }
    end

  end

end
