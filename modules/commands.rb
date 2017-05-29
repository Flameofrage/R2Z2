module R2Z2
	module Commands
	        extend Discordrb::Commands::CommandContainer
		extend Discordrb::EventContainer
		command(:ping) do 
			event.respond "Pong!"
		end
		command(:invite) do
			event.respond "Invite me via #{R2Z2.invite_url}"
		end
	end
end
