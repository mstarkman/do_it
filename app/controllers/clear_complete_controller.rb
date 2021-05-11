class ClearCompleteController < ApplicationController
  def create
    Task.complete.destroy_all
    redirect_to root_url
  end
end
