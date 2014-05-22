class API::Meetings::ParticipationsController < API::ApplicationController
  before_filter :authenticate_from_token!
  before_filter :meeting_filter

  def create
    unless current_authenticable.participates_in?(@meeting)
      current_authenticable.participate! @meeting
      status = :ok
    else
      status = :forbidden
    end

    # TODO: Respond with representation
    head status
  end

private

  def authorize_user!
    head :not_authorized if !user_signed_in?
  end

end # ::ParticipationController
