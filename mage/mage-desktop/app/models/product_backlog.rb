class ProductBacklog < ActiveRecord::Base
  include Backlog

  def self.get_or_create
    self.first || ProductBacklog.create
  end
end
