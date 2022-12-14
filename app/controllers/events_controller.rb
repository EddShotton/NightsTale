class EventsController < ApplicationController
  def index
    if params["tags"].present?
      tags = "#{params['tags']['food']} #{params['tags']['escape']} #{params['tags']['adventure']} #{params['tags']['outdoor']} #{params['tags']['theatre']} #{params['tags']['cinema']} #{params['tags']['gaming']}"
      @events = Event.search_tags(tags)
    else
      @events = Event.all
    end

    # creating markers for map:
    @markers = add_markers_to_map(@events)
  end

  def show
    # raise
    @event = Event.find(params[:id])
    @booking = Booking.new
    @friends = find_friend_username
    @booking_for_event = find_bookings_for_event(@event)
    @new_review = Review.new
    if current_user.favourites.empty?
      @favourite = nil
    else
      current_user.favourites.each { |favourite| @favourite = favourite if favourite.event_id == @event.id }
    end
  end

  def popular
    count = Favourite.group(:event_id).count
    count = count.sort_by { |_k, v| v }
    top = count.first(10)
    ids = []
    top.each { |pair| ids << pair[0] }
    @events = []
    ids.each { |id| @events << Event.find(id) }
  end

  private

  def add_markers_to_map(events)
    markers = events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude,
        info_window: render_to_string(partial:
          "info_window", locals: { event: event }),
        image_url: helpers.asset_url("pin.png")
      }
    end
    return markers
  end

  def find_bookings_for_event(event)
    matching_bookings = []
    all_bookings = current_user.bookings
    current_user.friendBookings.each do |friendbooking|
      all_bookings << friendbooking.booking
    end
    all_bookings.each do |booking|
      if booking.event_id == event.id && booking.start_time.past?
        matching_bookings << booking.event_id
      end
    end
    return matching_bookings
  end

  def find_friend_username
    name = []
    current_user.friends.each do |friend|
      name << friend.username
    end
    return name
  end
end
