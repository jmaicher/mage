
FactoryGirl.define do
  factory :api_devices_pin, :class => 'API::Devices::Pin' do
    pin "123456"
    uuid "xyz"
  end
end
