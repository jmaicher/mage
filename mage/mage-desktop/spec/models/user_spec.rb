require 'spec_helper'

describe User do

  it { should have_many(:meeting_participations) }
  it { should have_many(:meetings).through(:meeting_participations) }

  let(:subject) { build :user }
  let(:persistent_subject) { create :user }

  it_behaves_like "actor"
  it_behaves_like "api authenticable"
  it_behaves_like "meeting participant"

end # User
