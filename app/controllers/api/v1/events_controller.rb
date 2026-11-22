class Api::V1::EventsController < ApplicationController
  def index
    render(json: EventStore.all)
  end

  def show
    event = EventStore.find(params[:id]) or return not_found
    render(json: event)
  end

  def create
    data = parse_body or return
    data["kodas"] ||= EventStore.next_code
    errors = SchemaValidator.check(data)
    return render(json: { errors: errors }, status: :bad_request) if errors.any?
    render(json: EventStore.create(data), status :created)
  rescue EventStore::Duplicate => e
    return(json: {error: e.message}, status: :conflict)
 end

  def update
    data = parse_body or return
    data["kodas"] = params[:id]
    errors = SchemaValidator.check(data)
    return render(json: { errors: errors }, status: :bad_request) if errors.any?
    event = EventStore.update(params[:id], data) or return not_found
    render(json: event)
  end

  def destroy
    EventStore.delete(params[:id]) ? head(:no_content) : not_found
  end

  private

  def parse_body
    JSON.parse(request.raw_post)
  rescue JSON::ParserError => e
    render(json: {errors: ["Invalid JSON: #{e.message}"]}, status: :bad_request)
    nil
  end

  def not_found
    render(json: {error: "Not found"}, status: :not_found)
  end
end
