require 'spec_helper'

describe Sprint do

  context "when not in planning" do
    before :each do
      subject.in_planning = false
    end

    it { should validate_presence_of(:goal) }
    it { should ensure_length_of(:goal).is_at_least(5).is_at_most(140) }

    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    # TODO: Separate Backlog and SprintBacklog
    it { should have_one(:backlog).class_name("SprintBacklog") }

    it "validates start_date < end_date" do
      subject.start_date = Time.now
      subject.end_date = Time.now - 1.day

      subject.valid?
      expect(subject.errors).to include(:start_date)

      subject.end_date = Time.now + 1.day
      subject.valid?
      expect(subject.errors).to_not include(:start_date)
    end

  end

end
