require 'spec_helper'

describe User do

  let :user do
    build :user
  end

  let :persisted_user do
    create :user
  end

  it "has api_token" do
    expect(user.api_token).not_to be_blank
  end

end # User
