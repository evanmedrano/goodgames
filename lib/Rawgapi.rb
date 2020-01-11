require 'httparty'
require 'cgi' #* Allows us to use the escape method on the search input, so it gets url encoded 

class RawgAPI
  include HTTParty
  base_uri "api.rawg.io"
  GAMES_INDEX_URI = "/api/games?search="
  GAME_URI  = "/api/games/"

  GENRES_INDEX_URI = "/api/genres?search="
  GENRE_URI = "/api/genres/"
  format :json

  attr_accessor :name, :description, :released, :platforms, :background_image, :id, :genres, :slug, :website, :esrb_rating, :clip, :image_background

  def initialize(response)
    self.name             = response["name"]
    self.description      = response["description"]
    self.id               = response["id"]
    self.slug             = response["slug"]

    # if statement to differentiate between game and genre searches
    #if response["released"] != nil
      self.released         = response["released"]
      self.background_image = response["background_image"]
      self.website          = response["website"]
      self.clip             = response.dig("clip", "clips", "640")
      self.esrb_rating      = response.dig("esrb_rating", "name")
      self.platforms        = get_names(response["platforms"])
      self.genres           = get_names(response["genres"])
    #else
      self.image_background = response["image_background"]
    #end
  end

  def self.search_games(search)

    response = get(GAMES_INDEX_URI + CGI.escape(search))
    
    if response.success?
      response.parsed_response["results"]
    else
      raise response.response
    end
  end

  def self.search_genres(search)
    response = get(GENRES_INDEX_URI + CGI.escape(search))
    #byebug
    if response.success?
      response.parsed_response["results"]
    else
      raise response.response
    end
  end

  def self.get_game(game, controller)
    response = get(GAME_URI + CGI.escape(game))

    if response.success?
      #byebug
      controller == "genres" ? response.parsed_response : new(response.parsed_response)
    else
      raise response.response
    end
  end
  
  def self.get_genre(genre)
    response = get(GENRE_URI + CGI.escape(genre))

    if response.success?
      new(response.parsed_response)
    else
      raise response.response
    end
  end

  def self.get_screenshots(game)
    screenshots_uri = "/api/games/#{game}/screenshots"
    response = get(screenshots_uri)
    
    if response.success?
      response.parsed_response["results"]
    else
      raise response.response
    end
  end

  def self.get_game_series(game)
    game_series_uri = "/api/games/#{game}/game-series"
    response = get(game_series_uri)
    
    if response.success?
      response.parsed_response["results"]
    else
      raise response.response
    end
  end

  def self.get_similar_games(game)
    similar_games_uri = "/api/games/#{game}/suggested"
    response = get(similar_games_uri)
    
    if response.success?
      response.parsed_response["results"]
    else
      raise response.response
    end
  end

  def self.save_game(game)
    response = get(GAME_URI + CGI.escape(game))

    game = new(response)

    if response.success?
      Game.find_or_create_by(name: game.name) do |g|
          g.description      = game.description
          g.released         = game.released
          g.platforms        = game.platforms
          g.background_image = game.background_image
          g.genres           = game.genres
          g.website          = game.website
          g.clip             = game.clip
          g.esrb_rating      = game.esrb_rating
          g.slug             = game.slug
      end
    else
      raise response.response
    end
  end

  private

    # Returns the names for each item within array
    def get_names(attribute)
      if attribute.first.include?('platform')
        attribute.first.include?('platform') ? attribute.map { |a| a["platform"]["name"] } :
                                             attribute.map { |a| a["name"] }
      end
    end
end