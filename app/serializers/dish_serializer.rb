class DishSerializer < ActiveModel::Serializer
  attributes :id, :name, :price,:category_name,:restaurant_name,:image

  # belongs_to :category
  # belongs_to :restaurant

  def category_name
    object.category.name
  end

  def restaurant_name
    object.restaurant.name
  end

  def image
    object.image.url
  end
end
