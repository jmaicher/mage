require 'spec_helper'

describe PokerVote do
  it { should belong_to(:poker_session) }
  it { should validate_presence_of(:poker_session) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }

  it { should belong_to(:decision).class_name("EstimateOption").with_foreign_key("estimate_option_id") }
  it { should validate_presence_of(:decision) }

  it { should validate_presence_of(:round) }
end # PokerVote
