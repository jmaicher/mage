require 'spec_helper'

describe PokerSession do
  it { should belong_to(:meeting) }
  it { should belong_to(:backlog_item) }
  it { should have_many(:votes).class_name("PokerVote") }
end # PokerSession
