class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    # @user = params[:user]
    email = "bob@bob.com"
    @url  = 'http://example.com/login'
    mail(to: email, subject: 'Welcome to Idea Dojo')
  end
end
