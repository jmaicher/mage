require 'spec_helper'

describe PokerVote do

  it { should belong_to(:poker) }
  it { should belong_to(:user) }
  it { should belong_to(:option).class_name("PokerVoteOption").with_foreign_key("poker_vote_option_id") }

end # PokerVote
