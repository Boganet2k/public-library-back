class UserMailer < ApplicationMailer

  default from: 'notifications@publiclibrary.com'

  def welcome_email
    @user = params[:user]
    @url  = 'https://public-library-gradeus-reactjs.herokuapp.com'
    mail(to: @user.email, subject: 'Welcome to Public library')
  end

end
