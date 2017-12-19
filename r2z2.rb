require 'discordrb'
require 'yaml'
require 'fileutils'
require 'open-uri'
require 'uri'
require 'duck_duck_go'
require 'bundler/setup'
require 'google/apis/youtube_v3'
require 'rufus-scheduler'
require 'google/apis/urlshortener_v1'
require 'excon'
require 'json'

Bundler.require(:default)


#Methods pulled from sapphire_bot just in case

module Kernel
# Runs a block with warning messages supressed.
	def run_supressed(&block)
		original_verbosity = $VERBOSE
		$VERBOSE = nil
		yield block
		$VERBOSE = original_verbosity
	end

# Converts seconds to human readable format.
	def time_in_words(time)
		days = (time / 86_400).to_i
		time -= days * 86_400
		hours = (time / 3600).to_i
		time -= hours * 3600
		minutes = (time / 60).to_i
		string = "#{days} day#{'s' unless days == 1},"
		string << " #{hours} hour#{'s' unless hours == 1},"
		string << " #{minutes} minute#{'s' unless minutes == 1}"
	end

# Converts boolean values to more appealing format.
# Possible modes: on, enabled.
	def bool_to_words(bool, mode = :on)
		case mode
		when :on
			string_if_true = 'on'
			string_if_false = 'off'
		when :enabled
			string_if_true = 'enabled'
			string_if_false = 'disabled'
		else
			raise ArgumentError
		end

		return string_if_true if bool
			string_if_false
	end

	# Returns true if specified url string is valid.
	def valid_url?(url)
		uri = URI.parse(url)
		return true if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
		false
	rescue
		false
	end

	# Returns urls host.
	def url_host(url)
		URI.parse(url).host
	rescue
		nil
	end

# Generates a random string with default length of 10.
	def rand_string(length = 10)
		rand(36**length).to_s(36)
	end
end

module R2Z2
  module StoreData
    def save_to_file(file, object)
      File.open(file, 'w') do |f|
        f.write YAML.dump(object)
      end
    end

    def load_file(file)
      return YAML.load_file(file) if File.exist?(file)
      {}
    end
  end

  # R2Z2 Modules
  Dir['modules/*.rb'].each { |mod| load mod }

  # Load Music Modules
  Dir['music_bot/*.rb'].each { |mod| load mod }

  # R2Z2 Configuration
  CONFIG = Config.new

  # Load Music Extension Modules
  Dir['music_bot/extensions/*.rb'].each { |mod| load mod }

  # Streamer List 
  STREAMER_HASH = StreamerHash.new

  # Stream Data
  STREAM_DATA = StreamData.new

  # Maintenance Mode
  MAINT = Repair.new

  # Twitch
  STREAMER = R2Z2Twitch.new

  # Rufus Scheduler
  TIMER = Rufus::Scheduler.new

  # Bot Config
  R2Z2 = Discordrb::Commands::CommandBot.new(token:       CONFIG.token,
                                             client_id:   CONFIG.client_id,
                                             prefix:      CONFIG.prefix,
                                             ignore_bots: false)

  # Commands

  run_supressed { Discordrb::LOG_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S' }

  debug = ARGV.include?('-debug') ? :debug : false
  log_streams = [STDOUT]

  if debug
  	timestamp = Time.now.strftime(Discordrb::LOG_TIMESTAMP_FORMAT).tr(':', '-')
  	log_file = File.new("#{Dir.pwd}/logs/#{timestamp}.log", 'a+')
  	log_streams.push(log_file)
  end
 
  run_supressed { LOGGER = Discordrb::LOGGER = Discordrb::Logger.new(nil, log_streams) }
 
  LOGGER.debug = true if debug
 
 
  # Stats Variable
  $stats = YAML.load_file("#{Dir.pwd}/data/stats.yaml")
 

  # Commands
  module DiscordCommands; end
  Dir['modules/commands/*.rb'].each { |mod| load mod }
  DiscordCommands.constants.each do |mod|
    R2Z2.include_commands DiscordCommands.const_get mod
  end
 
  #modules.each { |m| R2Z2.include! m; puts "Included: #{m}" }

  GOOGLE = GoogleServices.new
  # STATS = Stats.new

	#Limit bucket
	R2Z2.bucket :limit, limit: 6, time_span: 60, delay: 10

	#Run this noise
	R2Z2.run :async
	R2Z2.sync
end
