require 'spec_helper'

describe BacklogItem do

  it { should validate_presence_of(:title) }
  it { should ensure_length_of(:title).is_at_least(5).is_at_most(50) }  

  it { should have_one(:backlog_assignment).class_name("BacklogItemAssignment") }
  it { should have_one(:backlog).through(:backlog_assignment) }

  it { should have_many(:taggings).class_name("BacklogItemTagging") }
  it { should have_many(:tags).through(:taggings) }
  
end
