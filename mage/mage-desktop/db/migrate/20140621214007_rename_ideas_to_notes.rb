class RenameIdeasToNotes < ActiveRecord::Migration
  def change
    rename_table :ideas, :notes
  end
end
