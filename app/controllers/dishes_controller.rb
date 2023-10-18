class DishesController < ApplicationController

  before_action :owner_has_right_to, only: [:create,:update,:destroy]

  def index
    if @current_user.type == "Owner"
      dishes = selected_restaurant.dishes.all
      return render json: {message:"Restaurants have no dishes added"}, status: :no_content if dishes.nil?
      render json: {message: "Your Restaurant Dishes", data: dishes}, status: :ok
    else
      render json: Dish.all, status: :ok
    end
  end

  def create
    dish = selected_restaurant.dishes.new(set_params)
    return render json: {message:"User's dish Created", data: dish}, status: :created if dish.save
    render json: {errors: dish.errors.full_messages}, status: :unprocessable_entity
  end

  def show
    # byebug
    dish =  if @current_user.type == "Owner"
              selected_dish
            else
              Dish.find_by_id(params[:id])
            end
    render json: {message:"Here is your choosen dish", data: dish}, status: :ok
  end

  def update
    dish = selected_dish
    return render json: {message:"Updated dish", data: dish}, status: :ok if dish.update(set_params)
    render json: {errors: dish.errors.full_messages}, status: :unprocessable_entity
  end

  def destroy
    dish = selected_dish
    return render json: {message: "dish deleted succesfully"}, status: :ok if dish.destroy
    render json: {message: "dish doesn't deleted succesfully"}, status: :ok
  end

  def search
    if params[:name]
      render json: Dish.where(name:params[:name])
    elsif params[:category_id]
      render json: Dish.where(category_id:params[:category_id])
    end
  end

#----------------------------PRIVATE METHOD-------------------------------------

  private
    def set_params
      params.permit(:name,:price,:category_id)
    end

    def selected_restaurant
      restaurant = Restaurant.where(user_id: @current_user.id).find_by_id(params[:restaurant_id])
      return render json:{message: "You have no such restaurant"} if restaurant.nil?
      return restaurant
    end

    def selected_dish
      restaurant = selected_restaurant
      dish = restaurant.dishes.find_by_id(params[:id])
      return render json: {message: "No such dish added in our restaurants"} if dish.nil?
      return dish
    end

end
