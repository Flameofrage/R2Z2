module R2Z2
  class TwitchList
    attr_accessor :twitch_list

    def initialize
      STREAM_DATA.stream_data.keys.map do |key|
        if STREAM_DATA.stream_data[key]["streamers"].nil?
          @twitch_list = STREAM_DATA.stream_data.tap { |hs| hs.delete(key) }
        end
      end
    end

    def update
      STREAM_DATA.stream_data.keys.map do |key|
        if STREAM_DATA.stream_data[key]["streamers"].nil?
          @twitch_list = STREAM_DATA.stream_data.tap { |hs| hs.delete(key) }
        end
      end
    end
  end
end
