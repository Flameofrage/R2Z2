module R2Z2
  module DiscordCommands
    module AddRole
      extend Discordrb::Commands::CommandContainer
      command(:add_role, description: 'Enables easily adding a user to a list of roles', usage: 'add_role user role') do |event, _mention, *role_name|
        break unless [289607519154864128, 289606790767837184].any? { |id| event.user.role?(id) }
        role = event.server.roles.find { |r| r.name == role_name.join(' ') }
        next "Role not found: #{role_name.join(' ')}" unless role
        member = event.message.mentions.first.on(event.server)
        member.add_role(role)
        "I've added that user to #{role_name.join(' ')}"
      end
    end
  end
end
