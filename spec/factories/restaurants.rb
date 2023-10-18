FactoryBot.define do
  factory :restaurant do
    name     { Faker::Restaurant.name }
    status   {['Open','Closed'].sample}
    location     {Faker::Address.city}
    user_id  {1}
  end
end
