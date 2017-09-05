FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.unique.user_name(6..10) }
    password { Faker::Internet.password(8) }
  end
end