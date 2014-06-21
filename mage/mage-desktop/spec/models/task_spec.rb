require 'spec_helper'

describe Task do
  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_least(5).is_at_most(250) }

  it { should validate_numericality_of(:estimate) }

  it { should have_one(:assignment).class_name("TaskAssignment") }
  it { should have_one(:sprint_backlog).through(:assignment) }
  it { should have_one(:backlog_item).through(:assignment) }
end
