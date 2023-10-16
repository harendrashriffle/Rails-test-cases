class OrderMailer < ApplicationMailer

  def confirm_order(user)
    @user = user
    mail(to: @user.email, subject: 'Your Order Confirm')
  end

  def order_deletion(user)
    @user = user
    mail(to: @user.email, subject: 'Your Order Confirm')
  end

end
