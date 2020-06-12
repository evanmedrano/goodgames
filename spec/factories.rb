FactoryBot.use_parent_strategy = false

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :name do |n|
    "name #{n}"
  end

  sequence :slug do |n|
    "game-#{n}"
  end

  factory :comment do
    association :user
    title { "MyString" }
    body { "MyText" }
    commentable nil
  end

  factory :game do
    name
    slug
    background_image { "logo.png" }
    clip { "clip text" }
    description { "This is a test game" }
    esrb_rating { "E for Everyone" }
    genres [
      { "id" => 2, "name" => "Shooter", "slug" => "shooter" },
      { "id" => 7, "name" => "Puzzle", "slug" => "puzzle" }
    ]
    platforms [
      { "id" => 4, "name" => "PC", "slug" => "pc" },
      { "id" => 4, "name" => "iOS", "slug" => "pc" }
    ]
    released { "2000/01/23" }
    website { "www.example.com" }
  end

  factory :user do
    email
    name
    password { "foobar123" }

    after(:create) do |user|
      user.skip_confirmation!
      user.save
    end
  end

  factory :user_game do
    association :game
    association :user
  end
end
