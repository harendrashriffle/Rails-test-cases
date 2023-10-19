FactoryBot.define do
  factory :order do
    address     { Faker::Address.full_address }
    price       { Faker::Commerce.price}
    user
    created_at  {Time.now}
  end
end
