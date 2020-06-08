require 'cgi'

module RawgApi
  class Game < Base
    attr_accessor :suggested_games,
                  :series_games,
                  :screenshots,
                  :users_playing,
                  :users_finished,
                  :released,
                  :platforms,
                  :background_image,
                  :genres,
                  :esrb_rating,
                  :clip,
                  :website

    def initialize(args = {})
      super(args)
      self.clip = parse_clips(args)
      self.platforms = parse_platforms(args) if respond_to?(:map)
    end

    def save
      game = find_or_create_game(self)

      if game.valid?
        game.save
      else
        false
      end
    end

    def was_added?(user, game)
      nil
    end

    def comments
      []
    end

    private

    def parse_clips(args = {})
      args.fetch("clip", {})["clip"] if clip.respond_to?(:[])
    end

    def parse_platforms(args = {})
      args.fetch("platforms", []).map! { |platform| platform.dig("platform") }
    end

    def find_or_create_game(game)
      ::Game.find_or_initialize_by(slug: game.slug).tap do |new_game|
        if new_game.invalid?
          response = GameService.find(game.slug)

          set_attribute_values(response, new_game)
        end
      end
    end

    def set_attribute_values(response, game)
      response.instance_values.each do |attribute, value|
        unless attribute == 'id'
          game.send("#{attribute}=", value) if game.respond_to?("#{attribute}=")
        end
      end
    end
  end
end
