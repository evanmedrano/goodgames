class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    comment = @commentable.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      redirect_to @commentable, notice: "Your comment was successfully saved."
    else
      redirect_to @commentable, alert: "There was an error leaving a comment."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :body)
  end
end
