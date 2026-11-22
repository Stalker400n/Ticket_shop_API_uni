class Api::V1::EventsController < ApplicationController
  def index
    render(json: EventStore.all)
  end

  def show
    if event = EventStore.find(params[:id])
      render(json: event)
    else
      render(status: :not_found)
    end
  end

  def create

  end

  def update

  end

  def update

  end

  def destroy

  end
end
