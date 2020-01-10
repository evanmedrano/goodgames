FactoryBot.define do
  factory :game do
    sequence(:name)  { |n| "Game #{n}" }    
    description      "This is a test game"
    released         "10/23/2020"
    background_image "url text"
    platforms        ["Platform 1", "Platform 2"]
    genres           ["Genre 1", "Genre 2"]
    website          "www.example.com"
    esrb_rating      "E for Everyone"
    clip             "clip text"
  end
end
