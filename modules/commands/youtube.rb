module R2Z2
  module DiscordCommands
    module Youtube
      extend Discordrb::Commands::CommandContainer
      command(:yt, description: 'Finds youtube videos.', min_args: 1, usage: 'yt <query>') do |event, *query|
        video = GOOGLE.find_video(query.join(' '))
        if video
          $stats["videos_found"] += 1
          event << "https://youtu.be/#{video}"
        else
          'Such video does not exist.'
        end
      end
    end
  end
end 
