class TasksController < ApplicationController
  before_action :set_project
  before_action :require_ownership!, only: %i[edit update destroy]
  before_action :set_task, only: %i[show edit update destroy]

  # GET /tasks or /tasks.json
  def index
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = @project.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = @project.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to project_task_path(@project, @task), notice: "Task was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to project_task_path(@project, @task), notice: "Task was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to project_tasks_path(@project), status: :see_other, notice: "Task was successfully destroyed." }
    end
  end

  private

  def user_projects
    Current.user.projects
  end

  def require_ownership!
    unless @project.project_users.exists?(user: Current.user, role: :owner)
      redirect_back fallback_location: projects_path, alert: "You are not authorized to perform this action."
    end
  end

  def set_project
    @project = user_projects.includes(:tasks).find(params.expect(:project_id))
  end

  def set_task
    @task = @project.tasks.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.expect(task: [:name, :description, :is_active])
  end
end
