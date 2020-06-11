class Games::CommentsController < CommentsController
  before_action :set_game, only: [:new, :edit]
  before_action :set_comment, only: [:edit]
  before_action :set_commentable, only: [:create, :update, :destroy]

  def new
  end

  def edit
  end

  private

  def set_game
    @game = find_persisted_game || persist_new_game_data
  end

  def set_commentable
    @commentable = find_persisted_game || persist_new_game_data
  end

  def set_comment
    @comment = @game.comments.find_by(id: params[:id])
  end

  def find_persisted_game
    Game.find_by(slug: params[:game_id]) || Game.find_by(id: params[:game_id])
  end

  def persist_new_game_data
    RawgApi::Game.new({ slug: params[:game_id] }).save

    find_persisted_game
  end
end
