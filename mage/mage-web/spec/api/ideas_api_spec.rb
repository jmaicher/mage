require 'spec_helper'

describe 'Ideas API' do

  let(:authenticable) { create :user }

  describe 'GET /api/ideas' do
    let(:method) { :get }
    let(:endpoint) { "/api/ideas" }

    before :each do
      3.times do |i|
        create(:idea)
      end
    end

    it_behaves_like "authenticated API endpoint"

    it "responds with serializd ideas collection" do
      do_api_request

      ideas = Idea.all.map { |idea| IdeaRepresenter.new(idea) }
      # Note: Missing host to link to! error when generating urls in test
      coll = API::Collection.new(ideas, self: "")
      expected_body = CollectionRepresenter.new(coll).to_json
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body).excluding('_links')
    end

  end # GET /api/ideas


  describe 'POST /api/ideas' do
    let(:method) { :post }
    let(:endpoint) { "/api/ideas" }

    it "should create an idea with the given params and respond with the json representation" do
      params = { idea: attributes_for(:idea) }
      do_api_request params

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
      do_api_request params

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
