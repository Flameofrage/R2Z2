module R2Z2
  module DiscordCommands
    module Exit
      extend Discordrb::Commands::CommandContainer
      command(:exit, help_available: false) do |event|
        break unless event.user.id == 216142038574301195
         R2Z2.send_message(event.channel.id, 'Beep')
        exit
      end
    end
  end
end 
