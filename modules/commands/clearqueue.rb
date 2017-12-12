module R2Z2
  module DiscordCommands
    module ClearQueue
      extend Discordrb::Commands::CommandContainer
      command(:clearqueue, description: 'Deletes songs from server queue.', usage: 'clearqueue <index/all>', required_permissions: [:manage_server], min_args: 1) do |event, argument|
        if argument.chomp == 'all'
          event.server.music_player.disconnect
        elsif argument.to_i.between?(1, event.server.music_player.queue.length)
          index = argument.to_i - 1
          if index.zero?
            event.voice.stop_playing
            event.server.music_player.repeat = false
          else
            event.server.music_player.delete_song_at(index)
          end
        elsif !argument.to_i.between?(1, event.server.music_player.queue.length)
          next "Can't find song with such index"
        else
          next 'Unknown argument, use `all` or song index.'
        end
        nil
      end
    end
  end
end 
