module R2Z2
  class StreamerHash
    attr_accessor :streamer_hash

    def initialize
      @streamer_hash = YAML.load_file("#{Dir.pwd}/data/streamers.yaml")
    end

    def update(name)
      @streamer_hash.delete(name)
      open("#{Dir.pwd}/data/streamers.yaml", "w") { |f| f.write(@streamer_hash.to_yaml) }
      return nil
    end
  end
end
