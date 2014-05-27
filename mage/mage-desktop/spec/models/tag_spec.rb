require 'spec_helper'

describe Tag do

  it { should have_many(:backlog_item_taggings) }
  it { should have_many(:backlog_items).through(:backlog_item_taggings) }

end
