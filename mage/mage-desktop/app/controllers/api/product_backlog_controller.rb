class API::ProductBacklogController < API::ApplicationController

  def show
    decorator = ProductBacklogRepresenter.new(product_backlog)
    respond_with decorator
  end

end
