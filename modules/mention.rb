module R2Z2
  module DiscordCommands
    module Mention
      extend Discordrb::EventContainer

      message(contains: /(r2)/i) do |event|
        event.respond "Beep Beep"
      end
    end
  end
end
