module R2Z2
  module DiscordCommands
    module Volume
      extend Discordrb::Commands::CommandContainer
      command(:volume, description: 'Sets the volume for R2.', usage: 'volume [0.5, 1, 2]', min_args: 1) do |event, volume|
        event.server.music_player.volume(volume.to_f, event.server.id)
        event.voice.volume = volume.to_f
        event << "Volume has been set to #{volume}"
      end
    end
  end
end
