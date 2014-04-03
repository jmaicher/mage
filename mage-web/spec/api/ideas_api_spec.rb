require 'spec_helper'

describe 'Ideas API' do

  describe 'GET /api/ideas' do
  end # GET /api/ideas


  describe 'POST /api/ideas' do

    def do_request(params)
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post "/api/ideas", params.to_json, headers
    end

    it "should create an idea with the given params and respond with the json representation" do
      params = { idea: attributes_for(:idea) }
      do_request params

      expect(Idea.count).to eq 1
      idea = Idea.first

      expect(idea.title).to eq params[:idea][:title]
      expect(idea.description).to eq params[:idea][:description]

      expected_body = IdeaRepresenter.new(idea).to_json
      actual_body = response.body

      expect(response.status).to eq(201)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should not create an idea when the params are invalid and should respond with validation errors" do
      params = { idea: { title: "", description: "" } } 
      do_request params

      expect(Idea.count).to eq 0

      idea = Idea.new(params[:idea])
      idea.valid? # trigger validation

      expected_body = idea.errors.to_json
      actual_body = response.body

      expect(response.status).to eq(422)
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # POST /api/ideas

end
