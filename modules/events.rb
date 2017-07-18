module R2Z2
  module Events
    module Mention
      extend Discordrb::EventContainer
      mention do |event|
	event.respond("Beep beep")
        STATS.mentions += 1
      end
    end
  end
end
