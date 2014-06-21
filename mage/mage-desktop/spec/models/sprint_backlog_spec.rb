require 'spec_helper'

describe SprintBacklog do
  it_behaves_like 'backlog'
  it { should belong_to(:sprint) }  

  it { should have_many(:task_assignments) }
  it { should have_many(:tasks).through(:task_assignments) }
end # SprintBacklog
