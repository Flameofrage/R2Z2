module R2Z2
  module DiscordCommands
    module Repair
      extend Discordrb::Commands::CommandContainer
      command(:repair) do |event|
        break unless event.user.id == 216142038574301195
        if MAINT.repair['repair'] == 0
          m = Hash['repair' => 1]
          MAINT.update(m)
          event << "Maintenance mode enabled"
        else
          m = Hash['repair' => 0]
          MAINT.update(m)
          event << "Maintenance mode disabled"
        end
      end
    end
  end
end 
