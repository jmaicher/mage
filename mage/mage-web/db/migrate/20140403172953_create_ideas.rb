class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :title
      t.text :description

      t.timestamps
    end

    add_reference :ideas, :author, references: :users
  end
end
