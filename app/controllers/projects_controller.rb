class ProjectsController < ApplicationController
  before_action :require_account
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = @account.projects
  end

  def show
  end

  def new
    @project = @account.projects.build
  end

  def edit
  end

  def create
    @project = @account.projects.build(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to account_project_path(@account, @project), notice: "Project was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to account_project_path(@account, @project), notice: "Project was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to account_projects_path(@account), status: :see_other, notice: "Project was successfully destroyed." }
    end
  end

  private

  def require_account
    @account = Current.user.accounts.find(params.expect(:account))
    raise ActiveRecord::RecordNotFound unless @account
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = @account.projects.find!(params.expect(:id))
    raise ActiveRecord::RecordNotFound unless @project
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.expect(project: [:name])
  end
end
