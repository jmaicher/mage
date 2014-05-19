class CreatePokerVotes < ActiveRecord::Migration
  def change
    create_table :poker_votes do |t|
      t.references :poker_session, index: true
      t.references :user, index: true
      t.references :estimate_option, index: true

      t.timestamps
    end
  end 
end
