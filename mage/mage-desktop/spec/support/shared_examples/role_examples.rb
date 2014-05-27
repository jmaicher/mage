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
