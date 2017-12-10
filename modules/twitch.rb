module R2Z2
  require 'excon'
    require 'json'
      class R2Z2Twitch
        @@states = Hash.new(false)
        @@link = Excon.new('https://api.twitch.tv',
                           :headers =>  { 'Client-ID' => $twitch_client_id, 'Accept' => 'application/vnd.twitchtv.v5+json' },
                           :persistent => true,
                           :method => 'GET')

        def initialize(username, *server_id)
          @username = username
          @server_id = server_id
          @id = 0
          @counter = Hash.new(0)
        end

        def save_to_file(file, object)
          File.open(file, 'w') do |f|
            f.write YAML.dump(object)
          end
        end

        def IDLookUp
          twitchid = @@link.get(:query => { :login => @username },
                                :path => '/kraken/users')
          name = JSON.parse(twitchid.body)
          @id = name['users'][0]['_id'].to_i
        end

        def started_streaming?
          truestat = @@link.get(:path => '/kraken/streams/' + @id.to_s)
          stat = JSON.parse(truestat.body)
          if stat['stream']
            # They are streaming
            # Return false if we already know they're streaming
            return false if @@states[@id]

            # If we got this far, they must have just started.
            # Cache the new state and return true
            @@states[@id] = true
          else
            # They aren't streaming
            # Ensure this is cached
            @@states[@id] = false
          end
        end

        def StreamStatus
          twitchstatus = @@link.get(:path => '/kraken/streams/' + @id.to_s)
          status = JSON.parse(twitchstatus.body)
          s = status['stream']
          p s
          if !s.nil?
            game = status['stream']['game']
            url = status['stream']['channel']['url']
            stream = 'Currently, ' + @username + ' is streaming ' + game + ' at <' + url + '>'
          else
            stream = 'Currently, ' + @username + ' is offline'
          end
        end

        def AddStreamer
          server = @server_id.join.to_i 
          unless $stream_data[server]["streamers"].include? @username
            new_streamer = { "streamers" => { @username => @id } }
            $stream_data[server].merge!(new_streamer) { |_key, left, right| left.merge!(right) }
            open("#{Dir.pwd}/data/stream_data.yaml", 'w') { |f| f.write($stream_data.to_yaml) }
            unless $streamer_hash.include? @username
              $streamer_hash.merge!(new_streamer) { |_key, left, right| left.merge!(right) }
              open("#{Dir.pwd}/data/streamers.yaml", 'w') { |f| f.write($streamer_hash.to_yaml) }
            end
            return nil
          end
        end
      end
end
