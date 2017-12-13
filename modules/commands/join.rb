module R2Z2
  module DiscordCommands
    module Join
      extend Discordrb::Commands::CommandContainer
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
          unless STREAM_DATA.stream_data[event.server.id].nil?
            event.voice.volume = STREAM_DATA.stream_data[event.server.id]['volume']
          else
            event.voice.volume = 0.5
            event << "Please be sure to set the volume for this server with <!volume>"
          end
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
    end
  end
end
