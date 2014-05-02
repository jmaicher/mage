require 'spec_helper'

describe BacklogItemRepresenter do

  let(:backlog_item) do
    create(:backlog_item_with_tags)
  end

  it "should correctly serialize the represented backlog item to json" do
    decorator = BacklogItemRepresenter.new(backlog_item)

    expected = %({ \
      "id": "#{backlog_item.id}", \
      "title": "#{backlog_item.title}", \
      "description": "#{backlog_item.description}" \
    })

    # Raises argument error: Missing host to link to!
    #expected_links = %({ \
      #"self": "#{api_backlog_item_url(backlog_item)}", \
      #"tags": "#{api_backlog_item_tags_url(backlog_item)}"
    #})
    
    expected_taggings = backlog_item.taggings.map do |tagging|
      BacklogItems::TaggingRepresenter.new(tagging)
    end.to_json

    actual = decorator.to_json
    expect(actual).to be_json_eql(expected).excluding('_links').excluding('taggings')
    expect(actual).to have_json_path('_links')
    # expect(actual).to include_json(expected_links)
    expect(actual).to include_json(expected_taggings)
  end

end # BacklogItemRepresenter
