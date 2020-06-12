require 'rails_helper'

describe TitlesHelper do
  describe "#title" do
    context "when no custom title is provided" do
      it "returns the default title" do
        expect(helper.title).to eq(helper.default_title)
      end
    end

    context "when there is a custom title provided" do
      it "returns the custom title" do
        helper.content_for(:title, "My custom title")

        expect(helper.title).to eq("My custom title")
      end
    end
  end

  describe "#games_library_title" do
    it "returns a custom title with the owner's name and games count" do
      user = build_stubbed(:user)
      library = LibraryFacade.new(user)

      helper.content_for(:title, helper.games_library_title(library))

      expect(helper.title).to eq(helper.games_library_title(library))
    end
  end

  describe "#games_comments_title" do
    context "when a comment is being created" do
      it "returns an add comment title" do
        game, comment = create(:game), build(:comment)

        helper.content_for(:title, comment_title(comment, game))

        expect(helper.title).to eq(comment_create_title(game))
      end
    end

    context "when a comment is being updated" do
      it "returns an edit comment title" do
        comment = create(:comment, commentable: create(:game))

        helper.content_for(:title, comment_title(comment))

        expect(helper.title).to eq(comment_update_title(comment.commentable))
      end
    end
  end

  describe "#default_title" do
    it "returns the default title" do
      expect(helper.default_title).to eq(default_title_for_spec)
    end
  end

  def comment_title(comment, game = comment.commentable)
    helper.game_comment_title(comment: comment, game: game)
  end

  def comment_create_title(game)
    "Add a comment for #{game.name} | GoodGames"
  end

  def comment_update_title(game)
    "Edit your comment for #{game.name} | GoodGames"
  end

  def default_title_for_spec
    "GoodGames | All the games you love in one place"
  end
end
