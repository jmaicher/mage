class CreatePokerVotes < ActiveRecord::Migration
  def change
    create_table :poker_votes do |t|
      t.references :poker, index: true
      t.references :user, index: true
      t.references :poker_vote_option, index: true

      t.timestamps
    end
  end 
end
