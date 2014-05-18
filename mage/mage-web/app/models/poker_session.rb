class PokerSession < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :backlog_item
  has_many :votes, class_name: "PokerVote"

  validates_presence_of :meeting
  validates_presence_of :backlog_item
end # PokerSession
