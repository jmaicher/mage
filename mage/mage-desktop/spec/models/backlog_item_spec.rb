require 'spec_helper'

describe BacklogItem do

  it { should validate_presence_of(:title) }
  it { should ensure_length_of(:title).is_at_least(5).is_at_most(50) }  

  it { should have_one(:backlog_assignment).class_name("BacklogItemAssignment") }
  it { should have_one(:backlog).through(:backlog_assignment) }

  it { should have_many(:taggings).class_name("BacklogItemTagging") }
  it { should have_many(:tags).through(:taggings) }

  it_behaves_like "activity object"

  describe "#tag_list" do
    
    it "should be empty string if there are no tags" do
      expect(subject.tag_list).to eq ""
    end

    it "should be tag's name if there is one tag" do
      subject.tags.build name: "tag-1"
      expect(subject.tag_list).to eq "tag-1"
    end

    it "should be comma-separated tag names if there are multiple tags" do
      subject.tags.build name: "tag-1"
      subject.tags.build name: "tag-2"
      subject.tags.build name: "tag-3"

      expect(subject.tag_list).to eq "tag-1, tag-2, tag-3"
    end

  end # #tag_list

  describe "#tag_list=" do

    it "removes all tags if empty string is given" do
      subject.tags.build name: "tag-1"
      subject.tag_list = ""

      expect(subject.tags.length).to eq(0)
    end

    context "with single tag name" do

      it "finds tag by given name and assigns it" do
        tag = Tag.create! name: "tag-1"
        subject.tag_list = "tag-1"
        expect(subject.tags.to_a).to eq [tag]
      end

      it "creates new tag if tag is not there and assigns it" do
        subject.tag_list = "tag-1"
        expect(subject.tags.first.name).to eq "tag-1"
        expect(Tag.count).to eq 1
      end

    end # with single tag name

    context "with multiple tag names" do

      it "splits tag names by comma and finds tags by trimmed names and assigns them" do
        tags = [
          Tag.create!(name: "tag-1"),
          Tag.create!(name: "tag-2"),
          Tag.create!(name: "tag-3")
        ]

        subject.tag_list = "tag-1, tag-2, tag-3"
        expect(subject.tags.to_a).to eq tags
      end


      it "creates new tag if tag is not there and assigns it" do
        tag = Tag.create!(name: "tag-1")
        
        subject.tag_list = "tag-1, tag-2"

        expect(subject.tags.last.name).to eq "tag-2"
        expect(Tag.count).to eq 2
      end

    end # with multiple tag names

  end
  
end
