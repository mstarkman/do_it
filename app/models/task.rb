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
    broadcast_prepend_to :tasks
    replace_complete_all_tasks
  end

  def replace_task
    broadcast_replace_to :tasks
    replace_complete_all_tasks
  end

  def remove_task
    broadcast_remove_to :tasks
    replace_complete_all_tasks
  end

  def replace_complete_all_tasks
    Turbo::StreamsChannel.broadcast_replace_to :tasks, target: "complete_all_tasks", partial: 'tasks/complete_all', locals: { all_complete: Task.all_complete? }
  end
end
