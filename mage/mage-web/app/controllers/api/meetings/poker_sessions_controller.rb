class API::Meetings::PokerSessionsController < API::ApplicationController
  before_filter :authenticate_from_token!
  before_filter :authorize_user!, only: [:create_vote]
  before_filter :meeting_filter
  before_filter :poker_session_filter, only: [:create_round, :create_vote, :complete]
  before_filter :authorize_meeting_participant!, only: [:create_vote]

  def create
    # authorize device or user?!
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

  def create_round
    # authorize device or user?!
    new_round = @poker_session.start_new_round!
    render json: { round: new_round }
  end

  def create_vote
    if @poker_session.current_round != vote_params[:round]
      return forbid! "Wrong round my friend!"
    end

    if @poker_session.has_voted?(current_user)
      return forbid! "Nice try, vote only once please!"
    end

    if !@poker_session.active?
      return forbid! "Sorry dude, a decision has been made!"
    end

    vote = @poker_session.build_vote_for(current_user, vote_params[:decision])
    if vote.save
      response = {}
      status = 200
    else
      response = vote.errors
      status = :unprocessable_entity
    end

    render json: response, status: status
  end

  def complete
    # authorize device or user?!

    if @poker_session.completed?
      return forbid! "A decision has already been made"
    end

    @poker_session.complete_with(decision_param)
    if @poker_session.save
      response = {}
      status = 200
    else
      response = @poker_session.errors
      status = :unprocessable_entity
    end

    render json: response, status: status
  end

private

  def forbid! message
    render status: :forbidden, json: { error: message }
  end

  def poker_session_params
    params.require(:poker_session).permit(:backlog_item_id)
  end

  def vote_params
    params.require(:vote).permit(:decision, :round)
  end

  def decision_param
    params.require(:decision)
  end

end
