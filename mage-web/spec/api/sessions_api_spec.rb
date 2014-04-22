require 'spec_helper'

describe 'Sessions API' do

  describe 'POST /api/sessions' do

    let :user do
      create :user
    end

    def do_request params
      headers = { 'CONTENT_TYPE' => 'application/json' }
      post "/api/sessions", params.to_json, headers
    end

    it "should respond with the api token when correct credentials are given" do
      do_request email: user.email, password: user.password

      expected_body = { email: user.email, api_token: user.api_token }.to_json
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should fail when email is invalid" do
      do_request email: "Invalid email", password: user.password 
      expect(response.status).to eq(401)
    end

    it "should fail when password is invalid" do
      do_request email: user.email, password: "Invalid" 
      expect(response.status).to eq(401)
    end

  end

end # Sessions API
