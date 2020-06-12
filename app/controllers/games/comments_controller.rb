class Games::CommentsController < CommentsController
  before_action :set_game, only: [:index, :new, :edit]
  before_action :set_comment, only: [:edit]
  before_action :require_permission!, only: [:edit]
  before_action :set_commentable, only: [:create, :update, :destroy]

  def index
    @comments = Comment.includes(:user).where(commentable_id: @game.id)
  end

  def new
  end

  def edit
  end

  private

  def set_game
    @game = find_persisted_game || persist_new_game_data

    render_error_page?(@game)
  end

  def set_comment
    @comment = @game.comments.find_by(id: params[:id])

    render_error_page?(@comment)
  end

  def require_permission!
    if current_user != @comment.user
      redirect_to root_url, alert: "You do not have access to this page."
    end
  end

  def set_commentable
    @commentable = find_persisted_game || persist_new_game_data
  end

  def render_error_page?(param)
    if param.nil?
      render "errors/show"
    end
  end

  def find_persisted_game
    Game.find_by(slug: params[:game_id]) || Game.find_by(id: params[:game_id])
  end

  def persist_new_game_data
    RawgApi::Game.new({ slug: params[:game_id] }).save

    find_persisted_game
  end
end
