require 'active_support/concern'

module Roles::Activities::Actor
  extend ActiveSupport::Concern

  included do
    has_many :activities_as_actor, class_name: "Activity", as: :actor
  end

  def create_activity! key, params={}
    params[:key] = key
    params[:actor] = self
    Activity.create! params
  end

end # Roles::Activities::Actor
