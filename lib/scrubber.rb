require_relative "api_manager"

def clean(title, artist, seperator)
  # The regex to find featuring artists
  regex__featuring_artists = /([ (\[](ft\.|feat\.|featuring).+)/i

  if seperator == "|"
    split_title = *title.split(/ *\| */)
  else
    split_title = *title.split(/ *#{seperator} */)
  end

  artist = split_title[0].strip
  title = split_title[1..].join(" #{seperator} ").strip

  # Nuke all double quotes
  title.gsub!(/["]/, "")
  title.gsub!("'", "")
  
  # Normalize feat, ft, featuring => ft 
  title.gsub!(/(feat|ft|featuring)[. ]+/i, "ft. ")
  
  # Find all the featuring artists in an artist's name
  features = artist.scan(regex__featuring_artists)

  # Kill them all
  artist.gsub!(regex__featuring_artists, "")

  # Scrub the features
  features = features[0][0].strip.gsub(/[()\[\]]/, "").gsub(/(feat|ft|featuring)[. ]+/i, "ft. ") if features != []

  # Then add them back (but to the title)
  title = title.strip +  (" " + features) if features != [] 

  {
    title: title,
    artist: artist
  }

end

module Scrub
  def self.get_songs(playlist_id)

    songs = []
    song_array = []

      ApiManager.youtube.get_playlist_items(50, playlist_id).each do |id| 
          video_details = ApiManager.youtube.get_title_and_channel_name(id)
          song_array << {title: video_details["title"], artist: video_details["channelTitle"]} if video_details
      end

    # The regex equivalent to a 50 line if else statement, im sorry
    regex__mv_markers = /[ (\[](Official Video|Official Music Video|【MV】|Video|Music Video|- Official Video|Original Music Video|Version officielle|vidéoclip officiel|official MV|MV|M\/V|Official M\/V|Clip Officiel)[\]) ,]*/i

    regex__other_garbage = /[ (\[](Version Original|Original Version|from .*|Cover|[\w ]*Lyrics[\w ]*|Lyric Video|Audio|Performance Version|Official Audio|OFFICIAL VERSION|Starring[\w ]+|Explicit|Radio edit|Clean ver\.|Youtube ver\.|Official|Version officielle|[0-9]{4}|b[- ]side|Mashup|French Canadian|Subtitulado)[\]) ,]*/i
    
    song_array.each do |song_hash| 

      title = song_hash[:title].gsub(regex__mv_markers, "").gsub(regex__other_garbage, "").gsub("【MV】", "")
                                                                      # This is broken in regex for some reason
      artist = song_hash[:artist]
      # This one if line will handle ALL 'official Youtube Music tracks'
      if artist.include? " - Topic"
        artist = artist.gsub(" - Topic", "")
      
      # The bellow elsifs will try their hardest to handle all the 
      # Sketchy bootleg uploads
      elsif title.include? " - "
        title, artist = clean(title, artist, "-").values
        
      elsif title.include? "|"
        title, artist = clean(title, artist, "|").values
        
      elsif title.include? ":"
        title, artist = clean(title, artist, ":").values
        
      elsif title.include? "\""
        new_artist = title.split(" \"")[0].gsub("\"", "")
        title = title[/(["'])(\\?.)*?\1/].gsub("\"", "")
        artist = new_artist unless new_artist == title
        
      elsif title.include? "//"
        title, artist = clean(title, artist, "//").values
          
      elsif title.include? "/"
        title, artist = clean(title, artist, "/").values
        
      elsif title.match /'.+'/
        new_artist = title.split("'")[0].gsub("'", "")
        artist = new_artist.strip unless new_artist == title
        title = title.match(/'.+'/).to_s.gsub("'", "")
      
      elsif title.match /「.+」/
        new_artist = title.split("「")[0].gsub("「", "").gsub("」", "")
        artist = new_artist.strip unless new_artist == title
        title = title.match(/「.+」/).to_s.gsub("「", "").gsub("」", "")
    
      elsif title.match /『.+』/
        new_artist = title.split("『")[0].gsub("『", "").gsub("』", "")
        artist = new_artist.strip unless new_artist == title
        title = title.match(/『.+』/).to_s.gsub("『", "").gsub("』", "")
    
      elsif title.include? "  "
        title, artist = clean(title, artist, "  ").values
    
      end

      songs << {
        track: title, 
        artist: artist
      }
    end

    songs 
  end
end