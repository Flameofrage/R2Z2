module R2Z2
	module Commands
	        extend Discordrb::Commands::CommandContainer
		extend Discordrb::EventContainer
		command(:ping, bucket: :limit, description: 'Responds with pong') do |event| 
			event.respond "Pong!"
		end
		command(:invite, bucket: :limit, description: 'Invite R2Z2 to your channel') do |event|
			event.respond "Invite me via #{R2Z2.invite_url}"
		end
		command(:userlist, bucket: :limit, description: 'Lists users hopefully') do |event|
			event.respond "Here, #{R2Z2.users}"
		end

		command(:fish, bucket: :limit, description: 'Apply directly to the forehead') do |event|
			members = event.server.online_members
			members.reject!(&:current_bot?).map! { |m| "#{m.id}" }
			event.respond "*slaps around <@#{members.sample}> with a large trout*"	
		end

	end
end
