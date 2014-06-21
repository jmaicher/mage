require 'spec_helper'

describe TaskAssignment do
  it { should belong_to(:task) }
  it { should validate_uniqueness_of(:task_id) }

  it { should belong_to(:backlog_item) }
  it { should belong_to(:sprint_backlog) }
end
