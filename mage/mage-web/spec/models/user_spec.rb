require 'spec_helper'

describe User do

  it { should have_many(:meeting_participations) }
  it { should have_many(:meetings).through(:meeting_participations) }

  let(:user) { build :user }
  let(:persisted_user) { create :user }

  it "has api_token" do
    expect(user.api_token).not_to be_blank
  end

end # User
