class EventsController < ApplicationController
  before_action :set_event, only: [:destroy]

  # POST /events.json
  def create
    start_date = Date.parse(params[:event][:start_date])
    end_date = Date.parse(params[:event][:end_date])
    w_days = params[:event][:reccurring_days]
    params['event']['reccurring_days'] = params['event']['reccurring_days'].to_s

    if params['event']['event_id'].blank?
      @event = Event.new(event_params)
      @event.parent_id = 0
      respond_to do |format|
        if @event.save
          d = start_date
          while d <= end_date
            if w_days.include? d.wday.to_s
              event = Event.new(event_params) 
              event.start_date =  d.strftime("%Y-%m-%d")
              event.end_date = d.strftime("%Y-%m-%d")
              event.parent_id = @event.id
              event.save
            end
            d += 1
          end  
          format.html { redirect_to root_url, notice: 'Event was successfully added.' }
        else
          format.html { redirect_to root_url, notice: 'Event was not added.' }
        end
      end
    else
      @event = Event.find(params[:id])
      Event.where(:parent_id => @event.id).destroy_all
      respond_to do |format|
        if @event.save
          d = start_date
          while d <= end_date
            if w_days.include? d.wday.to_s
              Event.new(event_params)
              Event.start_date =  d.strftime("%Y-%m-%d")
              Event.end_time = ""
              Event.parent_id = @event.id
            end
            d += 1
          end  
          format.html { redirect_to root_url, notice: 'Event was successfully updated.' }
        else
          format.html { redirect_to root_url, notice: 'Event was not updated.' }
        end
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Event was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :event_type, :start_date, :end_date, :reccurring_days,:start_time,:end_time)
    end
end
