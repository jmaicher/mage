require 'spec_helper'

describe Meeting do
  it { should belong_to(:initiator).class_name('Device') }
  it { should validate_presence_of(:initiator) }
end

