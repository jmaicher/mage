require 'spec_helper'

describe Note do
  it { should belong_to(:author).class_name('User') }

  it { should validate_presence_of(:title) }
  it { should ensure_length_of(:title).is_at_least(5).is_at_most(50) }
end
