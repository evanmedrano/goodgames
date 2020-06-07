class PlatformsController < ApplicationController
  before_action :set_platform, only: [:show]

  def index
    @platforms = RawgApi::PlatformService.all
  end

  def show
    raise TypeError if @platform.name.nil?
  rescue TypeError
    redirect_to platforms_path, alert: "Sorry, could not find the platform."
  end

  private

  def set_platform
    @platform = RawgApi::PlatformService.find(params[:id])
  end
end
