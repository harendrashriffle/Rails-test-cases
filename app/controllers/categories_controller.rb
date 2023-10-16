class CategoriesController < ApplicationController

before_action :owner_has_right_to, only: [:create,:update,:destroy]

  def index
    render json: {message: "All Categories", data: Category.all}
  end

  def create
    category = Category.new(set_params)
    return render json: {message:"Category Created", data: category} if category.save
    render json: {errors: "Category Not Created"}
  end

  def show
    category = Category.find_by_id(params[:id])
    return render json: {message: "Here is your choosen category", data: category} if category.present?
    render json: {message: "Category is not present"}
  end

  def update
    category = Category.find_by_id(params[:id])
    return render json: {message: "No such category"} if category.nil?
    return render json: {message:"Updated category", data: category} if category.update(set_params)
    render json: {errors: category.errors.full_message}s
  end

  # def destroy
  #   category = Category.find_by_id(params[:id])
  #   return render json: {message: "category deleted succesfully"} if category.destroy
  #   render json: {errors: "category doesn't deleted"}
  # end

#----------------------------PRIVATE METHOD-------------------------------------

  private
    def set_params
      params.permit(:name)
    end

end
