class API::Devices::SessionsController < API::ApplicationController
  before_filter :authenticate_from_token!

  def create
    pin = API::Devices::Pin.find_by_pin(auth_params[:pin])
    device_id = auth_params[:id]
    device_params = auth_params["device"]

    if !pin || !(device_id || device_params)
      return head :bad_request
    end

    if device_id
      auth_existing(pin, device_id)
    else
      auth_new(pin, device_params)
    end
  end

private

  def auth_existing(pin, device_id)
    device = Device.find_by_id(device_id)

    if device
      confirm_auth(pin.uuid, device)
      invalidate_pin(pin)
      render json: device, status: :ok
    else
      head :bad_request
    end 
  end # auth_existing

  def auth_new(pin, device_params)
    device_params[:device_type] = :table
    device = Device.new(device_params)

    if device.save
      confirm_auth(pin.uuid, device)
      invalidate_pin(pin)
      response = device
      status = :ok
    else
      response = device.errors
      status = :unprocessable_entity
    end

    render json: response, status: status
  end # auth_new

  def confirm_auth(uuid, device)
    authenticable = AuthenticableRepresenter.new(device) 
    Reactive.new.confirm_device_auth(uuid, authenticable)
  end

  def invalidate_pin(pin)
    pin.destroy!
  end

  def auth_params
    params.permit(:pin, :id, :device => [:name])
  end

end # API::Devices::SessionsController
