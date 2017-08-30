module R2Z2
  module Commands
  module Add
    extend Discordrb::Commands::CommandContainer
    command(:ping, bucket: :limit, description: 'Responds with pong') do |event| 
      event.respond "Pong!"
    end
    
    command(:invite, bucket: :limit, description: 'Invite R2Z2 to your channel') do |event|
      event.respond "Invite me via #{R2Z2.invite_url}"
    end
    
    command(:fish, bucket: :limit, rate_limit_message: '%User%, quit being a dick for %time% more seconds.', description: 'Apply directly to the forehead') do |event|
      members = event.server.online_members
      members.reject!(&:current_bot?).map! { |m| "#{m.id}" }
      event.respond "*slaps around <@#{members.sample}> with a large trout*"	
    end

    command(:search, description: 'Performs a duckduckgo search', usage: 'search <query>', min_args: 1) do |event, term|
      ddg = DuckDuckGo.new
      search = ddg.zeroclickinfo(term)
      event << search.related_topics["_"][0].text
    end

		command(:addstreamer, description: 'Adds a streamer', usage: 'addstreamer <username>', min_args: 1) do |event, name|
			if name.is_a? String
				streamer = R2Z2Twitch.new(name)
				streamer.IDLookUp
				event << "I've added " + name + " to the list of streamers"
			else
				event << "Enter a valid username"
			end 
		end
		
		command(:allstream, description: 'Checks all streamers', usage: 'allstream') do |event|
			$streamer_hash.each do |key, value|
				streamer = R2Z2Twitch.new(key)
				streamer.IDLookUp
				event << streamer.StreamStatus
			end
			return nil
		end

		command(:streamerstatus, description: 'Checks the status of a streamer', usage: 'streamerstatus <username>', min_args: 1) do |event, name|
			if name.is_a? String
				streamer = R2Z2Twitch.new(name)
				streamer.IDLookUp
				event << streamer.StreamStatus
			else
				event << "Enter a valid username"
			end
		end

    command(:roll, description: 'Rolls a number of dice', usage: 'roll <number> <number>') do |event, number, num2|
      if number.to_i.is_a? Numeric
        if num2.to_i.is_a? Numeric
          if number.to_i > 100
            event << "No, fuck you."
          else
            event << "Rolling #{number}d#{num2}"
            event <<  number.to_i.times.map{ 1 + Random.rand(num2.to_i) }
          end
        else
          event << "I need numbers please."
        end
      else
        event << "I need numbers please."
      end
    end

    command(:stats, description: 'Shows bot statistics') do |event|
      ping = ((Time.now - event.timestamp) * 1000).to_i
			event << "Servers: #{$stats["servers"]}."
      event << "Users: #{$stats["users"]}."
      event << "Times mentioned: #{$stats["mentions"]}."
      event << "Uptime: #{$stats["uptime"]}."
      event << "Urls shortened: #{$stats["urls_shortened"]}."
      event << "Youtube videos found: #{$stats["videos_found"]}"
      event << "Songs played: #{$stats["songs_played"]}"
      event << "Messages read: #{$stats["messages_read"]}."
			event << "Ping: #{ping}ms."
    end

    command(:queue, description: 'Displays current music queue.') do |event|
      if event.server.music_player.queue.empty?
        'Queue is empty, use `add` to add more songs.'
      else
        "`#{event.server.music_player.table}`"
      end
    end

    command(:repeat, description: 'Toggles repeat.', required_permissions: [:manage_server]) do |event|
      event.server.music_player.repeat = !event.server.music_player.repeat
      "Repeat is now #{bool_to_words(event.server.music_player.repeat)}."
    end

    command(:skip, description: 'Skips current song.', required_permissions: [:manage_server]) do |event|
      break if event.server.music_player.queue.empty? || !event.server.music_player.playing?

      event.server.music_player.skip = true
      event.voice.stop_playing if event.voice
      nil
    end

    command(:yt, description: 'Finds youtube videos.', min_args: 1, usage: 'yt <query>') do |event, *query|
      video = GOOGLE.find_video(query.join(' '))
      if video
				$stats["videos_found"] += 1
        event << "https://youtu.be/#{video}"
      else
        'Such video does not exist.'
      end
    end

    command(:musichelp, description: 'Displays information on how to use music features.') do |event|
      event << 'To start using music bot a user with `manage server` permission has to invite it to a channel by using `join` command.'
      event << 'Then you can add songs by using `add` command.'
      event << 'Use `queue` command to see added songs.'
      event << 'Users with `manage server` permission can remove songs from queue by using `clearqueue <id>` command.'
      event << 'Each song will start playing automaticlly after the last one finishes.'
      event << "If you're not using music bot features anymore use `leave` command."
      event << 'You can find more help for each of these commands by using `help <commandname>` command.'
    end

    command(:clearqueue, description: 'Deletes songs from server queue.', usage: 'clearqueue <index/all>', required_permissions: [:manage_server], min_args: 1) do |event, argument|
      if argument.chomp == 'all'
        event.server.music_player.disconnect
      elsif argument.to_i.between?(1, event.server.music_player.queue.length)
        index = argument.to_i - 1
        if index.zero?
          event.voice.stop_playing
          event.server.music_player.repeat = false
        else
          event.server.music_player.delete_song_at(index)
        end
      elsif !argument.to_i.between?(1, event.server.music_player.queue.length)
        next "Can't find song with such index"
      else
        next 'Unknown argument, use `all` or song index.'
      end
      nil
    end

    #Makes R2 Leave a voice channel
    command(:leave, description: 'Makes the bot leave your voice channel.', required_permissions: [:manage_server]) do |event|
      event.server.music_player.disconnect
      nil
    end
    
    #Makes R2 join voice channel
    command(:join, description: 'Makes the bot join your voice channel.', required_permissions: [:manage_server]) do |event|
      channel = event.user.voice_channel

      # Check if channel is valid.
      if !channel || channel == event.server.afk_channel
        next 'First join a valid voice channel.'
      end

      # Try to join the voice channel.
      begin
        event.bot.voice_connect(channel)
        event.voice.encoder.use_avconv = true
      rescue Discordrb::Errors::NoPermission
        next 'Please make sure I have permission to join this channel.'
      end

      # Set voice object that should be used for playback.
      event.server.music_player.voice = event.voice

      # Set channel that should be used for bot responses.
      event.server.music_player.channel = event.channel

      LOGGER.debug "Music bot joined #{event.channel.id}."
      "Joined \"#{channel.name}\". Use `add` command if you want to add songs to queue."
    end
   
		command(:exit, help_available: false) do |event|
			break unless event.user.id == 216142038574301195

			R2Z2.send_message(event.channel.id, 'Beep')
			exit
		end

		# Adds a song to server queue and starts playing it.
    command(:add, description: 'Adds a song to server queue and starts playing it.', usage: 'add <query>', min_args: 1) do |event, *query|
      if !event.voice
        next 'First make me join your voice channel by using `join` command.'
      elsif event.server.music_player.queue.length >= MusicBot::MAX_SONGS_IN_QUEUE
        next 'Music music queue is too long.'
      end

      # Find the video and let user know if it does not exist.
      query = query.join(' ')
      video_id = GOOGLE.find_video(query)
      next 'Such video does not exist.' unless video_id

      # Download the song and add it to queue.
      # If this succeeds then start playing it unless music is already being played.
      if event.server.music_player.add(video_id)
				$stats["songs_played"] += 1
        event.server.music_player.start_loop unless event.server.music_player.playing?
      end
      nil
      end
    end
  end
end
