class Tag < ActiveRecord::Base

  has_many :backlog_item_taggings
  has_many :backlog_items, through: :backlog_item_taggings

end
