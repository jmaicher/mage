require 'spec_helper'

describe Meeting do
  it { should belong_to(:initiator).class_name('Device') }
  it { should validate_presence_of(:initiator) }

  it { should have_many(:meeting_participations) }
  it { should have_many(:participating_users)
       .through(:meeting_participations)
       .source(:meeting_participant) }
  it { should have_many(:participating_devices)
       .through(:meeting_participations)
       .source(:meeting_participant) }

  it { should have_many(:poker_sessions) }
end # Meeting

