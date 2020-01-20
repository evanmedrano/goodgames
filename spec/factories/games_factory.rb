FactoryBot.define do
  factory :game do
    sequence(:name)  { |n| "Game #{n}" }    
    sequence(:slug)  { |n| "game-#{n}" }
    description      "This is a test game"
    released         "2000/01/23"
    background_image "url text"
    platforms        [ { "platform" => { "id" => 4, "name" => "PC", "slug" => "pc" } }, { "platform" => { "id" => 4, "name" => "iOS", "slug" => "pc" } } ]
    genres           ["Genre 1", "Genre 2"]
    website          "www.example.com"
    esrb_rating      "E for Everyone"
    clip             "clip text"

  end
end
