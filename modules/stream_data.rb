module R2Z2
  class StreamData
    attr_accessor :stream_data

    def initialize
      @stream_data = YAML.load_file("#{Dir.pwd}/data/stream_data.yaml")
    end

    def delete_streamer(name, server)
      @stream_data[server]["streamers"].delete(name)
      open("#{Dir.pwd}/data/stream_data.yaml", "w") { |f| f.write(@stream_data.to_yaml) }
      TWITCH_LIST.update
      return nil
    end

    def add_streamer(hash)
      @stream_data = hash
      open("#{Dir.pwd}/data/stream_data.yaml", "w") { |f| f.write(@stream_data.to_yaml) }
      TWITCH_LIST.update
      return nil
    end

    def update_server(hash)
      @
    end
    def previews_update(server)
      previews = { server => {'previews' => 1 }}
      if @stream_data[server]["previews"].nil?
        @stream_data.merge!(previews) { |_key, left, right| left.merge!(right) }
      else
        if @stream_data[server][previews] == 1
          @stream_data[server][previews] = 0
        else
          @stream_data[server][previews] = 1
        end
      end
    end
  end
end
