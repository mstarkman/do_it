class Task < ApplicationRecord
  after_create_commit { broadcast_prepend_to :tasks } # This doesn't work unless you refresh the page after the first update (authenticity token issue)
  after_update_commit { broadcast_replace_to :tasks } # This doesn't work unless you refresh the page after the first update (authenticity token issue)
  after_destroy_commit { broadcast_remove_to :tasks }
end
