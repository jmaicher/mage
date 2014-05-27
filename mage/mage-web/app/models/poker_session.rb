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

  def is_current_round_complete?
    get_votes.count == meeting.participating_users.count
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

  def has_voted?(user, round=current_round)
    !get_vote_for(user, round).nil?
  end

  def get_vote_for(user, round=current_round)
    votes.where(user: user, round: round).first
  end

  def get_votes(round=current_round)
    votes.where(round: round)
  end

  def complete_with(decision)
    decision_key = decision.is_a?(Integer) ? :estimate_option_id : :decision
    self[decision_key] = decision
    self.status = :completed
  end

  def estimate_options
    @estimate_options ||= EstimateOption.all.to_a
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
