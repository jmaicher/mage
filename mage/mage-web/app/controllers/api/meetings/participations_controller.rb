class API::Meetings::ParticipationsController < API::ApplicationController
  before_filter :authenticate_from_token!
  before_filter :authorize_user!
  before_filter :get_meeting

  def create
    unless current_user.participates_in?(@meeting)
      current_user.participate! @meeting
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

  def get_meeting
    @meeting = Meeting.find params[:meeting_id]
  end

end # ::ParticipationController
