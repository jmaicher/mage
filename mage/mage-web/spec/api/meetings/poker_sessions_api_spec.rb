require 'spec_helper'

describe 'Meeting::PokerSessions API' do
  let(:current_device) { meeting.initiator }
  let(:current_user) { create :user }
  let(:meeting) { create :meeting }
  let(:backlog_item) { create :backlog_item }
  let(:poker_session) { create(:poker_session, meeting: meeting, backlog_item: backlog_item) }

  describe 'POST /api/meetings/:id/poker_sessions' do
    let(:method) { :post }
    let(:endpoint) { api_meeting_poker_sessions_path(meeting) }

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


  describe "POST ../poker_sessions/:id/rounds" do
    let(:method) { :post }
    let(:endpoint) { api_meeting_poker_session_rounds_path(meeting, poker_session) }

    let(:authenticable) { current_user }

    it_behaves_like "authenticated API endpoint"
    it_behaves_like "meeting action"

    it "should create a new round and return the new round in the response" do
      previous_round = poker_session.current_round
      do_api_request

      poker_session.reload
      expect(poker_session.current_round).to be > previous_round

      expected_body = { round: previous_round + 1 }.to_json
      expect(response.status).to eq(200) 
      expect(response.body).to be_json_eql(expected_body)
    end
  end # POST ../poker_sessions/:id/rounds

  describe "POST ../poker_sessions/:id/votes" do
    let(:method) { :post }
    let(:endpoint) { api_meeting_poker_session_votes_path(meeting, poker_session) }
    let(:estimate_option) { create :estimate_option }

    let(:authenticable) { current_user }

    before :each do
      current_user.participate!(meeting)
    end

    it_behaves_like "authenticated API endpoint"
    it_behaves_like "meeting action"

    it "succeeds and creates a new vote for the given round" do
      params = {
        vote: {
          decision: estimate_option.id,
          round: poker_session.current_round
        }
      }

      do_api_request params

      expect(response.status).to eq(200)
      expect(poker_session.has_voted?(current_user)).to be_true
    end

    it "fails if the given vote is invalid and respond with the validation errors" do
      params = {
        vote: {
          decision: -1,
          round: poker_session.current_round
        }
      }

      do_api_request params

      expect(response.status).to eq(422)
      expect(response.body).to have_json_path("decision")
    end

    it "fails if the current user is not part of the overarching meeting" do
      current_user.meeting_participations.destroy_all
      do_api_request
      expect(response.status).to eq(403)
    end

    it "fails if the user has already voted" do
      params = {
        vote: {
          decision: estimate_option.id,
          round: poker_session.current_round
        }
      }

      vote = build :poker_vote, user: current_user, round: poker_session.current_round
      poker_session.votes << vote

      do_api_request params

      expect(response.status).to eq(403)
    end
    
  end # POST ../poker_sessions:id/votes

  describe "POST ../poker_sessions/:id/decision" do
    let(:method) { :post }
    let(:endpoint) { api_meeting_poker_session_decision_path(meeting, poker_session) }
    let(:estimate_option) { create :estimate_option }

    let(:authenticable) { current_user }

    it_behaves_like "authenticated API endpoint"
    it_behaves_like "meeting action"


    it "it completes the poker session with the given decision" do
      params = {
        decision: estimate_option.id,
      }

      do_api_request params

      poker_session.reload

      expect(response.status).to eq(200)
      expect(poker_session.completed?).to be_true
      expect(poker_session.decision).to eq(estimate_option)
    end

    it "fails if the given decision is invalid and responds with the validation errors" do
      params = {
        decision: -1
      }

      do_api_request params

      expect(response.status).to eq(422)
      expect(response.body).to have_json_path("decision")
    end

  end # POST ../poker_sessions:id/decision

end
