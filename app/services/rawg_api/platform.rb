module RawgApi
  class Platform < Base
    def initialize(args = {})
      super(args)
    end

    def games
      GameService.all(self.id.to_s, "platforms")
    end
  end
end
