module R2Z2
  module DiscordCommands
    module Preview
      extend Discordrb::Commands::CommandContainer
      command(:preview, description: 'Enables/Disables Preview for Twitch Notifications for R2.', usage: 'preview', min_args: 0) do |event|
        STREAM_DATA.previews_update(event.server.id)
        if STREAM_DATA.stream_data[event.server.id][previews] == 1
          event << "Previews have been enabled"
        else
          event << "Previews have been disabled"
        end
      end
    end
  end
end
