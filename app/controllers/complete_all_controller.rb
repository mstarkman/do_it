class CompleteAllController < ApplicationController
  def create
    if params[:mark_incomplete] == "true"
      Task.complete.each(&:uncomplete!)
    else
      Task.incomplete.each(&:complete!)
    end

    redirect_to root_url
  end
end
