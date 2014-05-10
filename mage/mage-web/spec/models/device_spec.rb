require 'spec_helper'

describe Device do

  let :device do
    build :device
  end

  it "has api_token" do
    expect(device.api_token).not_to be_blank
  end

end # Device
