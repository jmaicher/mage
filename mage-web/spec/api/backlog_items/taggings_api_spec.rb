require 'spec_helper'

describe 'BacklogItems/Tags API' do

  before :each do
    @item = create(:backlog_item_with_tags)
  end

  describe 'GET /api/backlog_items/:id/taggings' do

    it "respond with serialized taggings collection" do
      get "/api/backlog_items/#{@item.id}/taggings"
      
      expected_body = CollectionRepresenter.new(API::Collection.new(@item.taggings)).to_json
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # index

  describe 'GET /api/backlog_@items/:id/taggings/:id' do
    
    let :tagging do
      create(:backlog_item_tagging, backlog_item: @item)
    end

    it "should respond with the serialized tagging" do
      get "/api/backlog_items/#{@item.id}/taggings/#{tagging.id}"
      
      expected_body = BacklogItems::TaggingRepresenter.new(tagging).to_json
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # show

  describe 'POST /api/backlog_items/:id/taggings' do

    let :tag do
      create(:tag)
    end

    def do_request(params)
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post "/api/backlog_items/#{@item.id}/taggings", params.to_json, headers
    end

    it "should create a tagging for a new tag and respond with the serialized tagging" do
      new_tag_name = 'Definately a new tag!'
      params = { tag: { name: new_tag_name } }

      do_request params

      # Creates a new tag.. 
      tagging = @item.taggings.last

      expect(tagging.tag.name).to eq(new_tag_name)
      expect(tagging.tag).to be_persisted

      # .. and responds with serialized tagging
      expected_body = BacklogItems::TaggingRepresenter.new(tagging).to_json
      actual_body = response.body

      expect(response.status).to eq(201)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should create a tagging for an existing tag and respond with the serialized tagging" do
      existing_tag_name = tag.name
      params = { tag: { name: existing_tag_name } }
      
      tag_count = Tag.count
      do_request params
      
      # Should not create new tag
      expect(Tag.count).to eql(tag_count)

      tagging = @item.taggings.last
      expect(tagging.tag.name).to eq(existing_tag_name)

      # .. and responds with serialized tagging
      expected_body = BacklogItems::TaggingRepresenter.new(tagging).to_json
      actual_body = response.body

      expect(response.status).to eq(201)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should not create a tagging if there is already one for the tag" do
      existing_tagging = @item.taggings.last
      existing_tag_name = existing_tagging.tag.name
      params = { tag: { name: existing_tag_name } }
      
      tagging_count = @item.taggings.count
      do_request params
      
      # Should not create new tag
      expect(@item.taggings.count).to eql(tagging_count)

      # .. and responds with serialized tagging
      expected_body = BacklogItems::TaggingRepresenter.new(existing_tagging).to_json
      actual_body = response.body

      expect(response.status).to eq(409) # conflict
      expect(actual_body).to be_json_eql(expected_body)
    end

  end # create


  describe 'DELETE /api/backlog_items/:id/taggings/:id' do

    it "destroys the tagging" do
      tagging = @item.taggings.last
      tagging_count = @item.taggings.count

      delete "/api/backlog_items/#{@item.id}/taggings/#{tagging.id}"

      # Should destroy the tagging..
      @item.taggings.reload
      expect(@item.taggings.count).to eq(tagging_count - 1)
      expect(@item.taggings).to_not include(tagging)
      
      # ..and respond with ok
      expect(response.status).to eq(200)
    end

  end # destroy

end
