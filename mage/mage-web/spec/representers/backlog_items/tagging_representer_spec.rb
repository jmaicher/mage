require 'spec_helper'

describe BacklogItemTaggingRepresenter do

  before :each do
    default_url_options = Rails.application.config.representer.default_url_options
    Rails.application.routes.default_url_options[:host] = default_url_options[:host]
  end

  let(:tagging) do
    create(:backlog_item_tagging)
  end

  it "should correctly serialize the represented tag to json" do
    decorator = BacklogItemTaggingRepresenter.new(tagging)

    actual = decorator.to_json

    expected_tag = TagRepresenter.new(tagging.tag).to_json

    expected = %({ \
      "id": "#{tagging.id}", \
      "tag": #{expected_tag} \
    })

    expect(actual).to be_json_eql(expected).excluding('_links')
  end

end # BacklogItemTaggingRepresenter

