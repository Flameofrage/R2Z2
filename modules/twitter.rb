module R2Z2
	class R2Z2Twitter
    def initialize(username)
        @username = username
        @id = 0
				@streamer_hash = YAML.load_file("#{Dir.pwd}/data/streamers.yaml")
    end

    def IDLookUp
      light = Excon.get('https://api.twitch.tv/kraken/users',
        :headers => {'Client-ID' => 'mglfxs09bl7fgw3zfm3ppa73e7qbjy', 'Accept' => 'application/vnd.twitchtv.v5+json'},
        :query => {:login => @username},
        :method => 'GET')
      name = JSON.parse(light.body)
      @id = name["users"][0]["_id"].to_i
			@streamer_hash[@username] = @id 
    end

    if streamers.key?(uname) != true
      streamers[uname] = @id
    end

    def StreamStatus
      dark = Excon.get('https://api.twitch.tv/kraken/streams/' + @id.to_s,
        :headers => {'Client-ID' =>  'mglfxs09bl7fgw3zfm3ppa73e7qbjy', 'Accept' => 'application/vnd.twitchtv.v5+json'},
        :method => 'GET')
      status = JSON.parse(dark.body)
    end
	end
end
