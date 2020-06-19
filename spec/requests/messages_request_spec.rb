require 'rails_helper'

describe "Messages" do
  describe "#new" do
    it "allows logged in users to access the page" do
      get new_message_path(as: logged_in_user)

      expect(response).to have_http_status(200)
    end

    it "redirects guests" do
      get new_message_path

      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "#create" do
    context "with valid params" do
      it "saves a new message in the database" do
        recipient, sender = create(:user), create(:user)

        post messages_path(user_id: recipient, as: logged_in_user(sender)),
          params: params(recipient, sender)

        expect(Message.count).to eq(1)
      end
    end

    context "with invalid params" do
      it "does not save a new message in the database" do
        recipient, sender = create(:user), create(:user)

        post messages_path(user_id: recipient, as: logged_in_user(sender)),
          params: params(recipient, sender, subject: "")

        expect(Message.count).to eq(0)
      end

      it "re-renders the new action" do
        recipient, sender = create(:user), create(:user)

        post messages_path(user_id: recipient, as: logged_in_user(sender)),
          params: params(recipient, sender, subject: "")

        expect(response).to render_template(:new)
      end
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
