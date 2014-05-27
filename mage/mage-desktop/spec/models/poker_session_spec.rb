require 'spec_helper'

describe PokerSession do
  let(:subject) { create :poker_session }

  it { should belong_to(:meeting) }
  it { should validate_presence_of(:meeting) }

  it { should belong_to(:backlog_item) }
  it { should validate_presence_of(:backlog_item) }

  it { should have_many(:votes).class_name("PokerVote") }

  it { should belong_to(:decision).class_name("EstimateOption").with_foreign_key("estimate_option_id") }

  describe "poker votes" do

    it "can check whether a user has voted in the current round" do
      user = create :user
      vote = build :poker_vote, user: user, round: subject.current_round

      expect(subject.has_voted?(user)).to be_false

      subject.votes << vote
      
      expect(subject.has_voted?(user)).to be_true
    end

    it "considers the different rounds when checking whether a user has voted" do
      user = create :user
      vote = build :poker_vote, user: user, round: subject.current_round
      
      subject.votes << vote
      subject.start_new_round!
      
      expect(subject.has_voted?(user)).to be_false
    end

  end

end # PokerSession
