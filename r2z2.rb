require 'discordrb'
require 'yaml'

module R2Z2

	# Bot Config file
	CONFIG = YAML.load_file('data/config.yaml')

	# Bot Config
	R2Z2 = Discordrb::Commands::CommandBot.new(token: CONFIG['token'], 
						   client_id: CONFIG['client_id'],
						   prefix: CONFIG['prefix'],
					  	   ignore_bots:	true,
						   command_doesnt_exist_message: "Wrong command foo. Check !help"  )


	# R2Z2 Modules
	Dir['modules/*.rb'].each { |mod| require_relative mod; puts "Loaded: #{mod}" }

	modules = [
		Commands
	]
	
	modules.each { |m| R2Z2.include! m; puts "Included: #{m}" }

	#Limit bucket
	R2Z2.bucket :limit, limit: 6, time_span: 60, delay: 10

	#Run this noise
	R2Z2.run :async
	R2Z2.sync
end
