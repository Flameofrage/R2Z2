module R2Z2
  module DiscordCommands
    module Roll
      extend Discordrb::Commands::CommandContainer
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
    end
  end
end 
