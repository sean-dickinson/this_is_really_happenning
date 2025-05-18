require "rails_helper"

RSpec.describe "/check_ins", type: :request do
  describe "GET /index" do
    it "shows all check ins for the task" do
      travel_to 2.days.ago do
        create(:task)
      end
      task = Task.last
      check_ins = []
      travel_to 1.day.ago do
        check_ins << create(:check_in, task:)
      end
      check_ins << create(:check_in, task:)

      sign_in_as task.user
      get project_task_check_ins_url(task.project, task)

      expect(response).to have_http_status(:ok)

      check_ins.each do |check_in|
        expect(response.body).to include(check_in.created_at.to_fs(:iso8601))
      end
    end
  end
  describe "POST /check_ins/:uuid" do
    it "returns a 404 if the uuid is not found" do
      post check_ins_url(uuid: SecureRandom.uuid), as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "creates a new check in" do
      task = create(:task)

      post check_ins_url(uuid: task.uuid), as: :json

      expect(response).to have_http_status(:created)
      expect(CheckIn.last.task).to eq(task)
    end

    it "allows adding metadata to the check in" do
      task = create(:task)
      metadata = {key: "value"}

      post check_ins_url(uuid: task.uuid), params: {metadata: metadata}, as: :json

      expect(response).to have_http_status(:created)
      check_in = CheckIn.last
      expect(check_in.task).to eq(task)
      expect(check_in.metadata).to eq(metadata)
    end
  end
end
