class EventsController < ApplicationController
  before_action :set_event, only: [:destroy]

  # POST /events.json
  def create

    params['event']['reccurring_days'] = params['event']['reccurring_days'].to_s
    # raise params['event']['reccurring_days'].inspect

    if params['event']['event_id'].blank?
      @event = Event.new(event_params)
      respond_to do |format|
        if @event.save
          format.html { redirect_to root_url, notice: 'Event was successfully added.' }
          format.json { render :show, status: :created, location: @event }
        else
          format.html { render :new }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    else
      @event = Event.find(params['event']['event_id'].to_i)
      respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to root_url, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
    end
    # raise event_params.inspect

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
      params.require(:event).permit(:title, :event_type, :start_date, :end_date, :reccurring_days)
    end
end
