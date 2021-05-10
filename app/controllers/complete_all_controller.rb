class CompleteAllController < ApplicationController
  def create
    Task.incomplete.each(&:complete!)
    redirect_to root_url
  end
end
