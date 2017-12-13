module R2Z2
  module DiscordCommands
    module AddStreamer
      extend Discordrb::Commands::CommandContainer
      command(:addstreamer, description: 'Adds a streamer', usage: 'addstreamer <username>', min_args: 1) do |event, name|
        if (name.is_a? String) and !(STREAMER_HASH.streamer_hash.include? name.downcase)
          STREAMER.IDLookUp(name)
          STREAMER.AddStreamer(event.server.id)
          event << "I've added " + name.downcase + " to the list of streamers"
        else
          event << "Enter a valid username"
        end
      end
    end
  end
end
