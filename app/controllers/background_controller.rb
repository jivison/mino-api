require_relative "../../lib/api_manager"

# TODO https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-analysis/

class BackgroundController < ApplicationController

    def get_album_art
        art = ApiManager.get_album_art(params[:album_name], params[:artist_name])
        album = Album.find(params[:album_id])
        update_and_render(album, {image_url: art})
    end

    def get_artist_art
        art = ApiManager.get_artist_art(params[:artist_name])
        artist = Artist.find(params[:artist_id])
        update_and_render(artist, {image_url: art})
    end

    # Used internally (by this controller)
    def add_tag(tags: nil, track_id: nil)
        tag_names ||= [params[:tags]].flatten
        track_id ||= params[:track_id]

        track = Track.find(track_id)

        added_tags = []

        tag_names.reject { |tag_name| tag_name == "" || tag_name == " " }.each do |tag_name|
            if !(tag = Tag.find_by(name: normalize(tag_name)))
                tag = Tag.create(name: normalize(tag_name))
            end
            unless track.tags.map{ |tag| tag.name.downcase }.include? tag.name.downcase
                track.tags << tag
                added_tags << tag
            end
        end
    end

    def change_session
        session[params[:session_key].to_sym] = params[:session_value]
        render_success("Changed session")
    end

    def get_session
        session["focus"] ||= "artists"
        render_success(session[request.params["session_key"]])
    end

    # TODO add all the "whole collection" actions to be applied to specific additions

    def clean_collection
        # Merge all similar artists (similar being capitals, &/and, spaces)

        tracks = params[:addition_id] ? Track.all.select {|track| track.formattings.map(&:addition_id).include? params[:addition_id] } : Track.all

        albums = params[:addition_id] ? tracks.map(&:album).uniq : Album.all
        artists = params[:addition_id] ? tracks.map(&:artist).uniq : Artist.all

        # Compare each pair
        # For me, reverse produces the better result
        artists.reverse.permutation(2).to_a.each do |pair|
            if normalize(pair[0].title) == normalize(pair[1].title)
                pair[0].merge(pair[1]) unless pair[1].id == pair[0].id || normalize(pair[1].title) == ""
            end
        end

        albums = params[:addition_id] ? tracks.map(&:album).uniq : Album.all

        # Merge all similar albums (similar being capitals, &/and, spaces)
        albums.reverse.permutation(2).to_a.each do |pair|
            if normalize(pair[0].title) == normalize(pair[1].title)
                pair[0].merge(pair[1]) unless pair[1].id == pair[0].id || normalize(pair[1].title) == ""
            end
        end

        # Update the lists
        tracks = params[:addition_id] ? Track.all.select { |track| track.formattings.map(&:addition_id).include? params[:addition_id] } : Track.all

        albums = params[:addition_id] ? tracks.map(&:album).uniq : Album.all
        artists = params[:addition_id] ? tracks.map(&:artist).uniq : Artist.all

        # Delete all empty albums
        albums.each do |album|
            if album.tracks.count == 0
                album.destroy
            end
        end

        # Delete all empty artists
        artists.each do |artist|
            if artist.albums.count == 0
                artist.destroy
            end
        end
        
        # Destroy all tracks that don't have an album
        # Or that have an album that has been deleted
        # (Artifact of merge)
        tracks.each do |track|
            track.destroy unless Album.find_by(id: track.album_id)
            track.destroy unless Artist.find_by(id: track.artist_id)
        end

        albums.each do |album|
            album.destroy unless Artist.find_by(id: album.artist_id)
        end

        render_success("Collection Cleaned")
    end

    def find_tags(track_id: nil)
        track_id ||= params[:track_id]

        added_tags = []

        track = Track.find(track_id)
        new_tag_names = ApiManager.get_track_tags(track.title, track.artist.title)

        new_tag_names = new_tag_names.map do |tag_name|
            tag_name = tag_name.downcase
            unless tag = Tag.find_by(name: normalize(tag_name))
            tag = Tag.create(name: normalize(tag_name))
            end

            unless track.tags.map(&:name).include? tag.name.downcase
                track.tags << tag 
                added_tags << tag
                track.save
            end

            tag
        end
        
        if params[:track_id]
            render_entities(added_tags) 
        else
            # added_tags
            new_tag_names
        end
    end

    def find_tags_for_artists_tracks
        artist = Artist.find(params[:id])
        added_tags = artist.tracks.map do |track|
            find_tags(track_id: track.id)
        end.flatten
        render_entities(added_tags)
    end

    def find_tags_for_albums_tracks
        album = Album.find(params[:id])
        added_tags = album.tracks.map do |track|
            find_tags(track_id: track.id)
        end.flatten
        render_entities(added_tags)
    end

    def find_tags_for_every_track
        tracks = params[:addition_id] ? Track.all.select { |track| track.formattings.map(&:addition_id).include? params[:addition_id] } : Track.all

        added_tags = tracks.map do |track|
            find_tags(track_id: track.id)
        end.flatten

        render_entities(added_tags)
    end

    def add_tags_to_album
        album = Album.find(params[:id])
        added_tags = album.tracks.map do |track|
            add_tag(track_id: track.id, tags: params[:tags])
        end.flatten

        render_entities(added_tags)
    end

    def add_tags_to_artist
        artist = Artist.find(params[:id])
        added_tags = artist.tracks.map do |track|
            add_tag(track_id: track.id, tags: params[:tags])
        end.flatten

        render_entities(added_tracks)
    end

end

