module R2Z2
  module DiscordCommands
    module Volume
      extend Discordrb::Commands::CommandContainer
      command(:twitchchannel, description: 'Sets the twitch notification channel for R2.', usage: 'twitchchannel <channel id>', min_args: 1) do |event, channel|
        STREAMER.nc(channel, event.server.id)
        event << "Twitch notifications channel has been set to <channel>"
      end
    end
  end
end
