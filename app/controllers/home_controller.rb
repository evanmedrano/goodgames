class HomeController < ApplicationController

    def index
      @games = Game.last(3)
    end

    
end
