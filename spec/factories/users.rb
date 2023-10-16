FactoryBot.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email}
    password_digest     {Faker::Internet.password(min_length:4)}
    type     {['Customer','Owner'].sample}
  end
end
