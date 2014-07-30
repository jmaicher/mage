require 'spec_helper'

describe 'BacklogItems::Taggings API' do
  let(:current_device) { create :device }
  let(:authenticable) { current_device }

  before :each do
    @backlog_item = create :backlog_item_with_tags
  end

  describe 'GET /api/backlog_items/:id/taggings' do
    let(:method) { :get }
    let(:endpoint) {api_backlog_item_taggings_path(@backlog_item) }

    it_behaves_like "authenticated API endpoint"

    it "respond with serialized taggings collection" do
      do_api_request

      taggings = @backlog_item.taggings      
      expected_body = CollectionRepresenter.new(API::Collection.new(taggings)).to_json
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # index

  describe 'GET /api/backlog_@items/:id/taggings/:id' do
    let(:method) { :get }
    let(:endpoint) {api_backlog_item_tagging_path(@backlog_item, tagging) }

    it_behaves_like "authenticated API endpoint"
    
    let :tagging do
      create(:backlog_item_tagging, backlog_item: @backlog_item)
    end

    it "should respond with the serialized tagging" do
      do_api_request
      
      expected_body = BacklogItemTaggingRepresenter.new(tagging).to_json
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # show

  describe 'POST /api/backlog_items/:id/taggings' do
    let(:method) { :post }
    let(:endpoint) {api_backlog_item_taggings_path(@backlog_item) }

    it_behaves_like "authenticated API endpoint"

    let :tag do
      create(:tag)
    end

    it "should create a tagging for a new tag and respond with the serialized tagging" do
      new_tag_name = 'Definately a new tag!'
      params = { tag: { name: new_tag_name } }

      do_api_request params

      # Creates a new tag.. 
      tagging = @backlog_item.taggings.last

      expect(tagging.tag.name).to eq(new_tag_name)
      expect(tagging.tag).to be_persisted

      # .. and responds with serialized tagging
      expected_body = BacklogItemTaggingRepresenter.new(tagging).to_json
      actual_body = response.body

      expect(response.status).to eq(201)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should create a tagging for an existing tag and respond with the serialized tagging" do
      existing_tag_name = tag.name
      params = { tag: { name: existing_tag_name } }
      
      tag_count = Tag.count
      do_api_request params
      
      # Should not create new tag
      expect(Tag.count).to eql(tag_count)

      tagging = @backlog_item.taggings.last
      expect(tagging.tag.name).to eq(existing_tag_name)

      # .. and responds with serialized tagging
      expected_body = BacklogItemTaggingRepresenter.new(tagging).to_json
      actual_body = response.body

      expect(response.status).to eq(201)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should not create a tagging if there is already one for the tag" do
      existing_tagging = @backlog_item.taggings.last
      existing_tag_name = existing_tagging.tag.name
      params = { tag: { name: existing_tag_name } }
      
      tagging_count = @backlog_item.taggings.count
      do_api_request params
      
      # Should not create new tag
      expect(@backlog_item.taggings.count).to eql(tagging_count)

      # .. and responds with serialized tagging
      expected_body = BacklogItemTaggingRepresenter.new(existing_tagging).to_json
      actual_body = response.body

      expect(response.status).to eq(409) # conflict
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # create


  describe 'DELETE /api/backlog_items/:id/taggings/:id' do
    let(:method) { :delete }
    let(:endpoint) {api_backlog_item_tagging_path(@backlog_item, tagging) }

    let(:tagging) { @backlog_item.taggings.last }

    it_behaves_like "authenticated API endpoint"

    it "destroys the tagging" do
      tagging_count = @backlog_item.taggings.count

      do_api_request

      # Should destroy the tagging..
      @backlog_item.taggings.reload
      expect(@backlog_item.taggings.count).to eq(tagging_count - 1)
      expect(@backlog_item.taggings).to_not include(tagging)
      
      # ..and respond with ok
      expect(response.status).to eq(200)
    end

  end # destroy

end
