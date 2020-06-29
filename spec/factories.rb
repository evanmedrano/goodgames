FactoryBot.use_parent_strategy = false

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :first_name do |n|
    "first name #{n}"
  end

  sequence :last_name do |n|
    "last name #{n}"
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

  factory :friendship do
    association :friend, factory: :user
    association :user
    pending { true }
    request_sent_by { user.id > friend.id ? user.id : friend.id }
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

    trait :with_suggested_games do
      after(:create) do |game|
        game.suggested_games = []

        3.times { game.suggested_games << create(:game) }
      end
    end
  end

  factory :message do
    association :recipient, factory: :user
    association :sender, factory: :user
    subject "MyString"
    body "MyText"
  end

  factory :notification do
    association :actor, factory: :user
    association :notifiable, factory: :message
    association :recipient, factory: :user
    read_at "2020-06-18 19:48:32"
    action "sent"
  end

  factory :user do
    email
    first_name
    last_name
    password { "foobar123" }

    before(:create) do |user|
      user.skip_confirmation!
      user.save
    end

    trait :with_confirmation_email do
      after(:create) do |user|
        user.send_confirmation_instructions
      end
    end

    trait :with_a_games_library do
      transient do
        library_size { 2 }
      end

      after(:create) do |user, evaluator|
        evaluator.library_size.times { user.games << create(:game) }
      end
    end

    trait :with_friends do
      after(:create) do |user|
        2.times { user.friends << create(:user) }
      end
    end

    trait :with_received_messages do
      after(:create) do |user|
        2.times { user.received_messages << create(:message) }
      end
    end

    trait :with_sent_messages do
      after(:create) do |user|
        2.times { user.sent_messages << create(:message) }
      end
    end
  end

  factory :user_game do
    association :game
    association :user
  end
end
