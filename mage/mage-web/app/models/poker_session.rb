class PokerSession < ActiveRecord::Base
  extend Enumerize

  belongs_to :meeting
  validates_presence_of :meeting

  belongs_to :backlog_item
  validates_presence_of :backlog_item

  has_many :votes, class_name: "PokerVote"

  enumerize :status, in: [:started, :restarted, :completed], default: :started, predicates: true

  def current_round
    rounds
  end
end # PokerSession
