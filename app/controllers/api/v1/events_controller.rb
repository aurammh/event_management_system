class Api::V1::EventsController < Api::V1::ApiController

  before_action :set_event, only: %i[show update destroy ]

  def index
    @events = Event.where(active: true).order('created_at DESC')
    render json: @events
  end

  def create
    @event = @current_user.events.build(event_params)
    @event.active = true
    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update

    if @event.update(event_params)
      render json: @event, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # return render json: { error: "Couldn't delete deactive event" }, status: :ok unless @event.active?

    if @event.creator_id != @current_user.id
      render json: { error: "You are not authorized to delete this event" }, status: :ok
      return
    end
  
    unless @event.active?
      render json: { error: "Couldn't delete inactive event" }, status: :ok
      return
    end
  
    @event.destroy
    render json: { success: "Event deleted successfully" }, status: :ok
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :description, :location, :date, :private, :active)
    end

end
