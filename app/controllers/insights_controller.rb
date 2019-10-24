class InsightsController < ApplicationController
    def index
        @taggings = Tagging.all.inject({}) do |acc, tagging|
          tag_name = tagging.tag.name
          acc[tag_name.downcase] ||= []
          acc[tag_name.downcase] << tagging 
          acc
        end
    
        @insight_data = {
          artists: Artist.all,
          albums: Album.all,
          tracks: Track.all,
        additions: Addition.where("addition_type != ?", "unassociated_add"),
          maps: [*AlbumMap.all.to_a, *ArtistMap.all.to_a],
          tags: @taggings
        }
    
        @insight_data[:top_artists] = @insight_data[:artists].map { |artist|
          artist.attributes.to_options.merge({
            track_count: artist.tracks.count
          })
        }.sort_by { |artist| artist[:track_count] }
    
        @insight_data[:top_albums] = @insight_data[:albums].map { |album|
          album.attributes.to_options.merge({
            track_count: album.tracks.count
          })
        }.sort_by { |album| album[:track_count] }
    
        # Averages
        @insight_data[:tracks_per_artist] = @insight_data[:artists].map { |artist|
          artist.tracks.count
        }
    
        @insight_data[:albums_per_artist] = @insight_data[:artists].map { |artist|
          artist.albums.count
        }
    
        @insight_data[:tracks_per_album] = @insight_data[:albums].map { |album| 
          album.tracks.count
        }
    
        @insight_data[:tags_per_track] = @insight_data[:tracks].map { |track|
          track.tags.count
        }
    
        # Percentages
        @insight_data[:num_albums_with_images] = @insight_data[:albums].inject(0) { |acc, album| 
          acc + (album.image_url == "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu4oc-oZdWxQV9--CBYadMyrQEKXd7-CSBsNdsN7L8KPCJD1Dt" || album.image_url.nil? ? 0 : 1)
        }
        
        @insight_data[:num_artists_with_images] = @insight_data[:artists].inject(0) { |acc, artist| 
          acc + (artist.image_url == "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxtVFrGlu-W8CsCKncYpJQ3pvQjRIwsraMmQDyIiquE3lOSnbu" || artist.image_url.nil? ? 0 : 1)
        }
    
        @insight_data[:num_tracks_with_tags] = @insight_data[:tracks].inject(0) { |acc, track|
          acc + (track.tags.count > 0 ? 1 : 0)
        }
    
        # Formats
        @insight_data[:formats_per_artist] = @insight_data[:tracks].map { |artist|
          artist.formats.count
        }
    
        @insight_data[:format_count] = 0
    
        @insight_data[:format_hash] = @insight_data[:tracks].inject({}) { |acc, track|
          track.formats.each { |format|
            acc[format.name] ? acc[format.name] += 1 : acc[format.name] = 1 
            @insight_data[:format_count] += 1
          }
          acc
        }

        render_entity(@insight_data)
    
      end
    
end
