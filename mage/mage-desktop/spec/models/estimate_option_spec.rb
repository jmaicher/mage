require 'spec_helper'

describe EstimateOption do
  it { should validate_presence_of(:value) }
  it { should validate_uniqueness_of(:value) }
end # EstimateOption
