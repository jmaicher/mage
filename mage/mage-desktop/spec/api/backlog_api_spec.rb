require 'spec_helper'

describe 'Backlog API' do

  describe 'GET /api/backlog' do
    before :each do
      @backlog = create(:filled_product_backlog, size: 3)
    end

    it 'returns the backlog' do
      get '/api/backlog' 

      expected_body = ProductBacklogRepresenter.new(@backlog).to_json 
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body)
    end
  end 

  describe 'POST /api/backlog/insert', integration: true do
    let(:current_user) { create :user }
    let(:method) { :post }
    let(:endpoint) { insert_api_backlog_path }

    before :each do
      sign_in current_user
      @backlog = create(:filled_product_backlog, size: 3)
      @item = @backlog.items.first
    end

    it "inserts the given backlog item at the correct position" do
      params = {
        backlog_item_id: @item.id,
        priority: 1
      }

      assert @item.priority == nil

      do_api_request_without_token params

      expect(response.status).to eq(201)
      @item.reload
      expect(@item.priority).to eq(1)
    end

  end

end
