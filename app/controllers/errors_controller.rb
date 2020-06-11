class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    render_404
  end

  private

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404: #{exception.message}"
    end
  end
end
