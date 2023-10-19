FactoryBot.define do
  factory :cart_item do
    quantity   {1}
    cart
    dish
  end
end
