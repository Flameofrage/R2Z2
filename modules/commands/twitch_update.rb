module R2Z2
  module DiscordCommands
  #Checks Twitch for currently running streamers
    module TwitchUpdate
      TIMER.cron '*/2 * * * *' do
        message = STREAMER_HASH.streamer_hash.keys.map do |key|
          STREAMER.IDLookUp(key)
          STREAMER.StreamStatus if STREAMER.started_streaming?
        end.compact.join("\n")
        TWITCH_LIST.twitch_list.keys.map do |key|
          true_message = STREAM_DATA.stream_data[key]["streamers"].keys.each do |x|
            message.split("\n").grep /(#{x})/
          end.compact.join(". ")
          s = STREAM_DATA.stream_data[key]["notification_channel"]
          R2Z2.send_message(s, true_message)
        end
      end
    end
  end
end
