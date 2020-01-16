FactoryBot.define do
  factory :comment do
    title "This is my game comment"
    body "I love this game so much! Highly recommend!"
    association :user
    association :game
  end
end
