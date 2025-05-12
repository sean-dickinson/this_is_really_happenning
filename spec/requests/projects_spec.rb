require "rails_helper"
RSpec.describe "/projects", type: :request do
  context "when the user does not have access to the project" do
    it "cannot view the project" do
      project = create(:valid_project)
      user = create(:user)
      expect(project.users).not_to include(user)
      sign_in_as user

      get project_url(project)
      expect(response).to have_http_status(:not_found)
    end

    it "cannot view the edit page for the project" do
      project = create(:valid_project)
      user = create(:user)
      expect(project.users).not_to include(user)
      sign_in_as user

      get edit_project_url(project)
      expect(response).to have_http_status(:not_found)
    end

    it "cannot update the project" do
      project = create(:valid_project)
      user = create(:user)
      expect(project.users).not_to include(user)
      sign_in_as user

      patch project_url(project), params: {project: {name: "Updated Project"}}
      expect(response).to have_http_status(:not_found)
    end

    it "cannot destroy the project" do
      project = create(:valid_project)
      user = create(:user)
      expect(project.users).not_to include(user)
      sign_in_as user

      delete project_url(project)
      expect(response).to have_http_status(:not_found)
    end
  end
  describe "GET /index" do
    it "renders all the user's projects" do
      user = create(:user, :with_projects)
      projects = user.projects
      sign_in_as user

      get projects_url

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(*projects.map(&:name))
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = create(:user, :with_projects)
      project = user.projects.first

      sign_in_as user
      get project_url(project)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include project.name
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      user = create(:user)
      sign_in_as user

      get new_project_url

      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      user = create(:user, :with_projects)
      project = user.projects.first
      sign_in_as user

      get edit_project_url(project)

      expect(response).to be_successful
    end

    it "does not render a successful response if the user is not an owner" do
      project = create(:valid_project)
      user = create(:user)
      create(:project_user, user:, project:, role: :member)

      sign_in_as user

      get edit_project_url(project)

      expect(response).to redirect_to projects_url
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Project" do
        user = create(:user)
        sign_in_as user
        valid_attributes = {name: "New Project"}

        expect {
          post projects_url, params: {project: valid_attributes}
        }.to change(Project, :count).by(1)

        expect(response).to redirect_to project_url(Project.last)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Project" do
        user = create(:user)
        sign_in_as user
        invalid_attributes = {name: ""}

        expect {
          post projects_url, params: {project: invalid_attributes}
        }.not_to change(Project, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    it "does not update the project if the user is not an owner" do
      project = create(:valid_project)
      user = create(:user)
      create(:project_user, user:, project:, role: :member)

      sign_in_as user

      invalid_attributes = {name: "Updated Project"}

      patch project_url(project), params: {project: invalid_attributes}

      project.reload
      expect(project.name).not_to eq("Updated Project")

      expect(response).to redirect_to projects_url
    end

    context "with valid parameters" do
      it "updates the requested project" do
        user = create(:user, :with_projects)
        project = user.projects.first

        sign_in_as user

        valid_attributes = {name: "Updated Project"}

        patch project_url(project), params: {project: valid_attributes}

        project.reload
        expect(project.name).to eq("Updated Project")

        expect(response).to redirect_to project_url(project)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        user = create(:user, :with_projects)
        project = user.projects.first
        sign_in_as user

        invalid_attributes = {name: ""}

        patch project_url(project), params: {project: invalid_attributes}

        project.reload
        expect(project.name).not_to eq("")

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested project" do
      user = create(:user, :with_projects)
      project = user.projects.first

      sign_in_as user

      expect {
        delete project_url(project)
      }.to change(Project, :count).by(-1)
      expect(response).to redirect_to projects_url
    end

    it "does not destroy the project if the user is not an owner" do
      project = create(:valid_project)
      user = create(:user)
      create(:project_user, user:, project:, role: :member)

      sign_in_as user

      expect {
        delete project_url(project)
      }.not_to change(Project, :count)
      expect(response).to redirect_to projects_url
    end
  end
end
