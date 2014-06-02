require 'spec_helper'

describe Device do
  let(:subject) { build :device }
  let(:persistent_subject) { create :device }

  it_behaves_like "actor"
  it_behaves_like "api authenticable"
  it_behaves_like "meeting participant"
end # Device
