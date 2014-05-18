require 'spec_helper'

describe 'Poker API' do
  let(:meeting) { create :meeting }
  let(:backlog_item) { create :backlog_item }

  describe 'POST /api/meetings/:id/poker_sessions' do
    let(:method) { :post }
    let(:endpoint) { api_meeting_poker_sessions_path(meeting) }

    let(:current_device) { meeting.initiator }
    let(:authenticable) { current_device }

    it_behaves_like "authenticated API endpoint"
    it_behaves_like "meeting action"

    it "should create a new poker session and respond with the json representation" do
      params = { "poker_session" => {
        "backlog_item_id" => backlog_item.id
      }}

      do_api_request params

      expect(meeting.poker_sessions.count).to eq 1
      poker_session = meeting.poker_sessions.first
      expected_body = PokerSessionRepresenter.new(poker_session).to_json
      actual_body = response.body

      expect(response.status).to be(201)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should respond with the validation errors in case the params were invalid" do
      params = { "poker_session" => {
        "backlog_item_id" => -1
      }}

      do_api_request params
      
      session = meeting.poker_sessions.build params["poker_session"]
      session.valid? # trigger validation
      expected_body = session.errors.to_json

      expect(response.status).to be(422)
      expect(response.body).to be_json_eql(expected_body)
    end
  end # POST ../poker_sessions

end
