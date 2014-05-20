class AddStatusAndRoundsToPokerSessions < ActiveRecord::Migration
  def change
    add_column :poker_sessions, :status, :string
    add_column :poker_sessions, :rounds, :integer, default: 1
  end
end
