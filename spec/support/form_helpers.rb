module FormHelpers
  def submit_form(form)
    Capybara::RackTest::Form.new(page.driver, form.native).submit({})
  end
end

RSpec.configure do |config|
  config.include FormHelpers, type: :feature
end