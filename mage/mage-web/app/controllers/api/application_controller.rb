class API::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

  after_filter :cors_set_access_control_headers
  skip_before_filter :verify_authenticity_token

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end
  
private

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

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

end
