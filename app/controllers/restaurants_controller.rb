class RestaurantsController < ApplicationController

  before_action :owner_has_right_to, only: [:create,:update,:destroy]

  def index
    restaurants = Restaurant.all
    restaurants = @current_user.restaurants if @current_user.type == 'Owner'
    restaurants = restaurants.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
    restaurants = restaurants.where(status: params[:status]) if params[:status].present?
    restaurants = restaurants.where('location LIKE ?', "%#{params[:location]}%") if params[:location].present?
    return render json: { message: 'Restaurants found', data: restaurants } if restaurants.present?
    render json: { message: 'No restaurants found' }
  end

  def create
    restaurant = @current_user.restaurants.new(set_params)
    return render json: {message:"Your's Restaurant Created", data: restaurant},status: :created if restaurant.save
    render json: {errors: restaurant.errors.full_messages}, status: :unprocessable_entity
  end

  def show
    restaurant = if @current_user.type == "Owner"
                  selected_restaurant
                else
                  Restaurant.find_by(id: params[:id])
                end
    render json: {message: "Here is your choosen retaurant",data: restaurant},status: :ok
  end

  def update
    restaurant = selected_restaurant
    return render json: {message:"Updated Restaurant", data: restaurant},status: :ok if restaurant.update(set_params)
    render json: {errors: restaurant.errors.full_messages}, status: :unprocessable_entity
  end

  def destroy
    restaurant = selected_restaurant
    return render json: {message: "Restaurant Deleted Succesfully"},status: :ok if restaurant.destroy
  end

#----------------------------PRIVATE METHOD-------------------------------------

  private
    def set_params
      params.permit(:name,:status,:location,:image)
    end

    def selected_restaurant
      @restaurant = @current_user.restaurants.find_by_id(params[:id])
      @restaurant.nil? ? "You have no such restaurant" : @restaurant
    end
end
