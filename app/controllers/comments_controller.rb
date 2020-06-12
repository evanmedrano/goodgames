class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def create
    comment = @commentable.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      redirect_to @commentable, notice: "Your comment was successfully saved."
    else
      redirect_to @commentable, alert: "There was an error leaving a comment."
    end
  end

  def update
    comment = @commentable.comments.find_by(id: params[:id])

    if comment.update(comment_params)
      redirect_to @commentable, notice: "Your comment was successfully updated."
    else
      redirect_to @commentable, alert: "There was an error editing the comment."
    end
  end

  def destroy
    comment = @commentable.comments.find_by(id: params[:id])

    if comment.destroy
      redirect_to @commentable, notice: "Your comment was successfully deleted."
    else
      redirect_to @commentable, alert: "There was an error deleting the comment."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :body)
  end
end
