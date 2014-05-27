class PokerVote < ActiveRecord::Base
  belongs_to :poker_session
  validates_presence_of :poker_session

  belongs_to :user
  validates_presence_of :user

  belongs_to :decision, class_name: "EstimateOption", foreign_key: "estimate_option_id"
  validates_presence_of :decision

  validates_presence_of :round
end # PokerVote
