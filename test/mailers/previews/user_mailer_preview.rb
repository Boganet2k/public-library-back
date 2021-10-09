# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome_email
    @url  = 'https://public-library-gradeus-reactjs.herokuapp.com'
    UserMailer.with(user: User.first).welcome_email
  end

end
