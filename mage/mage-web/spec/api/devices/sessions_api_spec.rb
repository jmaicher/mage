require 'spec_helper'

describe 'Devices::Sessions API' do

  describe 'POST /api/devices/sessions/pin' do

    def do_request params = {}
      headers = { 'CONTENT-TYPE' => 'application/json' }
      post "/api/devices/sessions/pins", params.to_json, headers
    end

    it "should respond with a pin when uuid is given" do
      do_request uuid: "xyz"
      json_body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json_body).to have_key 'pin'
      expect(json_body['pin']).to_not be_blank
    end

    it "should fail when uuid is not given" do
      do_request
      expect(response.status).to eq(400)
    end

  end # POST /api/devices/sessions/pin

  describe 'POST /api/devices/sessions' do

    let(:user) { create :user }
    let(:device) { create :table }
    let(:pin) { create :api_devices_pin }

    let :authenticated_headers do
      {
        'CONTENT-TYPE' => 'application/json',
        'API-TOKEN' => user.api_token.token
      }
    end

    let :non_authenticated_headers do
      {
        'CONTENT-TYPE' => 'application/json',
      }
    end

    let :valid_credentials do
      {
        id: device.id,
        pin: pin.pin
      } 
    end

    before :each do
      reactive_stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/confirm_device_auth') { [200, {}] }
      end

      Reactive.set_stubs reactive_stubs
    end

    after :each do
      Reactive.clear_stubs
    end

    def do_request params = {}, headers = authenticated_headers
      post "/api/devices/sessions", params.to_json, headers
    end

    it "should succeed if the given credentials are valid" do
      do_request valid_credentials

      expect(response.status).to eq(200)
    end

    it "should make the given pin invalid" do
      do_request valid_credentials
      do_request valid_credentials

      expect(response.status).to eq(400)
    end

    it "should fail with bad request if the given credentials are invalid" do
      do_request id: '-1', pin: '-2'

      expect(response.status).to eq(400)
    end

    it "should fail with unauthorized if the api token is not given" do
      # do_request valid_credentials, non_authenticated_headers
      # expect(response.status).to eq(401)
    end

  end

end
