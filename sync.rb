require 'optparse'

require_relative 'setup'
require_relative 'library'

options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: sync.rb [options]."
  parser.on('-S', '--start [ARG]', "Start syncing from specified artist.") do |start_artist_arg|
    options[:start] = start_artist_arg
  end
  parser.on('-E', '--end [ARG]', "End syncing after specified artist.") do |end_artist_arg|
    options[:end] = end_artist_arg
  end
  parser.on('-A', '--artist [ARG]', "Sync only the specified artist.") do |single_artist_arg|
    options[:artist] = single_artist_arg
  end
  parser.on('-t', '--target TARGET', "Sync to the specified path.") do |target_arg|
    target_arg = target_arg + '/' unless target_arg[-1] == '/'
    options[:target] = target_arg
  end
  parser.on('-l', '--library LIBRARY', "The directory containing the library file.") do |library_arg|
    library_arg = library_arg + '/' unless library_arg[-1] == '/'
    options[:library] = library_arg
  end
  parser.on('-a', '--albums', "Sync marked albums.") do |sync_albums_arg|
    options[:albums] = sync_albums_arg
  end
  parser.on('-f', '--favourites', "Sync favourite tracks.") do |sync_favourites_arg|
    options[:favourites] = sync_favourites_arg
  end
  parser.on('-e', '--essentials', "Sync essentials collections.") do |sync_essentials_arg|
    options[:essentials] = sync_essentials_arg
  end
  parser.on('-h', '--help', 'Display this help.') do
    puts parser
    exit
  end
end.parse!

include Setup

sync_albums = !!options[:albums]
sync_favourites = !!options[:favourites]
sync_essentials = !!options[:essentials]

raise 'Nothing to sync: albums, favourites or essentials must be specified.' unless sync_favourites || sync_essentials || sync_albums

TARGET_PATH = options[:target] || raise('Target path must be specified.')
LIBRARY_PATH = options[:library] || raise('Library path must be specified')
library = Library.get_latest(LIBRARY_PATH)

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

if options[:artist]
  artists_to_sync = [library.find_artist_by_name(options[:artist])]
else
  artists_to_sync = library.artists
  if options[:start]
    start_artist = options[:start]
    raise "Start artist #{start_artist} does not exist in the library" unless library.artist_known? start_artist
    library.artists.keep_if { |artist| artist.name.downcase >= start_artist.downcase }
  end
  if options[:end]
    end_artist = options[:end]
    raise "End artist #{end_artist} does not exist in the library" unless library.artist_known? end_artist
    library.artists.keep_if { |artist| artist.name.downcase <= end_artist.downcase }
  end

end

artists_to_sync.each do |artist|
  puts "\nSyncing #{artist.name}"

  artist_path = "#{TARGET_PATH}#{artist.name[0].upcase}/#{artist.name}"
  Dir.mkdir artist_path if Dir[artist_path] == []
  Dir.chdir artist_path

  # Delete anything that's not longer needed.
  existing_items = Dir['*']
  existing_items.each do |item|
    FileUtils.rm_r(item, force: true) unless artist.has_album_named? item
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
    puts "---- #{album.title}"
    files_to_sync = []
    album.tracks.each do |track|
      files_to_sync.push track.filename if (sync_albums && album.favourite) ||
          (sync_favourites && track.favourite) ||
          (sync_essentials && track.essentials)
    end
    source_directory = "#{SOURCE_PATH}#{artist.name[0].upcase}/#{artist.name}/#{album.title}/"
    target_directory = "#{TARGET_PATH}#{artist.name[0].upcase}/#{artist.name}/#{album.title}"
    Dir.mkdir target_directory unless Dir.exist? target_directory
    Dir.chdir target_directory
    # Remove any existing files we don't want.
    existing_files = Dir['*']
    existing_files.each do |file|
      FileUtils.rm(file) unless files_to_sync.include?(file)
    end
    # Copy over the files we want.
    files_to_sync.each do |file_to_sync|
      track_source = "#{source_directory}#{file_to_sync}"
      unless File.exist? track_source
        puts "Cannot sync #{track_source} because it does not exist."
        next
      end
      unless File.exist?(file_to_sync) && FileUtils.identical?(track_source, file_to_sync)
        puts "Copying #{track_source} to #{Dir.pwd}"
        FileUtils.cp(track_source, '.')
      end
    end
    if Dir["#{target_directory}/*"] == []
      # Remove the album directory if there's nothing in it.
      FileUtils.rm_r(target_directory, force: true)
    else
      # Copy any jpg image files over.
      Dir["#{source_directory}/*.jpg"].each do |image|
        FileUtils.cp image, target_directory
      end
    end
  end
  FileUtils.rm_r(artist_path) if Dir["#{artist_path}/*"] == []
end

# Create favourites playlist if it's wanted.
favourites_playlist = "#{TARGET_PATH}Radio Russ.m3u"
if sync_favourites
  FileUtils.rm(favourites_playlist) unless Dir[favourites_playlist] == []
  File.open(favourites_playlist, 'a') do |file|
    library.favourite_tracks.each do |track|
      file.puts "#{track.artist.initial_dir}#{track.artist.name}/#{track.album.title}/#{track.filename}"
    end
  end
end
