FactoryBot.define do
  factory :dish do
    name     { Faker::Food.dish  }
    price    { Faker::Commerce.price}
    category_id {3}
    restaurant_id {2}
  end
end
