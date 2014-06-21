class API::BacklogItemsController < API::ApplicationController
  before_filter :authenticate!
  before_filter :backlog_item_filter, only: [:show]

  def show
    render json: BacklogItemRepresenter.new(@backlog_item)
  end

end # API::BacklogItemsController
