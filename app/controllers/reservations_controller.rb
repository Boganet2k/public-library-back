class ReservationsController < ApplicationController
  include Response
  before_action :authenticate_user!
  before_action :checkForAdminPermission, only: [:update]
  before_action :set_reservation, only: [:update]

  def create

    p "create " + current_user.email

    @reservation = Reservation.new
    @reservation.status = :reserved
    @reservation.book = Book.find(params[:book_id])
    @reservation.user = current_user
    @reservation.from = DateTime.now
    @reservation.code = Array.new(8) { rand(65..90).chr }.join

    if @reservation.save

      @reservation.book.status = :reserved
      @reservation.book.save

      @expiredPerionMin = ENV['RESERVATION_EXPIRED_PERIOD_MIN'].to_i
      @endPeriod = @reservation.from + @expiredPerionMin.minutes

      UserMailer.with(reservation: @reservation, reservation_expired_at: @endPeriod.strftime("%Y-%m-%d %H:%M:%S %z")).reservation_confirmed.deliver_later
      json_response(@reservation, :created)
    else
      json_response(nil, :error)
    end
  end

  def update

    p "update @reservation.status: " + @reservation.status.to_s
    p "update_0: " + (params[:new_reservation_status] == "lent").to_s
    p "update_00 @reservation.reserved?: " + (@reservation.reserved?).to_s
    p "update_00 @reservation.lent?: " + (@reservation.lent?).to_s

    if params[:new_reservation_status] == "lent" && @reservation.reserved?

      p "update_1"

      Reservation.transaction do
        @reservation = Reservation.lock.find(params[:id])
        @reservation.to = DateTime.now
        @reservation.save!

        @lentReservation = Reservation.new
        @lentReservation.status = :lent
        @lentReservation.book = @reservation.book
        @lentReservation.user = @reservation.user
        @lentReservation.code = @reservation.code
        @lentReservation.from = DateTime.now

        @lentReservation.save!

        @reservation.book.status = :lent
        @reservation.book.save!

        json_response(@lentReservation, :created)

      rescue Exception => e
        json_response(nil, :error)
      end

    elsif params[:new_reservation_status] == "returned" && @reservation.lent?

      p "update_1"

      Reservation.transaction do
        @reservation = Reservation.lock.find(params[:id])

        @reservation.to = DateTime.now
        @reservation.save!

        @reservation.book.status = :available
        @reservation.book.save!

        json_response(@reservation, :accepted)

      rescue Exception => e
        json_response(nil, :error)
      end
    end

  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def checkForAdminPermission

    @isAccessGranted = false

    @ROLE_ADMIN = Role.getRole[:admin]

    current_user.roles.each do |role|

      if role.name.eql? @ROLE_ADMIN
        @isAccessGranted = true
        break
      end
    end

    if !@isAccessGranted
      json_response(nil, :unauthorized)
    end
  end

end