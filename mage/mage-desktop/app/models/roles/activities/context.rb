require 'active_support/concern'

module Roles::Activities::Context
  extend ActiveSupport::Concern

  included do
    has_many :activities_as_context, class_name: "Activity", as: :context
  end
end # Roles::Activities::Actor
