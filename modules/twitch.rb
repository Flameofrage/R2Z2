module R2Z2
  class R2Z2Twitch
 
    def initialize
      @username = 'blarg'
      @id = 0
      @counter = Hash.new(0)
      @states = Hash.new(false)
      @link = Excon.new('https://api.twitch.tv',
                        :headers =>  { 'Client-ID' => CONFIG.twitch_client_id, 'Accept' => 'application/vnd.twitchtv.v5+json' },
                        :persistent => true,
                        :method => 'GET')
    end
 
    def save_to_file(file, object)
      File.open(file, 'w') do |f|
        f.write YAML.dump(object)
      end
    end
 
    def IDLookUp(username)
      @username = username
      twitchid = @link.get(:query => { :login => @username },
                            :path => '/kraken/users')
      name = JSON.parse(twitchid.body)
      @id = name['users'][0]['_id'].to_i
    end
 
    def started_streaming?
      truestat = @link.get(:path => '/kraken/streams/' + @id.to_s)
      stat = JSON.parse(truestat.body)
      if stat['stream']
        # They are streaming
        # Return false if we already know they're streaming
        return false if @states[@id]
 
        # If we got this far, they must have just started.
        # Cache the new state and return true
        @states[@id] = true
      else
        # They aren't streaming
        # Ensure this is cached
        @states[@id] = false
      end
    end

    def StreamStatus
      twitchstatus = @link.get(:path => '/kraken/streams/' + @id.to_s)
      status = JSON.parse(twitchstatus.body)
      s = status['stream']
      if !s.nil?
        game = status['stream']['game']
        url = status['stream']['channel']['url']
        stream = 'Currently, ' + @username + ' is streaming ' + game + ' at <' + url + '>'
      else
        stream = 'Currently, ' + @username + ' is offline'
      end
    end

    def AddStreamer(server)
      unless STREAM_DATA.stream_data[server]["streamers"].include? @username
        new_streamer = { server => { "streamers" => { @username => @id } } }
        m = STREAM_DATA.stream_data.merge!(new_streamer) { |_key, left, right| left.merge!(right) { |_2key, ll, rr| ll.merge!(rr) } }
        STREAM_DATA.add(m)
        unless STREAMER_HASH.streamer_hash.include? @username
          n = STREAMER_HASH.streamer_hash.merge!(new_streamer[server]['streamers']) { |_key, left, right| left.merge!(right) }
          STREAMER_HASH.add(n)
        end
        return nil
      end
    end
  end
end
