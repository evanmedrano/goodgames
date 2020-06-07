module RawgApi
  class Genre < Base
    def initialize(args = {})
      super(args)
    end

    def games
      GameService.all(self.slug, "genres")
    end
  end
end
