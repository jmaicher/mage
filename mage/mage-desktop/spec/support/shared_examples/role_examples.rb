shared_examples_for "actor" do
  it { should have_many(:activities_as_actor).class_name("Activity") }

  it "should allow to create activities" do
    subject.create_activity! 'activity.new'
    expect(Activity.last.actor).to eq(subject)
  end
end

shared_examples_for "activity object" do
  it { should have_many(:activities_as_object).class_name("Activity") }
end

shared_examples_for "activity context" do
  it { should have_many(:activities_as_context).class_name("Activity") }
end


shared_examples_for "api authenticable" do
  it "has api_token" do
    expect(subject.api_token).not_to be_blank
  end
end

shared_examples_for "meeting participant" do
  let(:meeting) { create :meeting }

  it "should be able to participate in a meeting" do
    persistent_subject.participate! meeting
    expect(persistent_subject.meetings).to include(meeting) 
  end

  it "the participation status should change when participating" do
    expect(persistent_subject.participates_in?(meeting)).to be_false
    persistent_subject.participate! meeting
    expect(persistent_subject.participates_in?(meeting)).to be_true
  end

end
