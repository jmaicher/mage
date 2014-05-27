class Reactive

  def initialize
    @conn = Faraday.new :url => 'http://localhost:9000' do |f|
      f.request  :json
      f.response :logger
      f.adapter Faraday.default_adapter
    end
  end

  def self.instance
    @@instance ||= Reactive.new
  end

  def confirm_device_auth(uuid, device)
    response = @conn.post '/api/devices/sessions/confirm', {
      uuid: uuid,
      authenticable: device.to_hash
    }

    return response.status === 200
  end

  def message_to(recipient, type, payload)
    payload = payload.to_hash unless payload.is_a?(Hash)

    # TODO: Define message types
    response = @conn.post '/api/messages', {
      recipient: recipient,
      message: {
        type: type,
        payload: payload
      }
    }

    return response.status == 200
  end

end

class ReactiveStub < Reactive

  def initialize(stubs)
    @conn = Faraday.new :url => 'http://localhost:9000' do |f|
      f.request  :json 
      f.adapter :test, stubs
    end
  end

end

