class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :location, :image

  has_many :dishes

  def image
    object.image.url
  end
end
