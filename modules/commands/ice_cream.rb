module R2Z2
  module DiscordCommands
    module IceCream
      extend Discordrb::Commands::CommandContainer
      command(:ice_cream, description: 'Gives out ice cream') do |event|
        event.respond ":ice_cream: :ice_cream:"
      end
    end
  end
end 
