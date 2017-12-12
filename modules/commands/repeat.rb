module R2Z2
  module DiscordCommands
    module Repeat
      extend Discordrb::Commands::CommandContainer
      command(:repeat, description: 'Toggles repeat.', required_permissions: [:manage_server]) do |event|
        event.server.music_player.repeat = !event.server.music_player.repeat
        "Repeat is now #{bool_to_words(event.server.music_player.repeat)}."
      end
    end
  end
end 
