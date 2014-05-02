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

end
