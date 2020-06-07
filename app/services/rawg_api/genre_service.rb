module RawgApi
  class GenreService
    class << self
      def all
        response = RawgApi::Request.get("/genres")

        response.fetch("results", []).map { |genre| Genre.new(genre) }
      end

      def find(genre)
        response = RawgApi::Request.get("/genres/#{genre}")

        Genre.new(response)
      end
    end
  end
end
