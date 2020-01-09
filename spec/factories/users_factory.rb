FactoryBot.define do
  factory :user do
    name             "Evan"
    sequence(:email) { |n| "evan#{n}@example.com" }
    password         "foobar"
  end
end
