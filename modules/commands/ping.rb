module R2Z2
  module DiscordCommands
    module Ping
      extend Discordrb::Commands::CommandContainer
      command(:ping, bucket: :limit, description: 'Responds with pong') do |event|
        "Pong!"
      end
    end
  end
end 
