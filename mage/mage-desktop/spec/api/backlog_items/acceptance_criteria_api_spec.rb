require 'spec_helper'

describe 'BacklogItems::AcceptanceCriteria API', integration: true do
  let(:backlog_item) { create :backlog_item }
  let(:current_user) { create :user }

  before :each do
    sign_in current_user
  end

  describe 'POST /api/backlog_items/:id/acceptance_criteria' do
    let(:method) { :post }
    let(:endpoint) { api_backlog_item_acceptance_criteria_path(backlog_item) }

    it "should create a new acceptance criteria" do
      params = { description: "This is a new acceptance criteria" }
      do_api_request_without_token params

      expect(response.status).to eq(201)
      expect(AcceptanceCriteria.count).to eq(1)

      criteria = AcceptanceCriteria.last
      expect(criteria.description).to eq(params[:description])
      expect(criteria.backlog_item).to eq(backlog_item)
    end

    it "should fail if the params are invalid and respond with the validation errors" do
      params = {}
      do_api_request_without_token params

      actual_body = response.body

      criteria = backlog_item.acceptance_criteria.new params
      # trigger validation
      criteria.valid?
      expected_body = criteria.errors.to_json
    
      expect(response.status).to eq(422)
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # POST ../acceptance_criteria

end # BacklogItems::AcceptanceCriteria API
