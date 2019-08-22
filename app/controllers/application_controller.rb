class ApplicationController < ActionController::Base
	def index
		events = Event.all
		@events = Array.new
		events.each do |event|
			ev = Hash.new
			ev['id'] = event.id
			ev['title'] = event.title
			ev['extendedProps'] = { 'type' => event.event_type}
			ev['allDay'] = true
			if event.event_type == 'single'
				ev['start'] = event.start_date
				ev['end'] = event.end_date
			elsif event.event_type == 'recurring'
				if event.reccurring_days != ""
					ev['extendedProps']['reccurring_days'] = JSON.parse(event.reccurring_days)
					ev['daysOfWeek'] = JSON.parse(event.reccurring_days)
				else
					ev['extendedProps']['reccurring_days'] = ["0"]
					ev['daysOfWeek'] = ["0"]
				end
				ev['extendedProps']['start_date'] = event.start_date
				ev['extendedProps']['end_date'] = event.end_date
				# raise event.reccurring_days.inspect
				
				# raise ev['daysOfWeek'].inspect
				ev['startRecur'] = event.start_date
				ev['endRecur'] = event.end_date
			end
			@events.push(ev)
		end
		# raise @events.inspect
		@event = Event.new
	end
end
