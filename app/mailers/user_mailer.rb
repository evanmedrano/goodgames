class UserMailer < Devise::Mailer
  helper :application
  default template_path: 'devise/mailer'
  default from: "no-reply@goodgames.com"

  def confirmation_instructions(record, token, opts={})
    opts[:from] = "registrations@goodgames.com"
    super
  end
end
