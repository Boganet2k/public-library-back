class UserMailer < ApplicationMailer

  default from: 'notifications@publiclibrary.com'

  def welcome_email
    @user = params[:user]
    @url = ENV['APP_URL']
    mail(to: @user.email, subject: 'Welcome to Public library')
  end

  def reservation_confirmed
    @reservation = params[:reservation]
    @reservation_expired_at = params[:reservation_expired_at]
    @url = ENV['APP_URL']

    mail(to: @reservation.user.email, subject: 'Reservation in Public library confirmed')
  end

  def reservation_expired

    @reservation = params[:reservation]
    @reservation_expired_at = params[:reservation_expired_at]
    @url = ENV['APP_URL']

    mail(to: @reservation.user.email, subject: 'Reservation in Public library expired')
  end

end
