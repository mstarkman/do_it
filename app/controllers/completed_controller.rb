class CompletedController < ApplicationController
  def index
    @tasks = Task.complete.order(created_at: :desc)
    @all_complete = Task.all_complete?
    @incomplete_items_count = Task.incomplete.count
    @complete_count = Task.complete.count
  end
end
