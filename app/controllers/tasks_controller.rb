class TasksController < ApplicationController
  layout false, only: [:create]
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def create
    task = Task.create!(task_params)

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end

  def update
    task = Task.find(params[:id])
    task.update!(task_params)
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
    p = params.require(:task).permit(:body, :complete)

    if p.has_key?(:complete)
      p[:complete] = p[:complete] == "1"
    end

    p
  end
end
