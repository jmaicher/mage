class API::ProductBacklogController < API::ApplicationController
  before_filter :authenticate!, only: :insert

  def show
    decorator = ProductBacklogRepresenter.new(product_backlog)
    respond_with decorator
  end

  def insert
    backlog_item_id = params.require(:backlog_item_id)
    priority = Integer(params.require(:priority)) rescue nil

    item = product_backlog.items.where(id: backlog_item_id).first
    unless item.nil?
      product_backlog.insert_at(item, priority)
      status = 201
      response = ProductBacklogRepresenter.new(product_backlog)
    else
      response = nil
      status = 422
    end

    render json: response, status: status
  end

end
