class OrdersController < ApplicationController

  def index
    return render json: { message: "You have no access to view orders" } unless @current_user.type == "Customer"
    orders = @current_user.orders.order(created_at: :desc)
    render json: { message: "Your order list", data: orders }
  end

  def create
    return render json: { message: "You have no access to create orders" } unless @current_user.type == "Customer"

    cart = @current_user.cart
    cart_items = cart.cart_items
    return  render json: { message: "Your cart is empty." } if cart_items.empty?

    total_price = cart_items.sum { |cart_item| cart_item.dish.price * cart_item.quantity }

    order = @current_user.orders.new(address: params[:address], price: total_price)

    if order.save
      cart_items.each do |cart_item|
        order_item = order.order_items.new(
          dish_id: cart_item.dish_id,
          quantity: cart_item.quantity,
          price: cart_item.dish.price * cart_item.quantity
        )
        order_item.save
      end

      cart.cart_items.destroy_all

      OrderMailer.confirm_order(@current_user).deliver_now
      render json: { message: "Order created successfully", data: order }
    else
      render json: { message: "Order creation failed", errors: order.errors.full_messages}
    end
  end

  def show
    return render json: { message: "You have no access to view order details" } unless @current_user.type == "Customer"
    order = @current_user.orders.find_by(id: params[:id])
    return render json: { message: "Order details", data: order } if order.present?
    render json: { errors: "Order not found" }
  end

  def destroy
    return render json: { message: "You have no access to view order details" } unless @current_user.type == "Customer"
    last_order = @current_user.orders.order(created_at: :desc).first
    return render json: { message: "You don't have any orders to delete"} if last_order.nil?
    if last_order.created_at >= 1.minute.ago
      return render json: { message: "Failed to destroy last order"} unless last_order.destroy
      OrderMailer.order_deletion(@current_user).deliver_now
      render json: { message: "Last order deleted successfully" }
    else
      render json: {message: "Order can only be cancelled under 1 minute after order"}
    end
  end

end
