class API::ApplicationController < ActionController::Base
  respond_to :json

  protect_from_forgery with: :null_session

  before_filter :cors_set_access_control_headers
  skip_before_filter :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end

protected

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, API-TOKEN'
  end

  def authenticate_from_token!
    given_token = request.headers['API-TOKEN'].presence
    token = given_token && API::Token.find_by_non_expired_token(given_token)

    if token
      authenticable = token.api_authenticable
      # store: false => do not store user in session
      sign_in authenticable, store: false
    else
      head :unauthorized
    end
  end

  def record_not_found(ex)
    render :json => ex.message, :status => :not_found
  end

  # -- Filter --------------------------------------------------

  def meeting_filter
    @meeting = Meeting.find params[:meeting_id]
  end

  def authorize_device!
    head :not_authorized if !device_signed_in?
  end

  def authorize_user!
    head :not_authorized if !user_signed_in?
  end

end
