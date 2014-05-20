class CreatePokerSessions < ActiveRecord::Migration
  def change
    create_table :poker_sessions do |t|
      t.references :meeting, index: true
      t.references :backlog_item, index: true

      t.timestamps
    end
  end
end
