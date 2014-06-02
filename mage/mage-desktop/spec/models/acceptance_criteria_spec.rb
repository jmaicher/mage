require 'spec_helper'

describe AcceptanceCriteria do
  it { should belong_to(:backlog_item) }

  it { should validate_presence_of :description }
  it { should ensure_length_of(:description).is_at_least(5).is_at_most(150) }
end # AcceptanceCriteria
