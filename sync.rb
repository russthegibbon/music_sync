#!/usr/local/bin/ruby -w

require 'fileutils'
require 'open3'

warnings = []

# Read artist list.
artists_path = './artists.txt'
artists = []
File.open artists_path do |file|
  while line = file.gets
    artists.push line.chomp
  end
end

mp3_library_dir = '/Volumes/music/Music/'
flac_library_dir = '/Volumes/music/Flac/'
target_dir = '/Volumes/Hooferies/'

# Never touch anything outside the initial directories.
# Create initial directories on target, unless they already exist.
initials = artists.map { |a| a[0].upcase }.uniq.sort
initials.each do |initial|
  initial_dir = target_dir + initial
  if File.exist? initial_dir
    raise "#{initial_dir} exists but is not a directory." unless File.directory? initial_dir
  else
    Dir.mkdir initial_dir
  end
  # Delete any artists that have been removed from the artist list.
  artists_with_this_initial = artists.select { |a| a[0].upcase == initial }
  Dir.chdir initial_dir
  existing_artist_dirs = Dir['*/']
  existing_artist_dirs.each do |d|
    FileUtils.rm_r(d, force: true) unless artists_with_this_initial.include? d.chomp '/'
  end
end

artists.each do |artist|
  # Make an artist directory on the target, unless it already exists.
  initial = artist[0].upcase
  Dir.chdir target_dir + initial
  if File.exist? artist
    raise "#{artist} exists but is not a directory." unless File.directory? artist
  else
    Dir.mkdir artist
  end

  # Sync flac albums first.
  flac_source_dir = flac_library_dir + artist
  if Dir.exist? flac_source_dir
    Dir.chdir flac_source_dir
    flac_albums = Dir['*/'] || []
    flac_albums.each do |album|
      cmd = "cd \"#{flac_source_dir}\" && rsync -r --progress --delete --delete-excluded --exclude '*.ini' --exclude '*.wma' --exclude '*.db' \"./#{album}\" \"#{target_dir}#{initial}/#{artist}/#{album}\""
      sync_result = Open3.capture3 cmd
      warnings.push sync_result[1] unless sync_result[1] == ''
      puts sync_result.first
    end
  else
    flac_albums = []
  end

  # Sync mp3 albums where flac version is not available.
  mp3_source_dir = mp3_library_dir + artist
  if Dir.exist? mp3_source_dir
    Dir.chdir mp3_source_dir
    mp3_albums = Dir['*/'] - flac_albums
    mp3_albums.each do |album|
      cmd = "cd \"#{mp3_source_dir}\" && rsync -r --progress --delete --delete-excluded --exclude '*.ini' --exclude '*.wma' --exclude '*.db' \"./#{album}\" \"#{target_dir}#{initial}/#{artist}/#{album}\""
      sync_result = Open3.capture3 cmd
      warnings.push sync_result[1] unless sync_result[1] == ''
      puts sync_result.first
    end
  end

  # Note a warning if we didn't end up with any files on the target for the artist.
  Dir.chdir target_dir + initial + '/' + artist
  files_on_target = Dir.glob('**/*').reject { |f| File.directory? f }
  if files_on_target == []
    warnings.push "No music for #{artist}."
    Dir.chdir target_dir + initial
    FileUtils.rm_r artist
  end
end

unless warnings == []
puts "/n== Problems occurred =============================/n"
puts warnings
end