class Task < ApplicationRecord
  after_create_commit :prepend_task
  after_update_commit :replace_task
  after_destroy_commit :remove_task

  scope :complete, ->{ where(complete: true) }
  scope :incomplete, ->{ where(complete: false) }

  def self.all_complete?
    Task.count > 0 && self.incomplete.count == 0
  end

  def uncomplete!
    update!(complete: false)
  end

  def complete!
    update!(complete: true)
  end

  private

  def prepend_task
    broadcast_prepend_to :tasks_list_all
    broadcast_prepend_to :tasks_list_active
    replace_clear_complete
    replace_complete_all_tasks
    replace_items_left
  end

  def replace_task
    broadcast_replace_to :tasks_list_all

    if complete?
      broadcast_prepend_to :tasks_list_complete
    else
      broadcast_prepend_to :tasks_list_active
    end

    replace_clear_complete
    replace_complete_all_tasks
    replace_items_left
  end

  def remove_task
    broadcast_remove_to :tasks_list_all
    broadcast_remove_to :tasks_list_active
    broadcast_remove_to :tasks_list_complete
    replace_clear_complete
    replace_complete_all_tasks
    replace_items_left
  end

  def replace_complete_all_tasks
    Turbo::StreamsChannel.broadcast_replace_to :tasks, target: "complete_all_tasks", partial: 'tasks/complete_all', locals: { all_complete: Task.all_complete? }
  end

  def replace_items_left
    Turbo::StreamsChannel.broadcast_replace_to :tasks, target: "items_left", partial: 'tasks/items_left', locals: { incomplete_items_count: Task.incomplete.count }
  end

  def replace_clear_complete
    Turbo::StreamsChannel.broadcast_replace_to :tasks, target: "clear_complete", partial: 'tasks/clear_complete', locals: { complete_count: Task.complete.count }
  end
end
