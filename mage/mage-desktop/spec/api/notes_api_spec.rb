require 'spec_helper'

describe 'Notes API' do

  let(:authenticable) { create :user }

  describe 'GET /api/notes' do
    let(:method) { :get }
    let(:endpoint) { "/api/notes" }

    before :each do
      3.times do |i|
        create(:note)
      end
    end

    it_behaves_like "authenticated API endpoint"

    it "responds with serializd notes collection" do
      do_api_request

      notes = Note.all
      # Note: Missing host to link to! error when generating urls in test
      coll = API::Collection.new(notes, self: "")
      expected_body = CollectionRepresenter.new(coll).to_json
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body).excluding('_links')
    end

  end # GET /api/notes


  describe 'POST /api/notes' do
    let(:method) { :post }
    let(:endpoint) { "/api/notes" }

    it "should create an note with the given params and respond with the json representation" do
      params = attributes_for(:note)
      do_api_request params

      expect(Note.count).to eq 1
      note = Note.first

      expect(note.title).to eq params[:title]
      expect(note.description).to eq params[:description]

      expected_body = NoteRepresenter.new(note).to_json
      actual_body = response.body

      expect(response.status).to eq(201)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should not create an note when the params are invalid and should respond with validation errors" do
      params = { title: "", description: "" }
      do_api_request params

      expect(Note.count).to eq 0

      note = Note.new(params)
      note.valid? # trigger validation

      expected_body = note.errors.to_json
      actual_body = response.body

      expect(response.status).to eq(422)
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # POST /api/notes

end
