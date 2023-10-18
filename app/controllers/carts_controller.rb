class CartsController < ApplicationController

  def create
    return render json: {message: "You have no access to create cart"} unless @current_user.type == "Customer"
    return render json: {message: "Your cart is already created"} if Cart.find_by(user_id: @current_user.id).present?
    cart = @current_user.build_cart
    render json: { message: "Cart Created successfully" }, status: :created if cart.save
  end

end
