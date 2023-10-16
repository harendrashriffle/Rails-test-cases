class CartItemsController < ApplicationController

  def index
    return render json: { message: "Only customers can view their cart items" } unless @current_user.type == "Customer"
    cart_items = @current_user.cart.cart_items
    return render json: {errors: "No cart items present"} if cart_items.blank?
    render json: { message: "Your cart items", data: cart_items }
  end

  def create
    return render json: {message: "You have no access to add dish in cart"} unless @current_user.type == "Customer"

    dish = Dish.find_by_id(params[:dish_id])
    return render json: {message: "NO such dish is present"} if dish.nil?

    cart_items = @current_user.cart.cart_items

    unless cart_items.blank? && cart_items.first.dish.restaurant == dish.restaurant
      cart_items.destroy_all
    end

    add_item = cart_items.new(set_params)
    return render json: { message: "Item added successfully" } if add_item.save
    render json: { message: "Item doesn't added successfully" }
  end

  def update
    return render json: {message: "You have no access to add dish in cart"} unless @current_user.type == "Customer"
    cart_item = @current_user.cart.cart_items.find_by_id(params[:id])
    return render json: {message: "No such dish is added in your cart"} if cart_item.nil?
    if cart_item.update(set_params)
      render json: { message: "Cart item updated successfully" }
    else
      render json: { message: "Cart item update failed"}
    end
  end

  def destroy
    return render json: {message: "You have no access to delete dish in cart"} unless @current_user.type == "Customer"
    cart_item = CartItem.find_by(id: params[:id], cart: @current_user.cart)
    return render json: {message: "No such dish is added in your cart"} if cart_item.nil?
    return render json: { message: "Item removed from the cart successfully" } if cart_item.destroy
    render json: { message: "Item doesn't remove from the cart" }
  end

#----------------------------PRIVATE METHOD-------------------------------------

  private
    def set_params
      params.permit(:dish_id,:quantity)
    end

end
