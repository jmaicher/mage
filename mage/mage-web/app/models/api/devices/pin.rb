class API::Devices::Pin < ActiveRecord::Base
  after_initialize :ensure_pin

  def self.generate_unique_pin
    loop do
      pin = rand.to_s[2..7]
      break pin unless where(pin: pin).exists?
    end
  end 

protected

  def ensure_pin
    if pin.blank?
      self.pin = self.class.generate_unique_pin
    end
  end

end
