require "rails_helper"
RSpec.describe "/projects", type: :request do
  context "when the user does not belong to the account" do
    it "does not allow access to the projects" do
      project = create(:project)
      user = create(:user)
      expect(user.accounts).not_to include(project.account)
      sign_in_as user

      # Index
      get account_projects_url(project.account)
      expect(response).to have_http_status(:not_found)

      # Show
      get account_project_url(project.account, project)
      expect(response).to have_http_status(:not_found)

      # New
      get new_account_project_url(project.account)
      expect(response).to have_http_status(:not_found)

      # Edit

      get edit_account_project_url(project.account, project)
      expect(response).to have_http_status(:not_found)

      # Create
      post account_projects_url(project.account), params: {project: {name: "New Project"}}
      expect(response).to have_http_status(:not_found)

      # Update
      patch account_project_url(project.account, project), params: {project: {name: "Updated Project"}}
      expect(response).to have_http_status(:not_found)

      # Destroy
      delete account_project_url(project.account, project)
      expect(response).to have_http_status(:not_found)
    end
  end
  context "when the user belongs to the account" do
    describe "GET /index" do
      it "renders all the account's projects" do
        account = create(:account)
        user = create(:user, accounts: [account])
        projects = create_list(:project, 3, account: account)
        sign_in_as user

        get account_projects_url(account: account)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include projects.map(&:name)
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        project = create(:project)
        user = create(:user, accounts: [project.account])

        sign_in_as user
        get account_project_url(project, account: project.account)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include project.name
      end
    end

    describe "GET /new" do
      it "renders a successful response" do
        project = create(:project)
        user = create(:user, accounts: [project.account])
        sign_in_as user

        get new_account_project_url(account: project.account)

        expect(response).to be_successful
      end
    end

    describe "GET /edit" do
      it "renders a successful response" do
        project = create(:project)
        user = create(:user, accounts: [project.account])
        sign_in_as user

        get edit_account_project_url(project, account: project.account)

        expect(response).to be_successful
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Project" do
          user = create(:user)
          sign_in_as user
          valid_attributes = {name: "New Project"}

          expect {
            post account_projects_url(account: user.accounts.first), params: {project: valid_attributes}
          }.to change(Project, :count).by(1)

          expect(response).to redirect_to account_project_url(Project.last, account: user.accounts.first)
        end
      end

      context "with invalid parameters" do
        it "does not create a new Project" do
          user = create(:user)
          sign_in_as user
          invalid_attributes = {name: ""}

          expect {
            post account_projects_url(account: user.accounts.first), params: {project: invalid_attributes}
          }.not_to change(Project, :count)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH /update" do
      context "with valid parameters" do
        it "updates the requested project" do
          project = create(:project)
          user = create(:user, accounts: [project.account])

          sign_in_as user

          valid_attributes = {name: "Updated Project"}

          patch account_project_url(project, account: project.account), params: {project: valid_attributes}

          project.reload
          expect(project.name).to eq("Updated Project")

          expect(response).to redirect_to account_project_url(project, account: project.account)
        end
      end

      context "with invalid parameters" do
        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          project = create(:project)
          user = create(:user, accounts: [project.account])
          sign_in_as user

          invalid_attributes = {name: ""}

          patch account_project_url(project, account: project.account), params: {project: invalid_attributes}

          project.reload
          expect(project.name).not_to eq("")

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested project" do
        project = create(:project)
        user = create(:user, accounts: [project.account])

        sign_in_as user

        expect {
          delete account_project_url(project, account: project.account)
        }.to change(Project, :count).by(-1)
        expect(response).to redirect_to account_projects_url(account: project.account)
      end
    end
  end
end
