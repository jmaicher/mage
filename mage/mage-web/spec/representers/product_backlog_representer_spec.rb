require 'spec_helper'

describe ProductBacklogRepresenter do

  before :each do
    default_url_options = Rails.application.config.representer.default_url_options
    Rails.application.routes.default_url_options[:host] = default_url_options[:host]
  end

  let(:product_backlog) do
    create(:filled_product_backlog, size: 3)
  end

  it "should correctly serialize the represented product backlog to json" do
    decorator = ProductBacklogRepresenter.new(product_backlog)

    actual = decorator.to_json

    product_backlog.items.each do |item|
      expected = BacklogItemRepresenter.new(item).to_json
      expect(actual).to include_json(expected).at_path('items')
    end
    
    expect(actual).to be_json_eql(api_backlog_url.to_json).at_path('_links/self/href')
  end

end # ProductBacklogRepresenter
