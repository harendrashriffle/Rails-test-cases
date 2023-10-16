class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Swiggy')
  end

  def password_token(user)
    @user = user
    mail(to: @user.email, subject: "password_token")
  end

  def deletion_email(user)
    @user = user
    mail(to: @user.email, subject: 'Account Deletion')
  end
end
