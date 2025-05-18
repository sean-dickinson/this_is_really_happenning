return if Rails.env.test?

FactoryBot.create(:user, :with_projects, email_address: "test@example.com", password: "password")
