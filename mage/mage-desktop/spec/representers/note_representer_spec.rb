require 'spec_helper'

describe NoteRepresenter do

  before :each do
    default_url_options = Rails.application.config.representer.default_url_options
    Rails.application.routes.default_url_options[:host] = default_url_options[:host]
  end

  let :note do
    create(:note)
  end

  it "should correctly serialize the represented note to json" do
    decorator = NoteRepresenter.new(note)

    actual = decorator.to_json
    
    expected = %({ \
      "id": "#{note.id}", \
      "title": "#{note.title}", \
      "description": "#{note.description}", \
      "author": #{Embedded::UserRepresenter.new(note.author).to_json}
    })

    expect(actual).to be_json_eql(expected).excluding('_links')
  end

end # NoteRepresenter

