require 'spec_helper'

describe 'BacklogItems::AcceptanceCriteria API' do
  let(:backlog_item) { create :backlog_item }
  let(:current_user) { create :user }
  let(:authenticable) { current_user }

  describe 'POST /api/backlog_items/:id/acceptance_criteria' do
    let(:method) { :post }
    let(:endpoint) { api_backlog_item_acceptance_criteria_path(backlog_item) }

    it "should work" do
      do_api_request
      expect(response.status).to eq(200)
    end
  end # POST ../acceptance_criteria

end # BacklogItems::AcceptanceCriteria API
