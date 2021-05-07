class CompleteController < ApplicationController
  before_action :set_task

  def create
    @task.update!(task_params)

    redirect_to @task
  end

  private

  def task_params
    p = params.require(:task).permit(:complete)

    if p.has_key?(:complete)
      p[:complete] = p[:complete] == "1"
    end

    p
  end

  def set_task
    @task = Task.find(params[:task_id])
  end
end
