class Task < ApplicationRecord
  after_create_commit { broadcast_prepend_to :tasks }
  after_update_commit { broadcast_replace_to :tasks }
  after_destroy_commit { broadcast_remove_to :tasks }

  scope :incomplete, ->{ where(complete: false) }

  def self.all_complete?
    self.incomplete.count == 0
  end

  def complete!
    update!(complete: true)
  end
end
