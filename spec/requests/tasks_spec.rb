require "rails_helper"

RSpec.describe "/projects/:project_id/tasks", type: :request do
  describe "GET /index" do
    context "when the user does not have access to the project" do
      it "cannot view the tasks" do
        project = create(:valid_project)
        create_list(:task, 3, project: project)
        user = create(:user)
        expect(project.users).not_to include(user)
        sign_in_as user

        get project_tasks_url(project)
        expect(response).to have_http_status(:not_found)
      end

      it "cannot view the show page for the task" do
        project = create(:valid_project)
        task = create(:task, project: project)
        user = create(:user)
        expect(project.users).not_to include(user)
        sign_in_as user

        get project_task_url(project, task)
        expect(response).to have_http_status(:not_found)
      end

      it "cannot view the new task page" do
        project = create(:valid_project)
        user = create(:user)
        expect(project.users).not_to include(user)
        sign_in_as user

        get new_project_task_url(project)
        expect(response).to have_http_status(:not_found)
      end

      it "cannot view the edit page for the task" do
        project = create(:valid_project)
        task = create(:task, project: project)
        user = create(:user)
        expect(project.users).not_to include(user)

        sign_in_as user
        get edit_project_task_url(project, task)

        expect(response).to have_http_status(:not_found)
      end

      it "cannot update the task" do
        project = create(:valid_project)
        task = create(:task, project: project)
        user = create(:user)
        expect(project.users).not_to include(user)

        sign_in_as user
        patch project_task_url(project, task), params: {task: {name: "Updated Task"}}

        expect(response).to have_http_status(:not_found)
      end

      it "cannot destroy the task" do
        project = create(:valid_project)
        task = create(:task, project: project)
        user = create(:user)
        expect(project.users).not_to include(user)

        sign_in_as user
        delete project_task_url(project, task)

        expect(response).to have_http_status(:not_found)
      end
    end
    it "renders a successful response" do
      task = create(:task)
      user = task.project.users.first

      sign_in_as user
      get project_tasks_url(task.project, task)

      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      task = create(:task)
      user = task.project.users.first

      sign_in_as user
      get project_task_url(task.project, task)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      project = create(:valid_project)
      user = project.users.first

      sign_in_as user
      get new_project_task_url(project)

      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      task = create(:task)
      user = task.project.users.first

      sign_in_as user
      get edit_project_task_url(task.project, task)

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Task" do
        project = create(:valid_project)
        user = project.users.first

        sign_in_as user
        valid_attributes = {
          name: "New Task",
          description: "Task description",
          is_active: true
        }
        expect {
          post project_tasks_url(project), params: {task: valid_attributes}
        }.to change(Task, :count).by(1)

        expect(response).to redirect_to(project_task_url(project, Task.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Task" do
        project = create(:valid_project)
        user = project.users.first
        sign_in_as user
        invalid_attributes = {
          name: ""
        }
        expect {
          post project_tasks_url(project), params: {task: invalid_attributes}
        }.to change(Task, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested task" do
        task = create(:task)
        user = task.project.users.first
        valid_attributes = {
          name: "Updated Task"
        }
        sign_in_as user
        patch project_task_url(task.project, task), params: {task: valid_attributes}
        expect(response).to redirect_to(project_task_url(task.project, task))

        task.reload
        expect(task.name).to eq("Updated Task")
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        task = create(:task)
        user = task.project.users.first
        invalid_attributes = {name: ""}
        sign_in_as user

        patch project_task_url(task.project, task), params: {task: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        task.reload
        expect(task.name).not_to eq("")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested task" do
      task = create(:task)
      user = task.project.users.first

      sign_in_as user
      expect {
        delete project_task_url(task.project, task)
      }.to change(Task, :count).by(-1)
      expect(response).to redirect_to(project_tasks_url(task.project))
    end
  end
end
