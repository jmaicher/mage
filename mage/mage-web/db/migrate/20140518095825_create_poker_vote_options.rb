class CreatePokerVoteOptions < ActiveRecord::Migration
  def change
    create_table :poker_vote_options do |t|
      t.string :value

      t.timestamps
    end
  end
end
