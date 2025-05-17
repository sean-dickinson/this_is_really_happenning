class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :require_ownership!, only: %i[edit update destroy]

  def index
    @projects = user_projects
  end

  def show
  end

  def new
    @project = user_projects.build
  end

  def edit
  end

  def create
    @project = user_projects.build(project_params)
    @project.project_users.build(user: Current.user, role: :owner)

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_path(@project), notice: "Project was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_path(@project), notice: "Project was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    if @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_path, status: :see_other, notice: "Project was successfully destroyed." }
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_path, status: :unprocessable_entity, alert: "Project could not be destroyed." }
      end
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
    @project = user_projects.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.expect(project: [:name])
  end
end
