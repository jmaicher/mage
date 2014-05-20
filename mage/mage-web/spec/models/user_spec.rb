require 'spec_helper'

describe User do

  it { should have_many(:meeting_participations) }
  it { should have_many(:meetings).through(:meeting_participations) }

  let(:user) { build :user }
  let(:persistent_user) { create :user }

  it "has api_token" do
    expect(user.api_token).not_to be_blank
  end

  describe "meeting participation" do
    let(:meeting) { create :meeting }

    it "should be able to participate in a meeting" do
      persistent_user.participate! meeting
      expect(meeting.participants).to include(persistent_user) 
    end

    it "the participation status should change when participating" do
      expect(persistent_user.participates_in?(meeting)).to be_false
      persistent_user.participate! meeting
      expect(persistent_user.participates_in?(meeting)).to be_true
    end

  end # meeting participation

end # User
