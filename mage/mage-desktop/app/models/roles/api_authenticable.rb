require 'active_support/concern'

module Roles::APIAuthenticable
  extend ActiveSupport::Concern

  included do
    has_one :api_token, as: :api_authenticable,
      class_name: "API::Token",
      autosave: true

    after_initialize :ensure_api_token
  end

  def ensure_api_token
    if api_token.blank?
      self.build_api_token
    end
  end

end
