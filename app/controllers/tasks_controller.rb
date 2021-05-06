class TasksController < ApplicationController
  layout false, only: [:create]
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def create
    task = Task.create!(task_params)

    respond_to do |format|
      # format.turbo_stream { render turbo_stream: turbo_stream.prepend(:tasks, task) }
      format.html { redirect_to root_url }
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(task) }
      format.html         { redirect_to root_url }
    end
  end

  private

  def task_params
    params.require(:task).permit(:body)
  end
end
