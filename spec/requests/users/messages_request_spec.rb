require 'rails_helper'

describe "Users::Messages" do
  describe "#new" do
    it "only allows logged in users to access the page" do
      user = create(:user)

      get new_user_message_path(user_id: user, as: logged_in_user)

      expect(response).to have_http_status(200)
    end

    it "redirects guests who do not have access to the page" do
      get new_user_message_path(user_id: 1)

      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "#create" do
    context "with valid params" do
      it "saves a new message in the database" do
        recipient, sender = create(:user), create(:user)

        post user_messages_path(user_id: recipient, as: logged_in_user(sender)),
          params: params(recipient, sender)

        expect(Message.count).to eq(1)
      end
    end

    context "with invalid params" do
      it "does not save a new message in the database" do
        recipient, sender = create(:user), create(:user)

        post user_messages_path(user_id: recipient, as: logged_in_user(sender)),
          params: params(recipient, sender, subject: "")

        expect(Message.count).to eq(0)
      end

      it "re-renders the new action" do
        recipient, sender = create(:user), create(:user)

        post user_messages_path(user_id: recipient, as: logged_in_user(sender)),
          params: params(recipient, sender, subject: "")

        expect(response).to render_template(:new)
      end
    end
  end

  describe "#destroy" do
    it "deletes a message from the database" do
      user = create(:user)
      message = create(:message, sender: user)

      delete user_message_path(
        user_id: user, id: message, as: logged_in_user(user)
      )

      expect(Message.count).to eq(0)
    end
  end

  def params(recipient, sender, subject: "Hey!")
    {
      message: {
        subject: subject,
        body: "You're awesome!",
        recipient_id: recipient.id,
        sender_id: sender.id
      }
    }
  end
end
