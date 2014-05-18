class API::Meetings::PokerSessionsController < API::ApplicationController
  before_filter :authenticate_from_token!
  before_filter :meeting_filter

  def create
    poker_session = @meeting.poker_sessions.build poker_session_params

    if poker_session.save
      status = :created
      response = PokerSessionRepresenter.new(poker_session)
    else
      status = :unprocessable_entity
      response = poker_session.errors
    end

    render json: response, status: status
  end

private

  def poker_session_params
    params.require(:poker_session).permit(:backlog_item_id)
  end

end
