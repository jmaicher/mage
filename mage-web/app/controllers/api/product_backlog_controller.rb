class API::ProductBacklogController < API::ApplicationController

  def show
    backlog = ProductBacklog.get
    decorator = ProductBacklogRepresenter.new(backlog)
    respond_with decorator
  end

end
