module MageSpecHelper

  def get_authenticated_api_headers(user)
    headers = { 'API-TOKEN' => user.api_token.token }
  end

  def do_api_request params={}, headers=get_authenticated_api_headers(user)
    headers['Content-Type'] = 'application/json'
    self.send method, endpoint, params.to_json, headers
  end

end
