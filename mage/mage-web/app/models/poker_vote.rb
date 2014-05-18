class PokerVote < ActiveRecord::Base
  belongs_to :poker
  belongs_to :user
  belongs_to :option, class_name: "PokerVoteOption", foreign_key: "poker_vote_option_id"
end # PokerVote
