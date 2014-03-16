require 'spec_helper'

describe BacklogItemAssignment do

  it { should belong_to(:backlog) }
  it { should belong_to(:backlog_item) }
  it { should validate_uniqueness_of(:backlog_item_id) }
  it { should validate_uniqueness_of(:priority).allow_nil.scoped_to(:backlog_id) }
  
  describe :default_scope do

    it "should order by priority ASC, created_at DESC" do
      a1 = BacklogItemAssignment.create! backlog_id: 1, backlog_item_id: 1, priority: 2
      a2 = BacklogItemAssignment.create! backlog_id: 1, backlog_item_id: 2, priority: 1
      a3 = BacklogItemAssignment.create! backlog_id: 1, backlog_item_id: 3
      
      assignments = BacklogItemAssignment.where(backlog_id: 1)
      
      assignments.map(&:backlog_item_id).should eq [2, 1, 3]
    end

  end

end
