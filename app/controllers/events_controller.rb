class EventsController < ApplicationController
  # POST /events.json

  before_action :set_event, only: ['destroy']
  def create

    w_days = params[:event][:reccurring_days]
    params['event']['reccurring_days'] = params['event']['reccurring_days'].to_s
  
    if params['event']['event_id'].blank?
      start_date = Date.parse(params[:event][:start_date])
      
      @event = Event.new(event_params)
      @event.parent_id = 0
      
      if params[:event][:event_type] == 'single'
        end_date =start_date
        @event.end_date = start_date
      else
        end_date = Date.parse(params[:event][:end_date]) 
      end

      respond_to do |format|
        if @event.save
          d = start_date
          if @event.start_date != @event.end_date
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
          end
          format.html { redirect_to root_url, notice: 'Event was successfully added.' }
        else
          format.html { redirect_to root_url, notice: 'Event was not added.' }
        end
      end
    else
      @child = Event.find(params[:event][:event_id])
      @parent = Event.find(@child.id)
      if @child.event_type === 'single'
        if @child.update(event_params)
          redirect_to root_url, notice: 'This Event was successfully updated.' 
        else
          redirect_to root_url, notice: 'This Event was not updated.' 
        end
      else
        start_date = Date.parse(@parent.start_date.to_s)
        if params[:edit_as] === 'single'
          @child = Event.find(params[:event][:event_id])
          @child.start_time = params[:event][:start_time]
          @child.end_time = params[:event][:end_time]
          @child.title = params[:event][:title]
          if @child.save
            redirect_to root_url, notice: 'This Event was successfully updated.' 
          end
        else
          @child = Event.find(params[:event][:event_id])
          @parent = Event.find(@child.parent_id)
          w_days_existing = @parent.reccurring_days
          child_events = Event.where(:parent_id => @parent.id).where("start_date >= ?",@child.start_date).all
          
          # removing the weekdays events if present
          diff = JSON.parse(w_days_existing) - w_days
          unless diff.blank?
            child_events.each do |ev|
              start_date = ev.start_date
              if diff.include? start_date.wday.to_s
                ev.destroy
              end
            end
          end

          # child_events.update(event_params)
          # adding new weekdays events if present
          new_wdays = w_days - JSON.parse(w_days_existing)
          exist_wdays = w_days & JSON.parse(w_days_existing)
          d = @child.start_date
          end_date = Date.parse(@parent.end_date.to_s)

          unless new_wdays.blank?
            while d <= end_date
              if new_wdays.include? d.wday.to_s
                event = Event.new(event_params) 
                event.start_date =  d.strftime("%Y-%m-%d")
                event.end_date = d.strftime("%Y-%m-%d")
                event.parent_id = @parent.id
                event.save
              end
              d += 1
            end 
          end

          Event.where(:parent_id => @parent.id).where("start_date >= ?",@child.start_date).all.each { |e| e.update(event_params)}


          # events = Event.where("parent_id = ?  and start_date >= ?",@parent.id,@child.start_date)
          # events.update(event_params)

          redirect_to root_url, notice: 'This Event was successfully updated.'
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
      params.require(:event).permit(:title, :event_type, :start_date, :end_date, :reccurring_days,:start_time,:end_time,:parent_id)
    end
end
