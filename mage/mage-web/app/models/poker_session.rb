class PokerSession < ActiveRecord::Base
  extend Enumerize
 
  enumerize :status, in: [:active, :completed], default: :active, predicates: true

  belongs_to :meeting
  validates_presence_of :meeting

  belongs_to :backlog_item
  validates_presence_of :backlog_item

  has_many :votes, class_name: "PokerVote"

  belongs_to :decision, class_name: "EstimateOption", foreign_key: "estimate_option_id"
  validate :estimate_option_id_exists

  def current_round
    rounds
  end

  def start_new_round
    self.rounds += 1
  end
  
  def start_new_round!
    new_round = start_new_round
    save!
    
    new_round
  end

  def build_vote_for(user, decision)
    params = { user: user, round: current_round }
    decision_key = decision.is_a?(Integer) ? :estimate_option_id : :decision
    params[decision_key] = decision

    votes.build params 
  end

  def has_voted?(user)
    has_voted_in?(user, current_round)
  end

  def has_voted_in?(user, round)
    votes.where(user: user, round: round).exists?
  end

  def complete_with(decision)
    decision_key = decision.is_a?(Integer) ? :estimate_option_id : :decision
    self[decision_key] = decision
    self.status = :completed
  end

private

  def estimate_option_id_exists
    if estimate_option_id && (!decision || decision.id != estimate_option_id)
      begin
        EstimateOption.find(estimate_option_id)
      rescue ActiveRecord::RecordNotFound
        errors.add(:decision, "estimate option does not exist")
        false
      end
    end
  end

end # PokerSession
