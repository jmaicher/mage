class API::Meetings::PokerSessionsController < API::ApplicationController
  before_filter :authenticate_from_token!
  before_filter :authorize_user!, only: [:create_vote]
  before_filter :meeting_filter
  before_filter :poker_session_filter, only: [:show, :create_round, :create_vote, :result, :complete]
  before_filter :authorize_meeting_participant!, only: [:create_vote]

  def show
    response = PokerSessionRepresenter.new(@poker_session).to_hash participant: current_user
    render json: response
  end

  def create
    # authorize device or user?!
    poker_session = @meeting.poker_sessions.build poker_session_params

    if poker_session.save
      status = :created
      response = PokerSessionRepresenter.new(poker_session).to_hash participant: current_user
      notify_participants('poker.started', response)
    else
      status = :unprocessable_entity
      response = poker_session.errors
    end

    render json: response, status: status
  end

  def create_round
    # authorize device or user?!
    new_round = @poker_session.start_new_round!
    response = { round: new_round }

    notify_participants('poker.restarted', response)
    render json: response
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
      if @poker_session.is_current_round_complete?
        payload = PokerRoundResultRepresenter.new(@poker_session)
        notify_participants('poker.round_completed', payload)
      end
    else
      response = vote.errors
      status = :unprocessable_entity
    end

    render json: response, status: status
  end

  def result
    result = PokerRoundResultRepresenter.new(@poker_session)
    render json: result
  end

  def complete
    if @poker_session.completed?
      return forbid! "A decision has already been made"
    end

    decision = decision_param[:decision]
    @poker_session.complete_with(decision)
    if @poker_session.save
      response = { decision: decision }
      notify_participants('poker.completed', response)
      status = 200
    else
      response = @poker_session.errors
      status = :unprocessable_entity
    end

    render json: response, status: status
  end

private

  def notify_participants(type, payload)
    Reactive.instance.message_to("/meetings/#{@meeting.id}", type, payload)
  end

  def forbid! message
    render status: :forbidden, json: { error: message }
  end

  def poker_session_params
    params.permit(:backlog_item_id)
  end

  def vote_params
    params.permit(:decision, :round)
  end

  def decision_param
    params.permit(:decision)
  end

end
