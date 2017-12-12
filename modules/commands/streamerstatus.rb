module R2Z2
  module DiscordCommands
    module StreamerStatus
      extend Discordrb::Commands::CommandContainer
        command(:streamerstatus, description: 'Checks the status of a streamer', usage: 'streamerstatus <username>', min_args: 1) do |event, name|
          if name.is_a? String
            STREAMER.IDLookUp(name)
            event << STREAMER.StreamStatus
          else
            event << "Enter a valid username"
          end
        end
    end
  end
end 
