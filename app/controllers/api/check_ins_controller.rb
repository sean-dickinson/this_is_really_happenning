class Api::CheckInsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_task

  def create
    respond_to :json

    @task.check_ins.create!(check_in_params)

    head :created
  end

  private

  def check_in_params
    params.permit(:metadata)
  end

  def set_task
    @task = Task.find_by!(uuid: params.require(:uuid))
  end
end
