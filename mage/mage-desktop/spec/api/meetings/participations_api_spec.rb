require 'spec_helper'

describe 'Meetings::Participation API' do
  let(:current_user) { create :user }
  let(:authenticable) { current_user }
  let(:meeting) { create :meeting }  

  describe 'POST /api/meetings/:id/participations' do
    let(:method) { :post }
    let(:endpoint) { api_meeting_participations_path(meeting) }

    it_behaves_like "authenticated API endpoint"
    it_behaves_like "meeting action"

    it "adds the current authenticable to the meeting participants" do
      do_api_request
      authenticable.participates_in?(meeting).should be_true
    end

    it "forbids the request when already participating" do
      authenticable.participate! meeting
      do_api_request
      expect(response.status).to eq(403)
    end
  end
end

