require 'spec_helper'

describe BacklogItemRepresenter do

  let(:backlog_item) do
    create(:product_backlog_item)
  end

  it "should correctly serialize the represented backlog item to json" do
    decorator = BacklogItemRepresenter.new(backlog_item)

    expected = %({ \
      "title": "#{backlog_item.title}", \
      "description": "#{backlog_item.description}" \
    })

    
    actual = decorator.to_json
    expect(actual).to be_json_eql(expected).excluding(:_links)
  end

end # BacklogItemRepresenter
