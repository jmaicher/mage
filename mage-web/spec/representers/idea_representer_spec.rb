require 'spec_helper'

describe IdeaRepresenter do

  before :each do
    default_url_options = Rails.application.config.representer.default_url_options
    Rails.application.routes.default_url_options[:host] = default_url_options[:host]
  end

  let :idea do
    create(:idea)
  end

  it "should correctly serialize the represented idea to json" do
    decorator = IdeaRepresenter.new(idea)

    actual = decorator.to_json
    
    expected = %({ \
      "id": "#{idea.id}", \
      "title": "#{idea.title}", \
      "description": "#{idea.description}", \
      "author_id": #{idea.author_id}
    })

    expect(actual).to be_json_eql(expected).excluding('_links')
  end

end # IdeaRepresenter

