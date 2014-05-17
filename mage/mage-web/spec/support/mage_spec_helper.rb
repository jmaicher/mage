module MageSpecHelper

  def get_authenticated_api_headers(authenticable)
    headers = { 'API-TOKEN' => authenticable.api_token.token }
  end

  def do_api_request params={}, headers=get_authenticated_api_headers(authenticable)
    headers['Content-Type'] = 'application/json'
    self.send method, endpoint, params.to_json, headers
  end

end
