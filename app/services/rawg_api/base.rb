module RawgApi
  class Base
    attr_accessor :errors,
                  :name,
                  :description,
                  :id,
                  :slug,
                  :image_background

    def initialize(args = {})
      args.each do |name, value|
        send("#{name}=", value) if respond_to?("#{name}=")
      end
    end
  end
end
