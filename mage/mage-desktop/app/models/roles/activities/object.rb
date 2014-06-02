require 'active_support/concern'

module Roles::Activities::Object
  extend ActiveSupport::Concern

  included do
    has_many :activities_as_object,
      class_name: "Activity", foreign_key: "activity_object_id", as: :object
  end
end # Roles::Activities::Actor
