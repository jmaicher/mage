class Reactive
  @@stubs = Faraday::Adapter::Test::Stubs.new

  def initialize
    @conn = Faraday.new :url => 'http://localhost:9000' do |f|
      f.request  :url_encoded
      if ! Rails.env.test?
        f.response :logger
        f.adapter Faraday.default_adapter
      else
        f.adapter :test, @@stubs
      end
    end
  end

  def confirm_device_auth(uuid, device)
    response = @conn.post '/api/devices/sessions/confirm', {
      uuid: uuid
    }

    return response.status === 200
  end

  def self.set_stubs(stubs)
    @@stubs = stubs
  end

  def self.clear_stubs
    @@stubs = Faraday::Adapter::Test::Stubs.new
  end

end
