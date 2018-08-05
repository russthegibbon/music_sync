#!/usr/local/bin/ruby -w

require_relative 'setup'
require_relative 'library'

include Setup

sync_main = true
sync_favourites = true
sync_essentials = true

TARGET_PATH = '/Volumes/GONZALES/Music/'
library = Library.get_latest

Dir.chdir TARGET_PATH

def create_initial_directories(library)
  artists = library.artists
  artist_names = artists.map(&:name)
  initials = artist_names.map { |a| a[0].upcase }.uniq.sort
  # Delete anything that doesn't correspond to a valid initial.
  Dir['*'].each do |item|
    FileUtils.rm_r(item, force: true) unless initials.include? item
  end

  initials.each do |initial|
    initial_dir = TARGET_PATH + initial
    if File.exist? initial_dir
      raise "#{initial_dir} exists but is not a directory." unless File.directory? initial_dir
    else
      Dir.mkdir initial_dir
    end
    # Delete any artists that have been removed from the artist list.
    artists_with_this_initial = artist_names.select { |a| a[0].upcase == initial }
    Dir.chdir initial_dir
    existing_artist_dirs = Dir['*']
    existing_artist_dirs.each do |d|
      FileUtils.rm_r(d, force: true) unless artists_with_this_initial.include? d.chomp '/'
    end
  end
end

create_initial_directories library

# Create favourites playlist if it's wanted.
FAVOURITES_PLAYLIST = "#{TARGET_PATH}Radio Russ.m3u"
if sync_favourites
  FileUtils.touch FAVOURITES_PLAYLIST
end

library.artists.each do |artist|
  puts "==== Synching #{artist.name}"

  artist_path = "#{TARGET_PATH}#{artist.name[0].upcase}/#{artist.name}"
  Dir.mkdir artist_path if Dir[artist_path] == []
  Dir.chdir artist_path

  # Delete anything that's not longer needed.
  existing_items = Dir['*']
  existing_items.each do |item|
    FileUtils.rm_r item unless artist.has_album_named? item
  end

  # Create essentials playlist if it's wanted.
  if sync_essentials && artist.has_essentials_tracks?
    playlist_filename = "The Essential #{artist.name}.m3u"
    FileUtils.rm(playlist_filename) unless Dir[playlist_filename] == []
    File.open(playlist_filename, 'a') do |file|
      artist.essentials_tracks.each do |track|
        file.puts track
      end
    end
  end

  artist.albums.each do |album|
    puts "-------- Synching #{album.title}"
    files_to_sync = []
    album.tracks.each do |track|
      files_to_sync.push track.filename if (sync_main && album.favourite) ||
          (sync_favourites && track.favourite) ||
          (sync_essentials && track.essentials)
      if track.favourite
        File.open(FAVOURITES_PLAYLIST, 'a') do |file|
          file.puts "#{artist.initial_dir}#{artist.name}/#{album.title}/#{track.filename}"
        end
      end
    end

    target_directory = "#{TARGET_PATH}#{artist.name[0].upcase}/#{artist.name}/#{album.title}"
    Dir.mkdir target_directory if Dir[target_directory] == []
    Dir.chdir target_directory
    files_to_sync.each do |file_to_sync|
      existing_files = Dir['*']
      existing_files.each do |file|
        FileUtils.rm(file) unless files_to_sync.include?(file)
      end
      track_source = "#{LIBRARY_PATH}#{artist.name}/#{album.title}/#{file_to_sync}"
      unless Dir[file_to_sync] != [] && FileUtils.identical?(track_source, file_to_sync)
        puts "Copying #{track_source} to #{Dir.pwd}"
        FileUtils.cp(track_source, '.')
      end
    end
    FileUtils.rm_r(target_directory) if Dir["#{target_directory}/*"] == []
  end
  FileUtils.rm_r(artist_path) if Dir["#{artist_path}/*"] == []
end
