class RoomsController < ApplicationController

  def index
    @room = Room.new
    @rooms = Room.all
  end

  def new
    if request.referrer.split("/").last == "rooms"
      flash[:notice] = nil
    end
    @room = Room.new
  end

  def edit
    @room = Room.find_by(slug: params[:slug])
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      respond_to do |format|
        format.html { redirect_to @room }
        format.js
      end
    else
      respond_to do |format|
        flash[:notice] = {error: ["a room with this topic already exists"]}
        format.html { redirect_to new_room_path }
        format.js { render template: 'rooms/room_error.js.erb'}
      end
    end
  end

  def update
    room = Room.find_by(slug: params[:slug])
    room.update(room_params)
    redirect_to room
  end

  def show
    @room = Room.find_by(slug: params[:slug])
    @message = Message.new
    render layout: 'room'
  end

  private

    def room_params
      params.require(:room).permit(:topic)
    end
end
