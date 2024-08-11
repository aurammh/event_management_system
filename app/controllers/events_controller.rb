class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [ :index, :show ]
  # authorizing access to the events resource - only creator can access
  before_action :authorize_item, only: [:update, :edit, :destroy]

  def index
    # @events = Event.all.order('created_at DESC')
    @events = Event.where(active: true).order('created_at DESC')
  end

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)
    @event.active = true
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    if @event.active?
      @event = Event.find(params[:id])
    else
      redirect_to events_path, alert: 'Event is deactivated by ADMIN.'
    end
  end

  def edit
  unless @event.active?
    redirect_to events_path, alert: 'Event is deactivated by ADMIN.'
  end
    
  end

  def update
    if @event.nil?
      flash.alert = 'Event does not exist'
    elsif @event.update(event_params)
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @event = Event.find_by(params[:id])
    if @event.active?
      if @event.nil?
        redirect_to events_path, alert: 'Event does not exist'
      elsif @event.destroy
        redirect_to events_path, alert: 'Event was deleted.'
      else
        redirect_to events_path, alert: 'Error - event was not deleted.'
      end
    else
      redirect_to events_path, alert: 'Can not delete, Event is deactivated by ADMIN.'
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description, :location, :date, :private, :active)
  end

  def authorize_item
    unless @event.creator == current_user 
      redirect_to @event, alert: 'You are not authorized do that.'
    end
  end

end
