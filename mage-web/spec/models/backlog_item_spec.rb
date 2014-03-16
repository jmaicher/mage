require 'spec_helper'

describe BacklogItem do

  it { should validate_presence_of(:title) }
  it { should ensure_length_of(:title).is_at_least(5).is_at_most(50) }  
  
end
