require 'spec_helper'

describe 'Sessions API' do
  let(:user) { create :user }

  describe 'POST /api/sessions' do
    let(:method) { :post }
    let(:endpoint) { "/api/sessions" }

    it "should respond with the api token when correct credentials are given" do
      do_api_request email: user.email, password: user.password

      expected_body = AuthenticableRepresenter.new(user).to_json
      actual_body = response.body

      expect(response.status).to eq(200)
      expect(actual_body).to be_json_eql(expected_body)
    end

    it "should fail when email is invalid" do
      do_api_request email: "Invalid email", password: user.password 
      expect(response.status).to eq(401)
    end

    it "should fail when password is invalid" do
      do_api_request email: user.email, password: "Invalid" 
      expect(response.status).to eq(401)
    end

  end # POST /api/sessions

end # Sessions API
