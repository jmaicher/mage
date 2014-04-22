class API::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

  after_filter :cors_set_access_control_headers
  skip_before_filter :verify_authenticity_token

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end
  
private

  def authenticate_user_from_token!
    token = request.headers['API-TOKEN'].presence
    user = token && User.find_by_api_token(token)

    if user
      # store: false => do not store user in session
      sign_in user, store: false
    end

    # invoke device authentication logic
    # suggested here: https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
    authenticate_user!
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

end
