module RawgApi
  class PlatformService
    class << self
      def all
        response = RawgApi::Request.get("/platforms")

        response.fetch("results", []).map { |platform| Platform.new(platform) }
      end

      def find(platform)
        response = RawgApi::Request.get("/platforms/#{platform}")

        Platform.new(response)
      end
    end
  end
end
