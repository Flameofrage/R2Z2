module R2Z2
	module MusicBot
	#Class to play and manage music
	class MusicPlayer
		#Loops if true
		attr_accessor :repeat

		# Skips to next song, ignores repeat
		attr_accessor :skip

		# ID of server
		attr_reader :id

		# Determines if music is currently being played
		attr_reader :playing
			
		# Text channel for bot responses
		attr_accessor :channel

		# Voice object that should be used for playback
		attr_accessor :voice

		# Array that holds the song queue
		attr_reader :queue

		def initialize(id)
			@id = id
			@queue = []
			@repeat = false
			@skip = false
			@playing = false
			@server_dir = "#{Dir.pwd}/music_bot/music/#{id}/"

			if Dir.exist?(@server_dir)
				clean_directory
			else
				Dir.mkdir(@server_dir)
			end

			afk_timer
		end

		#Downloads Song and returns true if success
		def add(video_id)
			song = Song.new(video_id, @server_dir)
			if valid_song?(song) && unique_song?(song)
				message = respond("Downloading \"#{song.title}\".")
				@queue << song
				if song.download
					message.delete
					true
				else
					message.delete
					@queue.delete(song)
					respond("There was a problem downloading \"#{song.title}\"")
					false
				end
			else
				false
			end
		end

		# Starts a loop, which plays the first song from queue if it is available, or wait until it is.
		def start_loop
			unless @playing || @queue.first.nil?
				@playing = true
				loop do
					if @queue.empty?
						respond('I have no songs, give me a fat beat with `add`!')
						break
					end
					song = @queue.first
					play_song(song) if song.ready || wait_for_song(song)
				end
				@playing = false
			end
		end

		# Tracks on deck
		def table
			Terminal::Table.new(headings: %w(# Name Duration Link)) do |t|
				@queue.each_with_index do |song, index|
					title = song.truncated_title
					duration = song.duration_formated
					url = "<#{song.url}>"
					t.add_row([index + 1, title, duration, url])
				end
			end
		end

		# Deletes the entire music directory
		def delete_dir
			FileUtils.rm_rf(@server_dir)
			@queue = []
		end

		def delete_song_at(index)
			@queue[index].delete
			@queue.delete_at(index)
		end

		def playing?
			@playing
		end

		# Destroys voice connection and deletes all files.
		def disconnect(message = nil)
			@voice.destroy
			delete_dir
			respond(message) if message
			@voice = nil
			@channel = nil
		rescue => e
			LOGGER.error 'An error occured while trying to leave a server.'
			LOGGER.log_exception e
		end

		private

		#Plays a song and keeps looping it if @repeat is true. Deletes it after it has finished.
		def play_song(song)
			message = respond("Spinning #{song.inspect}")
			LOGGER.debug "Playing a song (#{song.inspect}), repeating: #{@repeat}"
			loop do
				@voice.play_file(song.path)
				STATS.song_played += 1
				next if @repeat && !@skip
				@skip = false
				delete_first_song unless @queue.first.nil?
				message.delete
				break
			end
		end

		# Waits until song is available to play or returns false if it takes too long.
		def wait_for_song(song)
			retries = 0
			loop do
				LOGGER.debug "Waiting for song to be available on server #{@id} (#{song.inspect}) #{"(#{retries})" if retries.positive?}"
				return true if song.ready
				if retries > 3
					LOGGER.debug "Song was not available after #{retries} retries on server #{@id}. (#{song.inspect})"
					return false
				end
				respond("\"#{song.title}\" is not ready yet, will start playing once it is.")
				retries += 1
				sleep(10)
			end
		end


		def delete_first_song
			delete_song(@queue.first)
		end
		
		# Finds a song in the queue and deletes it.
		def delete_song(song)
			@queue.find { |x| x == song }.delete
			@queue.delete(song)
		end
		
		# Checks if this song has already been added to the queue and informs user
		def unique_song?(song)
			@queue.each do |song_from_queue|
				if song_from_queue.url == song.url
					respond('I have this track loaded. Slap it with a `repeat` to play it more')
					return false
				end
			end
			true
		end

		# Checks if a song is valid and inform the user if it isn't.
		def valid_song?(song)
			if song.valid?
				true
			else
				respond("As sick as this track is, it's too long man. Max length is #{MAX_SONG_LENGTH} seconds.")
				false
			end
		end

		# Sends a message to the channel
		def respond(message)
			@channel.send_message(message) if @channel
		end

		# Destroys voice connection after it has been inactive for more than 60 seconds
		def afk_timer
			Thread.new do
				counter = 0
				loop do
					# Reset counter to zero
					if @playing || @voice.nil?
						counter = 0
						sleep(10)
					else
						counter += 1
					end

					#Nothing was played for more than 60 seconds.
					if counter >= 6
						counter = 0
						disconnect("Hey man, I've got no requests, I'm bouncing. Use `leave` next time homie.")
					else
						sleep(10)
					end
				end

				nil
			end
		end

		def clean_directory
			Dir.foreach(@server_dir) do |file|
				fn = File.join(@server_dir, file)
				File.delete(fn) if fn[-1] != '.'
			end
		end
	end
end
end
