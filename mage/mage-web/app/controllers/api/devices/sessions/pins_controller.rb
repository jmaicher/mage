class API::Devices::Sessions::PinsController < API::ApplicationController

  def create
    uuid = params.permit(:uuid)[:uuid]
    unless uuid.blank?
      pin = API::Devices::Pin.create! uuid: uuid
      response = { uuid: uuid, pin: pin.pin }
      status = :ok
    else
      response = { message: "uuid is required" }
      status = :bad_request
    end

    render json: response, status: status 
  end

end # API::Devices::Sessions::PinsController
