class Poker < ActiveRecord::Base
  self.table_name = "poker"

  belongs_to :meeting
  belongs_to :backlog_item
  has_many :votes, class_name: "PokerVote"
end # Poker
