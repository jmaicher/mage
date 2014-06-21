shared_examples_for "backlog" do

  it { should have_many(:backlog_item_assignments) }
  it { should have_many(:items).through(:backlog_item_assignments).source(:backlog_item) }

  describe "#insert" do

    let(:item) { build(:backlog_item) }

    it "should insert the given backlog item with no specific priority" do
      subject.insert(item)
      assignment = subject.backlog_item_assignments.first
      assignment.priority.should be_nil
    end

    context "when the backlog is persisted" do
      before :each do
        subject.save
      end

      it "should persist a new backlog item if the backlog is persisted" do
        subject.insert(item)
        item.should be_persisted 
      end
    end

  end # insert

end
