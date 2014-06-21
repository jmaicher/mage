class RenameBacklogsToProductBacklogs < ActiveRecord::Migration
  def change
    rename_table :backlogs, :product_backlogs
  end
end
