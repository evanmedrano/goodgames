module SessionHelpers
  def logged_in_user(user = create(:user))
    sign_in user
  end
end

RSpec.configure do |c|
  c.include SessionHelpers
end
