module IntegrationTestHelper

  def sign_in(user, scope = :user)
    login_as(user, :scope => scope)
  end

end # IntegrationTestHelper
