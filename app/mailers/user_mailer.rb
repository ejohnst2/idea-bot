class UserMailer < ApplicationMailer
  default from: 'ideas@think.fish'

  def welcome_email(email)
    @email = email
    mail(to: @email, subject: 'Welcome to ThinkFish')
  end
end
