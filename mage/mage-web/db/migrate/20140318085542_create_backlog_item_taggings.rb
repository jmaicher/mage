class CreateBacklogItemTaggings < ActiveRecord::Migration
  def change
    create_table :backlog_item_taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :backlog_item, index: true

      t.timestamps
    end
  end
end
