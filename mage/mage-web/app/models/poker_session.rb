class PokerSession < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :backlog_item
  has_many :votes, class_name: "PokerVote"
end # PokerSession
