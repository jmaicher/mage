require 'spec_helper'

describe 'Sprints::SprintBacklogItems API', integration: true do
  let(:sprint) { create :sprint }
  let(:product_backlog) { ProductBacklog.get_or_create } 
  let(:product_backlog_item) { create :product_backlog_item }
  let(:current_user) { create :user }


  before :each do
    sign_in current_user
  end

  describe 'POST /api/sprints/:id/backlog/items' do
    let(:method) { :post }
    let(:endpoint) { api_sprint_backlog_items_path(sprint) }

    it "removes the backlog item from the product backlog and assigns it to the sprint backlog" do
      params = {
        backlog_item_id: product_backlog_item.id
      }
      do_api_request_without_token params

      expect(product_backlog.items.count).to eq(0)
      expect(sprint.backlog.items.first).to eq(product_backlog_item)

      expected_response = SprintBacklogItemRepresenter.new(product_backlog_item).to_json
      actual_response = response.body

      expect(actual_response).to be_json_eql(expected_response)
      expect(response.status).to eq(201)
    end
  end # POST .../:id/backlog/items

end # Sprints::BacklogItemAssignments API
