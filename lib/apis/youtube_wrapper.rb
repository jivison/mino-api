require "rubygems"
require "bundler/setup"

# Httparty is an API request library
require "httparty"
require "json"


module Youtube
  class YoutubeWrapper
    def initialize

      # Contains only the user-agent-string
      @apifile = {
        "api-key" => ENV["YOUTUBE-API-KEY"]
      }

      @default_params = {
        key: @apifile["api-key"],
      }
    end

    def query(http_params, entity_path)
      # Build a url with a host, path, and query params (which need to be encoded)
      HTTParty.get(URI::HTTPS.build(
        host: "www.googleapis.com",
        path: "/youtube/v3/#{entity_path}",
        query: URI.encode_www_form(@default_params.merge(http_params)),
      ), {
        headers: {
          "Accept": "application/json",
        },
      })
    end

    def get_title_and_channel_name(video_id)
      response = query(
        {
          part: "snippet",
          id: video_id,
          fields: "items(snippet(channelTitle,title))",
          key: @apifile["api-key"]
        }, "videos"
      ) 
      response["items"][0]["snippet"] if response["items"][0]
    end

    def get_playlist_items(limit = 50, playlist_id)
      api_response = query(
        {
          part: "snippet",
          maxResults: limit,
          playlistId: playlist_id,
          # Get only the video id and next page token
          fields: "items/snippet/resourceId/videoId,nextPageToken",
          userIp: "items",
          key: @apifile["api-key"],
        },
        "playlistItems"
      )

      ids = []

      raise ArgumentError.new "Invalid Playlist ID!" unless api_response["items"]

      api_response["items"].each { |item| ids << item["snippet"]["resourceId"]["videoId"] }

      next_page_token = api_response["nextPageToken"]

      limit = (limit > 50) ? 50 : limit

      page = 1
      if limit == 50 && next_page_token
        loop do
          # puts "Processing page #{page}"
          api_response = query(
            {
              part: "snippet",
              maxResults: limit,
              playlistId: playlist_id,
              # Get only the video id and next page token
              fields: "items/snippet/resourceId/videoId,nextPageToken",
              userIp: "items",
              key: @apifile["api-key"],
              pageToken: next_page_token,
            },
            "playlistItems"
          )
          api_response["items"].each { |item| ids << item["snippet"]["resourceId"]["videoId"] }
          next_page_token = api_response["nextPageToken"]
          break unless next_page_token
          page += 1
        end
      end

      ids
    end
  end
end
