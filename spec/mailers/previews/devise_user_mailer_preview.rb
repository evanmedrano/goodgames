# Preview all emails at http://localhost:3000/rails/mailers/devise_user_mailer
class DeviseUserMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    DeviseUserMailer.confirmation_instructions(User.first, "faketoken", {})
  end

  def reset_password_instructions
    DeviseUserMailer.reset_password_instructions(User.first, "faketoken", {})
  end
end
