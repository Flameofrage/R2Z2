module R2Z2
  module DiscordCommands
    module Fish
      extend Discordrb::Commands::CommandContainer
      command(:fish, bucket: :limit, rate_limit_message: '%User%, quit being a dick for %time% more seconds.', description: 'Apply directly to the forehead') do |event|
        members = event.server.online_members
        members.reject!(&:current_bot?).map! { |m| "#{m.id}" }
        event.respond "*slaps around <@#{members.sample}> with a large trout*"
      end
    end
  end
end 
