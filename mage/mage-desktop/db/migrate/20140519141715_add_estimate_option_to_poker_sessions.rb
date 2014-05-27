class AddEstimateOptionToPokerSessions < ActiveRecord::Migration
  def change
    add_reference :poker_sessions, :estimate_option, index: true
  end
end
