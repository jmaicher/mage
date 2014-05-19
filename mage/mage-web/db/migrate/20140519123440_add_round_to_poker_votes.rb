class AddRoundToPokerVotes < ActiveRecord::Migration
  def change
    add_column :poker_votes, :round, :integer
  end
end
