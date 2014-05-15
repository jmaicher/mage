class API::SessionsController < API::ApplicationController

  def create
    user = User.find_for_database_authentication(email: credentials[:email])
    if user and user.valid_password?(credentials[:password])
      response = ::AuthenticableRepresenter.new(user)
      status = :ok
    else
      response = { message: "Invalid credentials" }
      status = :unauthorized
    end

    render json: response, status: status
  end

private

  def credentials
    params.permit(:email, :password)
  end

end
