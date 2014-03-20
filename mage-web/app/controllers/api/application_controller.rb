class API::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

  after_filter :cors_set_access_control_headers
  
private

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = '*'
  end

end
