require 'spec_helper'

describe 'Devices::Sessions API' do
  let(:user) { create :user }

  describe 'POST /api/devices/sessions/pin' do
    let(:method) { :post }
    let(:endpoint) { "/api/devices/sessions/pins" }

    it "should respond with a pin when uuid is given" do
      do_api_request uuid: "xyz"
      json_body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json_body).to have_key 'pin'
      expect(json_body['pin']).to_not be_blank
    end

    it "should fail when uuid is not given" do
      do_api_request
      expect(response.status).to eq(400)
    end

  end # POST /api/devices/sessions/pin

  describe 'POST /api/devices/sessions' do
    let(:method) { :post }
    let(:endpoint) { "/api/devices/sessions" }

    let(:device) { create :table }
    let(:pin) { create :api_devices_pin }

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

    after :each do
      Reactive.clear_stubs
    end

    it_behaves_like "authenticated API endpoint"

    context 'authenticate existing device' do

      before :each do
        reactive_stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          expected_args = {
            uuid: pin.uuid,
            authenticable: AuthenticableRepresenter.new(device).to_json
          }
          stub.post('/api/devices/sessions/confirm') { [200, {uuid: 'xyz'}] }
        end

        Reactive.set_stubs reactive_stubs
      end

      it "should succeed if the given credentials are valid" do
        do_api_request valid_auth_existing_credentials

        expect(response.status).to eq(200)
      end

      it "should make the given pin invalid by deleting it" do
        do_api_request valid_auth_existing_credentials
        API::Devices::Pin.find_by_pin(pin.pin).should be_nil
      end

      it "should fail with bad request if the given credentials are invalid" do
        do_api_request id: '-1', pin: '-2'

        expect(response.status).to eq(400)
      end

    end # existing

    context 'authenticate new device' do

      before :each do
        reactive_stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          # Note: We do not validate that is has been called with the correct params :-(
          stub.post('/api/devices/sessions/confirm') { [200, {}] }
        end

        Reactive.set_stubs reactive_stubs
      end

      it "create a new device if the given credentials are valid" do
        do_api_request valid_auth_new_credentials

        expect(response.status).to eq(200)
      end

      it "should make the given pin invalid by deleting it" do
        do_api_request valid_auth_new_credentials
        API::Devices::Pin.find_by_pin(pin.pin).should be_nil
      end

      it "should fail with bad request if the pin is invalid" do
        do_api_request name: 'new_device', pin: '-2'

        expect(response.status).to eq(400)
      end

      it "should respond with validation errors if the given device params are invalid" do
        params = valid_auth_new_credentials
        params[:device][:name] = ''

        do_api_request pin: pin.pin, device: { name: params[:name] }
        
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
