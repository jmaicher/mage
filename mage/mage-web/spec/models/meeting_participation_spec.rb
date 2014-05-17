require 'spec_helper'

describe MeetingParticipation do

  it { should belong_to(:meeting) }
  it { should belong_to(:user) }

end # MeetingParticipation
