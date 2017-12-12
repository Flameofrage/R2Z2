module R2Z2
  module DiscordCommands
    module Invite
      extend Discordrb::Commands::CommandContainer
     command(:invite, bucket: :limit, description: 'Invite R2Z2 to your channel') do |event|
        event.respond "Invite me via #{R2Z2.invite_url}"
      end
    end
  end
end 
