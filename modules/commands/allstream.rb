module R2Z2
  module DiscordCommands
    module AllStream
      extend Discordrb::Commands::CommandContainer
      command(:allstream, description: 'Checks all streamers', usage: 'allstream') do |event|
        STREAM_DATA.stream_data[event.server.id]['streamers'].each do |key, value|
          STREAMER.IDLookUp(key)
          event << STREAMER.StreamStatus
        end
        return nil
      end
    end
  end
end 
