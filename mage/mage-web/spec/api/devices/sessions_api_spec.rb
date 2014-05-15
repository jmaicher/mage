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

    let :valid_auth_existing_credentials do
      {
        pin: pin.pin,
        id: device.id
      } 
    end

    let :valid_auth_new_credentials do
      {
         pin: pin.pin,
         device: {
           name: 'new_device'
         }
      }
    end

    before :each do
      reactive_stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/api/devices/sessions/confirm') { [200, {uuid: 'xyz'}] }
      end

      Reactive.set_stubs reactive_stubs
    end

    after :each do
      Reactive.clear_stubs
    end

    def do_request params = {}, headers = authenticated_headers
      post "/api/devices/sessions", params.to_json, headers
    end

    # extract
    it "should fail with unauthorized if api token not provided" do
      do_request valid_auth_existing_credentials, non_authenticated_headers
      expect(response.status).to eq(401)
    end

    context 'authenticate existing device' do

      it "should succeed if the given credentials are valid" do
        do_request valid_auth_existing_credentials

        expect(response.status).to eq(200)
      end

      it "should make the given pin invalid" do
        do_request valid_auth_existing_credentials
        do_request valid_auth_existing_credentials

        expect(response.status).to eq(400)
      end

      it "should fail with bad request if the given credentials are invalid" do
        do_request id: '-1', pin: '-2'

        expect(response.status).to eq(400)
      end

    end # existing

    context 'authenticate new device' do

      it "create a new device if the given credentials are valid" do
        do_request valid_auth_new_credentials

        expect(response.status).to eq(200)
      end

      it "should make the given pin invalid" do
        do_request valid_auth_new_credentials
        do_request valid_auth_new_credentials

        expect(response.status).to eq(400)
      end

      it "should fail with bad request if the pin is invalid" do
        do_request name: 'new_device', pin: '-2'

        expect(response.status).to eq(400)
      end

      it "should respond with validation errors if the given device params are invalid" do
        params = valid_auth_new_credentials
        params[:device][:name] = ''

        do_request pin: pin.pin, device: { name: params[:name] }
        
        params[:device][:device_type] = :table
        device = Device.new params[:device]
        device.valid?

        expected_body = device.errors.to_json
        actual_body = response.body

        expect(response.status).to eq(422)
        expect(actual_body).to be_json_eql(expected_body)
      end

    end # new

  end

end
