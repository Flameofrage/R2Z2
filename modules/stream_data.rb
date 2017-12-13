module R2Z2
  class StreamData
    attr_accessor :stream_data

    def initialize
      @stream_data = YAML.load_file("#{Dir.pwd}/data/stream_data.yaml")
    end

    def update(hash)
      @stream_data = hash
      open("#{Dir.pwd}/data/stream_data.yaml", "w") { |f| f.write(@stream_data.to_yaml) }
      return nil
    end
  end
end
