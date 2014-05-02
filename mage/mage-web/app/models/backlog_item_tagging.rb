class BacklogItemTagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :backlog_item
end
