require "rails_helper"

describe UserMailer do
  describe "#send_friend_request" do
    it "sends the request to the requested friend's email" do
      user, friend = create(:user), create(:user)

      send_friend_request_email(user, friend)

      mail = ActionMailer::Base.deliveries.first
      expect([friend.email]).to eq(mail.to)
    end

    it "displays the requester's name in the email's subject" do
      user, friend = create(:user), create(:user)

      send_friend_request_email(user, friend)

      mail = ActionMailer::Base.deliveries.first
      expect(mail.subject).to include(user.name)
    end
  end

  describe "#send_user_message" do
    it "sends the email to the message recipient" do
      recipient, sender = create(:user), create(:user)

      send_user_message_email(recipient, sender)

      mail = ActionMailer::Base.deliveries.first
      expect([recipient.email]).to eq(mail.to)
    end

    it "displays the message sender's name in the email's subject" do
      recipient, sender = create(:user), create(:user)

      send_user_message_email(recipient, sender)

      mail = ActionMailer::Base.deliveries.first
      expect(mail.subject).to include(sender.name)
    end
  end

  describe "#send_suggested_games" do
    it "sends the email to the user who beat the game" do
      recipient = create(:user)
      game = create(:game, :with_suggested_games)

      send_suggested_games(recipient, game, game.suggested_games)

      mail = ActionMailer::Base.deliveries.first
      expect([recipient.email]).to eq(mail.to)
    end

    it "displays the game's name in the email's subject" do
      recipient = create(:user)
      game = create(:game, :with_suggested_games)

      send_suggested_games(recipient, game, game.suggested_games)

      mail = ActionMailer::Base.deliveries.first
      expect(mail.subject).to include(game.name)
    end

    it "has a list of suggested games in the body of the email" do
      recipient = create(:user)
      game = create(:game, :with_suggested_games)

      send_suggested_games(recipient, game, game.suggested_games)

      mail = ActionMailer::Base.deliveries.first

      game.suggested_games.each do |game|
        expect(mail.body).to include(game.name)
      end
    end
  end

  def send_friend_request_email(user, friend)
    described_class.send_friend_request(user: user, friend: friend).deliver_now
  end

  def send_user_message_email(recipient, sender)
    described_class.send_user_message(recipient: recipient, sender: sender).
      deliver_now
  end

  def send_suggested_games(recipient, game, games)
    described_class.
      send_suggested_games(recipient: recipient, game: game, games: games).
      deliver_now
  end
end
