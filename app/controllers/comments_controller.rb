class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_game
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :check_game_class


  def index
    @comments = @game.comments
  end

  def show
    
  end

  def new
    @comment = Comment.new
  end

  def edit

  end

  def create
    @comment = @game.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      flash[:notice] = "Successfully added a comment for #{@game.name}!"
      redirect_to @game
    else
      flash.now[:error] = "There was an error leaving a comment."
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = "Successfully updated your comment for #{@game.name}!"
      redirect_to @game
    else
      flash[:error] = "There was an error updating your comment."
      render :edit
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = "Successfully deleted your comment for #{@game.name}!"
      redirect_to @game
    else
      flash[:error] = "There was an error deleting your comment."
      redirect_back(fallback_location: @game)
    end
  end

  private 

  def set_game
    @game = Game.find_by(slug: params[:game_id]) || Game.find_by(id: params[:game_id]) || Rawgapi.get_game(params[:game_id])
  end

  def set_comment
    @comment = @game.comments.find_by(id: params[:id])
  end

  def comment_params
    params.require(:comment).permit(:title, :body)
  end

  def check_game_class
    if @game.instance_of?(Rawgapi)
      flash[:alert] = "Sorry, that game is not in the database. Add it to your library so you can add a comment!"
      redirect_to games_path
    end
  end

end
