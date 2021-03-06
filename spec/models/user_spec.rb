require 'rails_helper'

describe User do
  context "associations" do
    context "has_many" do
      it { should have_many(:comments).dependent(:destroy) }
      it { should have_many(:friendships).dependent(:destroy) }
      it { should have_many(:friends).through(:friendships) }
      it { should have_many(:user_games).dependent(:destroy) }
      it { should have_many(:games).through(:user_games) }
      it { should have_many(:notifications).with_foreign_key(:recipient_id) }
      it { should have_many(:received_messages).dependent(:destroy) }
      it { should have_many(:sent_messages).dependent(:destroy) }
    end
  end

  context "validations" do
    context "presence" do
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:password) }
    end

    context "uniqueness" do
      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe ".same_game_status" do
    it "returns all other users who share the same status for a given game" do
      user = create(:user)
      user_two = create(:user)
      game = create(:game)

      create(:user_game, user: user, game: game, status: "Beat")
      create(:user_game, user: user_two, game: game, status: "Beat")

      expect_same_game_status_count(user, game, "Beat").to eq(1)
    end
  end

  describe ".filter_user_game_genre" do
    it "returns all users that have games that include queried genre" do
      user = create(:user)

      user.games << create(:game, genres: [{ name: "Action" }])
      user.games << create(:game, genres: [{ name: "Action" }])

      expect(described_class.filter_user_game_genre("Action").count).to eq(2)
    end
  end

  describe ".filter_user_game_platform" do
    it "returns all users that have games that include queried platform" do
      user = create(:user)

      user.games << create(:game, platforms: [{ name: "PC" }])
      user.games << create(:game, platforms: [{ name: "PC" }])

      expect(described_class.filter_user_game_platform("PC").count).to eq(2)
    end
  end

  describe "#added_game?" do
    it "returns true when a game is within the current user's games list" do
      user = create(:user)
      game = create(:game)

      user.games << game

      expect(user.added_game?(game)).to eq(true)
    end

    it "returns false when a game isn't within the current user's games list" do
      user = build_stubbed(:user)
      game = build_stubbed(:game)

      expect(user.added_game?(game)).to eq(false)
    end
  end

  describe "#genre_game_count" do
    it "returns total game count user has of a specific genre in games list" do
      user = create(:user)

      user.games << create(:game, genres: [{ name: "Action" }])
      user.games << create(:game, genres: [{ name: "Action" }])

      expect(user.genre_game_count("Action")).to eq(2)
    end
  end

  describe "#platform_game_count" do
    it "returns game count a user has of a specific platform in games list" do
      user = create(:user)

      user.games << create(:game, platforms: [{ name: "PC" }])
      user.games << create(:game, platforms: [{ name: "PC" }])

      expect(user.platform_game_count("PC")).to eq(2)
    end
  end

  describe "#name" do
    it "returns both first and last name" do
      user = build_stubbed(:user, first_name: "Evan", last_name: "Medrano")

      expect(user.name).to eq("Evan Medrano")
    end
  end

  describe "#is_currently_playing_a_game?" do
    it "returns true if a player is currently playing a game" do
      user = create(:user)
      user.user_games << create(:user_game, status: "Playing")

      expect(user.is_currently_playing_a_game?).to be(true)
    end
  end

  describe "#currently_playing" do
    it "returns the last game added to a user's 'Playing' games list" do
      user, game_one, game_two = create(:user), create(:game), create(:game)

      user.user_games << create(:user_game, game: game_one, status: "Playing")
      user.user_games << create(:user_game, game: game_two, status: "Playing")

      expect(user.currently_playing).to eq(game_two)
    end
  end

  describe "#can_add_as_a_friend?" do
    it "returns false when the current user is the friend" do
      user = build_stubbed(:user)

      expect(user.can_add_as_a_friend?(user)).to be(false)
    end

    it "returns false when the user is already friends with the user" do
      user, friend = create(:user), create(:user)
      create_friendships_for(user: user, friend: friend, pending: false)

      expect(user.can_add_as_a_friend?(friend)).to be(false)
    end

    it "returns true when the user is not friends with the user" do
      user, friend = create(:user), create(:user)

      expect(user.can_add_as_a_friend?(friend)).to be(true)
    end
  end

  describe "#has_unread_notifications?" do
    it "returns true if the user has notifications where read_at is nil" do
      user = create(:user)
      user.notifications << create(:notification, read_at: nil)

      expect(user.has_unread_notifications?).to be(true)
    end

    it "returns false if the user has no notifications where read_at is nil" do
      user = build_stubbed(:user)

      expect(user.has_unread_notifications?).to be(false)
    end
  end

  def expect_same_game_status_count(user, game, status)
    expect(
      described_class.
      same_game_status(current_user: user, game: game, status: status).
      count
    )
  end
end
