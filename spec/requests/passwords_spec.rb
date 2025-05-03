require "rails_helper"

RSpec.describe "Passwords", type: :request do
  describe "GET /passwords/new" do
    it "renders the password reset form" do
      get new_password_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /passwords" do
    context "when user exists" do
      it "sends password reset instructions via email" do
        user = create(:user)

        expect {
          post passwords_path, params: {email_address: user.email_address}
        }.to have_enqueued_email(PasswordsMailer, :reset)

        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when user does not exist" do
      it "does not send email and redirects to new session" do
        expect {
          post passwords_path, params: {email_address: "nonuser@example.com"}
        }.not_to have_enqueued_email(PasswordsMailer, :reset)

        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET /passwords/edit" do
    context "when user has valid token" do
      it "renders the password reset form" do
        user = create(:user)
        token = user.password_reset_token

        get edit_password_path(token: token)

        expect(response).to have_http_status(:ok)
      end
    end

    context "when user has invalid token" do
      it "redirects to new password path when token is invalid" do
        get edit_password_path(token: "invalid_token")
        expect(response).to redirect_to(new_password_path)
      end

      it "redirects to new password path when token is expired" do
        user = create(:user)
        token = user.password_reset_token

        travel_to(16.minutes.from_now)

        get edit_password_path(token: token)
        expect(response).to redirect_to(new_password_path)
      end
    end
  end
end
