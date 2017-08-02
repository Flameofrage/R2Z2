module R2Z2
require 'excon'
require 'json'
	class R2Z2Twitch
		def initialize(username)
        @username = username
        @id = 0
    end

    def IDLookUp
      light = Excon.get('https://api.twitch.tv/kraken/users',
        :headers => {'Client-ID' => 'mglfxs09bl7fgw3zfm3ppa73e7qbjy', 'Accept' => 'application/vnd.twitchtv.v5+json'},
        :query => {:login => @username},
        :method => 'GET')
      name = JSON.parse(light.body)
      @id = name["users"][0]["_id"].to_i
			unless $streamer_hash.include? @username
				new_streamer = { @username => @id }
				$streamer_hash.merge!(new_streamer)
			end
    end

    def StreamStatus
      dark = Excon.get('https://api.twitch.tv/kraken/streams/' + @id.to_s,
        :headers => {'Client-ID' =>  'mglfxs09bl7fgw3zfm3ppa73e7qbjy', 'Accept' => 'application/vnd.twitchtv.v5+json'},
        :method => 'GET')
      status = JSON.parse(dark.body)
			s = status["stream"]
			if s != nil
				game = status["stream"]["game"]
				url = status["stream"]["channel"]["url"]
				stream = "Currently, " + @username + " is streaming " + game + " at " + url
			else
				stream = "Currently, " + @username + " is offline"
			end
    end
	end
end
