class Task < ApplicationRecord
  after_create_commit { broadcast_prepend_to :tasks }
  after_update_commit { broadcast_replace_to :tasks }
  after_destroy_commit { broadcast_remove_to :tasks }
end
