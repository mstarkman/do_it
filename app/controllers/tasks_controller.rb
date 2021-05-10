class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    @tasks = Task.all.order(created_at: :desc)
    @all_complete = Task.all_complete?
  end

  def show
    @all_complete = Task.all_complete?
  end

  def create
    @task = Task.create!(task_params)

    redirect_to root_url
  end

  def update
    @task.update!(task_params)

    redirect_to @task
  end

  def destroy
    @task.destroy!
  end

  private

  def task_params
    params.require(:task).permit(:body)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
