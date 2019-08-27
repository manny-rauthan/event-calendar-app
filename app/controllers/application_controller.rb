class ApplicationController < ActionController::Base
	def index
		events = Event.where.not(parent_id: 0).all
		@events = Array.new
		events.each do |event|
			ev = Hash.new
			ev['id'] = event.id
			ev['title'] = event.title
			ev['extendedProps'] = { 'type' => event.event_type,'start_time' => event.start_time,'end_time' => event.end_time}
			ev['allDay'] = true
			ev['start'] = event.start_date
			ev['end'] = event.end_date
			if event.event_type == 'recurring'
				if event.reccurring_days != ""
					ev['extendedProps']['reccurring_days'] = JSON.parse(event.reccurring_days)
				else
					ev['extendedProps']['reccurring_days'] = ["0"]
				end
			end
			@events.push(ev)
		end
		# raise @events.inspect
		@event = Event.new
	end
end
