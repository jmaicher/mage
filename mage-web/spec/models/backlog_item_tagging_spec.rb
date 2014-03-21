require 'spec_helper'

describe BacklogItemTagging do

  it { should belong_to(:tag) }
  it { should belong_to(:backlog_item) }

end
