module R2Z2
require 'excon'
require 'json'
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

    def StreamStatus
      dark = Excon.get('https://api.twitch.tv/kraken/streams/' + @id.to_s,
        :headers => {'Client-ID' =>  'mglfxs09bl7fgw3zfm3ppa73e7qbjy', 'Accept' => 'application/vnd.twitchtv.v5+json'},
        :method => 'GET')
      status = JSON.parse(dark.body)
			s = status["stream"]
			if s != nil
				puts "Currently, " + @username + " is streaming " + status["stream"]["game"] + " at " + status["channel"]["url"]
			else
				puts "Currently, " + @username + " is offline"
			end
    end
	end
end
