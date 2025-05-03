require "rails_helper"

RSpec.describe "HomePage", type: :request do
  describe "GET /" do
    it "renders" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to be_empty
    end
  end
end
