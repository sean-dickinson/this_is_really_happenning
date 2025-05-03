require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /sessions/new" do
    it "returns http success" do
      get new_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sessions" do
    it "allows an existing user to sign in" do
      user = create(:user, password: "password")

      expect do
        post session_path, params: {email_address: user.email_address, password: "password"}
      end.to change(Session, :count).by(1)

      expect(response).to redirect_to(root_url)
    end

    it "does not allow a non-existing user to sign in" do
      expect do
        post session_path, params: {email_address: "nonuser@example.com", password: "password"}
      end.not_to change(Session, :count)

      expect(response).to redirect_to(new_session_path)
    end

    it "does not allow a user to sign in with an incorrect password" do
      user = create(:user, password: "password")
      expect do
        post session_path, params: {email_address: user.email_address, password: "wrongpassword"}
      end.not_to change(Session, :count)

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "DELETE /sessions" do
    it "allows a signed-in user to sign out" do
      user = create(:user, password: "password")
      sign_in_as(user)

      expect do
        delete session_path
      end.to change(Session, :count).by(-1)

      expect(response).to redirect_to(new_session_path)
    end

    it "does not allow a non-signed-in user to sign out" do
      expect do
        delete session_path
      end.not_to change(Session, :count)

      expect(response).to redirect_to(new_session_path)
    end
  end
end
