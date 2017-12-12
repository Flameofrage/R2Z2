module R2Z2
  module DiscordCommands
    module Eval
      extend Discordrb::Commands::CommandContainer
      command(:eval, help_available: true) do |event, *code|
        break unless event.user.id == 216142038574301195
          begin
            eval code.join(' ')
          rescue
            'An error occurred 😞'
          end
      end
    end
  end
end 
