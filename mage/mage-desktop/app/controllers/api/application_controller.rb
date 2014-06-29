class API::ApplicationController < BaseController
  respond_to :json

  protect_from_forgery with: :null_session

  before_filter :cors_set_access_control_headers
  skip_before_filter :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end

  def current_authenticable
    if user_signed_in?
      current_user
    else device_signed_in?
      current_device
    end
  end

  alias :current_actor :current_authenticable

protected

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, API-TOKEN'
  end

  def authenticate!
    unless authenticate_from_token
      # hand-off authentication to devise (=> cookie-based auth for desktop web interface)
      authenticate_user!
    end
  end

  def authenticate_from_token
    given_token = request.headers['API-TOKEN'].presence

    if given_token
      token = API::Token.find_by_non_expired_token(given_token)
      if token
        authenticable = token.api_authenticable
        sign_in authenticable, store: false
        true
      end
    end
  end

  def authenticate_from_token!
    unless authenticate_from_token
      head :unauthorized
    end
  end

  def record_not_found(ex)
    render :json => ex.message, :status => :not_found
  end

  # -- Authorization -------------------------------------------

  def authorize_device!
    head :not_authorized if !device_signed_in?
  end

  def authorize_user!
    head :not_authorized if !user_signed_in?
  end

  def authorize_meeting_participant!
    unless current_user.participates_in?(@meeting)
      render status: :forbidden, json: { error: "Nope, you're no meeting participant" }.to_json
    end
  end
end
