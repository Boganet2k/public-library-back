class ReservationsController < ApplicationController
  include Response
  before_action :authenticate_user!


  def create
    p "create " + current_user.email
    @reservation = Reservation.new
    @reservation.status = "reserved"
    @reservation.book = Book.find(params[:id])
    @reservation.user = current_user
    @reservation.from = DateTime.now
    @reservation.code = Array.new(8) { rand(65..90).chr }.join

    if @reservation.save
      json_response(@reservation, :created)
    else
      json_response(nil, :error)
    end
  end


  def reservation_params
    # whitelist params
    params.permit(:book)
  end

end