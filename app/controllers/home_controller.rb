class HomeController < ApplicationController
  def index
    if user_signed_in?
      render "dashboards/show"
    end
  end
end
