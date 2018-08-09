class UserMailer < ApplicationMailer
  default from: 'ideas@ideadojo.io'

  def welcome_email(email)
    @email = email
    mail(to: @email, subject: 'Welcome to Idea Dojo')
  end
end
