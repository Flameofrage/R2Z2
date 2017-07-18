Module R2Z2
  Module Events
    Module Ping
      extend Discordrb::EventContainer
	R2Z2.message(with_text: 'Ping!') do |event|
	event.respond 'Pong!'
      end
    end
  end
end
