require 'httparty'
require 'cgi' #* Allows us to use the escape method on the search input, so it gets url encoded 

class RawgAPI
  include HTTParty
  base_uri "api.rawg.io"
  GAMES_INDEX_URI = "/api/games?search="
  GAME_URI  = "/api/games/"

  GENRES_INDEX_URI = "/api/genres?search=''"
  GENRE_URI = "/api/genres/"
  format :json

  attr_accessor :name, :description, :released, :platforms, :background_image, :id, :genres, :slug, :website, :esrb_rating, :clip, :image_background

  def initialize(response)
    @name             = response["name"]
    @description      = response["description"]
    @id               = response["id"]
    @slug             = response["slug"]

    #if statement to differentiate between game and genre searches
    if response.include?("platforms")
      @released         = response["released"]
      @background_image = response["background_image"]
      @website          = response["website"]
      @clip             = response.dig("clip", "clips", "640")
      @esrb_rating      = response.dig("esrb_rating", "name")
      @platforms        = get_names(response["platforms"])
      @genres           = get_names(response["genres"])
    else
      @image_background = response["image_background"]
    end
  end

  def self.search_all_games(search, controller="games")
    response = controller == "genres" ? get("/api/games?genres=" + search) : get(GAMES_INDEX_URI + CGI.escape(search))
    
    self.collection_query(response)
  end

  def self.get_all_genres
    response = get(GENRES_INDEX_URI)

    self.collection_query(response)
  end

  def self.get_game_content(game, slug)
    extra_game_content_uri = "/api/games/#{game}/#{slug}"
    response = get(extra_game_content_uri)
    
    self.collection_query(response)
  end

  def self.get_game(game)
    response = get(GAME_URI + CGI.escape(game))

    self.single_query(response)
  end
  
  def self.get_genre(genre)
    response = get(GENRE_URI + CGI.escape(genre))

    self.single_query(response)
  end


  private

    # Returns the names for each platform or genre within array
    def get_names(attribute)
      attribute.first.include?("platform") ? attribute.map { |a| a["platform"]["name"] } : attribute.map { |a| a["name"] }
    end

    def self.collection_query(response)
      if response.success?
        response.parsed_response["results"]
      else
        raise response.response
      end
    end

    def self.single_query(response)
      if response.success?
        new(response.parsed_response)
      else
        raise response.response
      end
    end
    
end